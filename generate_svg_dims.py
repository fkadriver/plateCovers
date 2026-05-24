#!/usr/bin/env python3
"""
Scan all .svg files in the current directory, compute the bounding box of
each shape (respecting group transforms), and write dim_svg.txt as an
OpenSCAD include file.

Usage:
    python3 generate_svg_dims.py

Re-run whenever SVG files change. The main .scad file includes dim_svg.txt.
Variable names: svg_<stem>_w and svg_<stem>_h  (e.g. svg_LeftS_w)
"""

import os
import re
import xml.etree.ElementTree as ET


def _parse_translate(transform_str):
    """Return (tx, ty) from a 'translate(tx, ty)' attribute, else (0, 0)."""
    if not transform_str:
        return 0.0, 0.0
    m = re.search(r'translate\(\s*([^\s,\)]+)[\s,]+([^\s,\)]+)\s*\)', transform_str)
    if m:
        return float(m.group(1)), float(m.group(2))
    return 0.0, 0.0


def _bbox_of_path(path_d, tx=0.0, ty=0.0):
    """
    Compute bounding box of an SVG path string with an applied translation.
    Supports M/m, L/l, C/c commands (covers all current project SVGs).
    Returns (min_x, max_x, min_y, max_y) or None if path is empty.
    """
    pts = []
    tokens = re.findall(
        r'[MmLlCcSsQqTtAaZz]|[-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?',
        path_d
    )
    i, cx, cy, cmd = 0, 0.0, 0.0, None
    while i < len(tokens):
        tok = tokens[i]
        if tok in 'MmLlCcSsQqTtAaZz':
            cmd = tok
            i += 1
        else:
            if cmd == 'M':
                cx, cy = float(tokens[i]), float(tokens[i+1]); i += 2
                pts.append((cx + tx, cy + ty)); cmd = 'L'
            elif cmd == 'm':
                cx += float(tokens[i]); cy += float(tokens[i+1]); i += 2
                pts.append((cx + tx, cy + ty)); cmd = 'l'
            elif cmd == 'L':
                cx, cy = float(tokens[i]), float(tokens[i+1]); i += 2
                pts.append((cx + tx, cy + ty))
            elif cmd == 'l':
                cx += float(tokens[i]); cy += float(tokens[i+1]); i += 2
                pts.append((cx + tx, cy + ty))
            elif cmd == 'C':
                x1, y1 = float(tokens[i]),   float(tokens[i+1])
                x2, y2 = float(tokens[i+2]), float(tokens[i+3])
                ex, ey = float(tokens[i+4]), float(tokens[i+5]); i += 6
                pts += [(x1+tx, y1+ty), (x2+tx, y2+ty)]
                cx, cy = ex, ey
                pts.append((cx + tx, cy + ty))
            elif cmd == 'c':
                dx1, dy1 = float(tokens[i]),   float(tokens[i+1])
                dx2, dy2 = float(tokens[i+2]), float(tokens[i+3])
                dex, dey = float(tokens[i+4]), float(tokens[i+5]); i += 6
                pts += [(cx+dx1+tx, cy+dy1+ty), (cx+dx2+tx, cy+dy2+ty)]
                cx += dex; cy += dey
                pts.append((cx + tx, cy + ty))
            elif cmd in 'Zz':
                pass
            else:
                i += 1  # skip unsupported command arguments

    if not pts:
        return None
    xs = [p[0] for p in pts]
    ys = [p[1] for p in pts]
    return min(xs), max(xs), min(ys), max(ys)


def _collect_paths(element, inherited_tx=0.0, inherited_ty=0.0):
    """
    Recursively walk an XML element tree, accumulating group transforms and
    collecting (path_d, tx, ty) for each path element found.
    """
    results = []
    tag = element.tag.split('}')[-1]  # strip namespace

    if tag == 'g':
        dtx, dty = _parse_translate(element.get('transform', ''))
        group_tx = inherited_tx + dtx
        group_ty = inherited_ty + dty
        for child in element:
            results.extend(_collect_paths(child, group_tx, group_ty))
    elif tag == 'path':
        d = element.get('d', '')
        if d:
            results.append((d, inherited_tx, inherited_ty))

    return results


def svg_bounding_box(filepath):
    """
    Return (width, height) of all path content in an SVG file (mm).
    Group transforms are applied. Returns None if no usable paths found.
    """
    try:
        tree = ET.parse(filepath)
    except ET.ParseError as e:
        print(f"  Warning: could not parse {filepath}: {e}")
        return None

    root = tree.getroot()
    all_paths = []
    for child in root:
        all_paths.extend(_collect_paths(child, 0.0, 0.0))
    # also direct path children of root
    for child in root:
        tag = child.tag.split('}')[-1]
        if tag == 'path':
            d = child.get('d', '')
            if d:
                all_paths.append((d, 0.0, 0.0))

    boxes = [_bbox_of_path(d, tx, ty) for d, tx, ty in all_paths]
    boxes = [b for b in boxes if b is not None]
    if not boxes:
        return None

    mn_x = min(b[0] for b in boxes)
    mx_x = max(b[1] for b in boxes)
    mn_y = min(b[2] for b in boxes)
    mx_y = max(b[3] for b in boxes)
    return mx_x - mn_x, mx_y - mn_y


def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    svg_files = sorted(
        f for f in os.listdir(script_dir) if f.lower().endswith('.svg')
    )

    if not svg_files:
        print("No SVG files found.")
        return

    lines = [
        "// Auto-generated by generate_svg_dims.py — do not edit by hand.",
        "// SVG bounding box dimensions; shapes are centered at the coordinate origin.",
        "// Re-run generate_svg_dims.py after modifying any SVG file.",
        "",
    ]

    print(f"{'File':<30} {'Width (mm)':>12} {'Height (mm)':>12}")
    print("-" * 56)

    for svg_file in svg_files:
        filepath = os.path.join(script_dir, svg_file)
        result = svg_bounding_box(filepath)
        if result is None:
            print(f"  {svg_file}: no path data found, skipping")
            continue

        w, h = result
        stem = re.sub(r'[^A-Za-z0-9]', '_', os.path.splitext(svg_file)[0])
        lines.append(f"svg_{stem}_w = {w:.4f};  // {svg_file} — width  (mm)")
        lines.append(f"svg_{stem}_h = {h:.4f};  // {svg_file} — height (mm)")
        print(f"{svg_file:<30} {w:>12.4f} {h:>12.4f}")

    out_path = os.path.join(script_dir, "dim_svg.txt")
    with open(out_path, 'w') as f:
        f.write('\n'.join(lines) + '\n')

    print(f"\nWritten to {out_path}")


if __name__ == "__main__":
    main()

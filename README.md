# Crown Wall Plate Cover Generator

Parametric OpenSCAD generator for decorative electrical wall plate covers. Produces 3D-printable plates with a crown edge profile, fleur-de-lis corner ornaments, and scroll-work accents — all driven by the OpenSCAD Customizer.

![outputs](outputs/2Gang_2Rocker_Jumbo_Crown.stl)

---

## Features

- **1 or 2 gang** plates
- **Three plate sizes** — Standard, Junior-Jumbo, Jumbo
- **Connector types per gang** — Toggle Switch, Rocker, Duplex Outlet, Blank, or None
- **Edge profiles** — Crown (default), Fillet, Chamfer, Flat
- **Decorative crown profile** — bead rail, fleur-de-lis corner ornaments, and horizontal/vertical scroll-work imported from SVG
- **Seven color schemes** for preview rendering
- **Embossed opening rims** with rounded Minkowski edges

---

## Plate Dimensions

| Size | Height | Width (1-gang) | Width (2-gang) |
|------|--------|---------------|----------------|
| Standard | 114.3 mm | 69.85 mm | 115.89 mm |
| Junior-Jumbo | 123.825 mm | 79.375 mm | 125.41 mm |
| Jumbo | 133.35 mm | 88.9 mm | 134.94 mm |

Gang spacing (center-to-center): 46.04 mm. Plate body thickness: 6 mm.

---

## Files

| File | Description |
|------|-------------|
| `AdditionPlate Generator.scad` | Main parametric model |
| `CornerFleur.svg` | Corner fleur-de-lis ornament (centered at origin) |
| `LeftS.svg` | Left/right vertical scroll-work (centered at origin) |
| `GV_J.svg` | Top/bottom horizontal scroll-work (centered at origin) |
| `dim_svg.txt` | Auto-generated SVG bounding-box dimensions (OpenSCAD include) |
| `generate_svg_dims.py` | Python script that produces `dim_svg.txt` |
| `outputs/` | Pre-rendered STL files |
| `originals/` | Original/reference SCAD and SVG files |

---

## Requirements

- [OpenSCAD](https://openscad.org/) 2021.01 or later
- Python 3 (only needed if you modify the SVG files)

---

## Usage

Open `AdditionPlate Generator.scad` in OpenSCAD. The Customizer panel exposes all parameters:

| Parameter | Options | Description |
|-----------|---------|-------------|
| `plate_width` | 1, 2 | Number of gangs |
| `plate_size` | 0 Standard, 1 Jr-Jumbo, 2 Jumbo | Overall plate size |
| `edge_profile` | crown, fillet, chamfer, flat | Edge treatment |
| `gang1_top` | none, blank, toggle, rocker, outlet | Gang 1 connector type |
| `gang2_top` | none, blank, toggle, rocker, outlet | Gang 2 connector type |
| `color_scheme` | Silver+Gold, Ivory+Gold, White+DarkRed, Gray+Brown, Navy+Gold, Black+Gold, Distressed | Preview color palette |

Render with **F6**, then export STL with **F7**.

---

## SVG Decorations

The three SVG files are imported directly by OpenSCAD. Each is centered at the coordinate origin so that `import("file.svg")` places the shape centered at world (0, 0) — no `center=true` needed (that parameter is unreliable in current OpenSCAD builds).

If you replace or modify any SVG, regenerate the dimension table:

```bash
python3 generate_svg_dims.py
```

This rewrites `dim_svg.txt`, which the SCAD file includes for bounding-box variables (`svg_CornerFleur_w`, `svg_LeftS_h`, etc.) available for positioning calculations.

### SVG coordinate requirements

OpenSCAD imports SVG path data using a direct (x, −y) coordinate mapping with no viewBox offset. To be usable at origin, an SVG must:

1. Have its path data (after all group transforms) **centered at SVG (0, 0)**.
2. Have **no `viewBox` attribute** — OpenSCAD uses raw path coordinates as mm values.

---

## Static Tuning Parameters

These live at the top of the SCAD file and are not exposed in the Customizer:

| Variable | Default | Description |
|----------|---------|-------------|
| `fleur_inset` | 40 mm | Distance from plate corner to fleur-de-lis center |
| `fleur_scale` | 0.95 | Tip taper scale for extruded fleurs |
| `scroll_scale` | 0.95 | Tip taper scale for extruded scroll-work |
| `scroll_h_offset` | 8 mm | Horizontal spacing of the paired top/bottom scrolls |

---

## License

Released to the public domain. Print, remix, and share freely.

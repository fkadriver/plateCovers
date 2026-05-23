// Crown Wall Plate — Font & Scrollwork Tester
// Fixed: 2-gang, Jumbo, Crown edge profile
// Tests script fonts for scrollwork and Fleur de Lis glyph selection.

  //////////////////////////f
 // Customizer Settings: //
//////////////////////////

// Gang 1 — connector
gang1_top = "none"; // ["none":None, "blank":Blank, "toggle":Toggle Switch, "rocker":Rocker, "outlet":Duplex Outlet]

// Gang 2 — connector
gang2_top = "none"; // ["none":None, "blank":Blank, "toggle":Toggle Switch, "rocker":Rocker, "outlet":Duplex Outlet]

// Fleur — Unicode code point (4 hex digits, e.g. 004B = K)
fleur_hex = "004B";

// Fleur size (points)
fleur_size = 30; // [8:60]

// Fleur taper — 1.0 = flat face, 0.0 = sharp point
fleur_scale = 0.5; // [0:0.05:1]

// Scroll text — top character(s)
scroll_line1 = "S";

// Scroll text — bottom character(s)
scroll_line2 = "J";

// Scroll font
scroll_font = "Zapfino"; // ["Academy Engraved LET":Academy Engraved LET, "Allura":Allura, "Andale Mono":Andale Mono, "Apple Chancery":Apple Chancery, "Arial":Arial, "Arial Black":Arial Black, "Arial Rounded MT Bold":Arial Rounded MT Bold, "Arial Unicode MS":Arial Unicode MS, "Big Caslon":Big Caslon, "Bodoni 72 Smallcaps":Bodoni 72 Smallcaps, "Bradley Hand":Bradley Hand, "Brush Script MT":Brush Script MT, "Chalkduster":Chalkduster, "Comic Sans MS":Comic Sans MS, "DIN Alternate":DIN Alternate, "DIN Condensed":DIN Condensed, "EB Garamond 08":EB Garamond 08, "EB Garamond 12":EB Garamond 12, "EB Garamond SC 12":EB Garamond SC 12, "Fleur De Leah":Fleur De Leah, "Fleur de Lis":Fleur de Lis, "Fleurons":Fleurons, "Geneva":Geneva, "Georgia":Georgia, "Great Vibes":Great Vibes, "Herculanum":Herculanum, "Hoefler Text Ornaments":Hoefler Text Ornaments, "Impact":Impact, "Inter Variable":Inter Variable, "Junicode":Junicode, "Junicode VF":Junicode VF, "Libre Baskerville":Libre Baskerville, "Luminari":Luminari, "Monaco":Monaco, "Old Standard":Old Standard, "Parisienne":Parisienne, "Party LET":Party LET, "Sathu":Sathu, "Skia":Skia, "Source Sans 3":Source Sans 3, "Symbola":Symbola, "Tahoma":Tahoma, "Times New Roman":Times New Roman, "Trattatello":Trattatello, "Trebuchet MS":Trebuchet MS, "Verdana":Verdana, "Webdings":Webdings, "Wingdings":Wingdings, "Wingdings 2":Wingdings 2, "Wingdings 3":Wingdings 3, "Zapf Dingbats":Zapf Dingbats, "Zapfino":Zapfino]

// Scroll text size (points)
scroll_size = 28; // [8:80]

// Overlap between lines — positive overlaps, 0 = touching, negative = gap (mm)
scroll_overlap = 5; // [-20:1:40]

// Scroll taper — 1.0 = flat face, 0.0 = sharp point
scroll_scale = 0.7; // [0:0.05:1]

// Preview color — plate body
color_plate = "WhiteSmoke"; // ["WhiteSmoke":White Smoke, "Ivory":Ivory, "Gainsboro":Gainsboro, "Silver":Silver, "LightGray":Light Gray, "Tan":Tan, "BurlyWood":Burly Wood, "Peru":Peru, "SaddleBrown":Saddle Brown, "Maroon":Maroon, "MidnightBlue":Midnight Blue, "DarkSlateBlue":Dark Slate Blue, "DarkGreen":Dark Green]

// Preview color — raised bead
color_bead = "Goldenrod"; // ["Goldenrod":Goldenrod, "Gold":Gold, "DarkGoldenrod":Dark Goldenrod, "Peru":Peru, "Sienna":Sienna, "SaddleBrown":Saddle Brown, "Chocolate":Chocolate, "Maroon":Maroon, "Ivory":Ivory, "Silver":Silver, "SlateGray":Slate Gray, "CornflowerBlue":Cornflower Blue, "SteelBlue":Steel Blue, "DarkSlateBlue":Dark Slate Blue]

// Preview color — fleur de lis
color_fleur = "SaddleBrown"; // ["SaddleBrown":Saddle Brown, "Sienna":Sienna, "Peru":Peru, "Chocolate":Chocolate, "Maroon":Maroon, "DarkRed":Dark Red, "Gold":Gold, "Goldenrod":Goldenrod, "Ivory":Ivory, "Silver":Silver, "SlateGray":Slate Gray, "MidnightBlue":Midnight Blue, "DarkSlateBlue":Dark Slate Blue, "DarkGreen":Dark Green]

// Preview color — scroll text
color_scroll = "DarkSlateBlue"; // ["DarkSlateBlue":Dark Slate Blue, "MidnightBlue":Midnight Blue, "Navy":Navy, "SaddleBrown":Saddle Brown, "Maroon":Maroon, "DarkRed":Dark Red, "DarkGreen":Dark Green, "DarkOliveGreen":Dark Olive Green, "Goldenrod":Goldenrod, "Gold":Gold, "Sienna":Sienna, "Silver":Silver, "SlateGray":Slate Gray, "Ivory":Ivory]

  //////////////////////
 // Static Settings: //
//////////////////////

module GoAwayCustomizer() {}

// Fixed plate configuration
plate_width  = 2;
plate_size   = 2;
edge_profile = "crown";

fleur_font = "Fleur de Lis:style=Regular";

function _hd(c) =
    c=="0"?0: c=="1"?1: c=="2"?2: c=="3"?3: c=="4"?4:
    c=="5"?5: c=="6"?6: c=="7"?7: c=="8"?8: c=="9"?9:
    c=="A"?10: c=="B"?11: c=="C"?12: c=="D"?13: c=="E"?14: c=="F"?15:
    c=="a"?10: c=="b"?11: c=="c"?12: c=="d"?13: c=="e"?14: c=="f"?15: 0;

function _hex4(s) = _hd(s[0])*4096 + _hd(s[1])*256 + _hd(s[2])*16 + _hd(s[3]);

fleur_symbol = chr(_hex4(fleur_hex));

function top_type(n) =
    n == 0 ? gang1_top :
    n == 1 ? gang2_top : "none";

l_offset      = [34.925, 39.6875, 44.45];
r_offset      = [34.925, 39.6875, 44.45];
switch_offset = 46.0375;
solid_plate_width = l_offset[plate_size] + switch_offset * (plate_width - 1) + r_offset[plate_size];

height_sizes   = [114.3, 123.825, 133.35];
edgewidth      = solid_plate_width + 10;
rightbevel     = solid_plate_width - 4;
thinner_offset = [0, 0.92, 0.95, 0.96, 0.97, 0.973];

profile_r = 3;
bead_r    = 1.5;

// preview[view:north, tilt:bottom]

  /////////////////////
 // Gang Controller: //
/////////////////////

module plate_gang(n) {
    top   = top_type(n);
    y_off = l_offset[plate_size] + switch_offset * n;

    if (top == "toggle") {
        translate([0, y_off, 0]) toggle_screws();
        translate([0, y_off, 0]) hole("toggle");
    }
    else if (top == "rocker") {
        translate([0, y_off, 0]) rocker_screws();
        translate([0, y_off, 0]) hole("rocker");
    }
    else if (top == "outlet") {
        translate([0, y_off, 0]) hole("outlet");
    }
    else {
        translate([0, y_off, 0]) box_screws();
    }
}

  ///////////////////
 // PlateStation: //
///////////////////

module plate_profile_cuts() {
    ph = height_sizes[plate_size];
    pw = solid_plate_width;
    e  = 5;
    r  = profile_r;
    translate([0, -e, 6]) rotate([-90,0,0]) cylinder(r=r, h=pw+e*2, $fn=32);
    translate([ph,-e, 6]) rotate([-90,0,0]) cylinder(r=r, h=pw+e*2, $fn=32);
    translate([-e, 0, 6]) rotate([0, 90,0]) cylinder(r=r, h=ph+e*2, $fn=32);
    translate([-e,pw, 6]) rotate([0, 90,0]) cylinder(r=r, h=ph+e*2, $fn=32);
    translate([ 0,  0, 6]) sphere(r=r, $fn=32);
    translate([ 0, pw, 6]) sphere(r=r, $fn=32);
    translate([ph,  0, 6]) sphere(r=r, $fn=32);
    translate([ph, pw, 6]) sphere(r=r, $fn=32);
}

module plate_profile_additions() {
    ph = height_sizes[plate_size];
    pw = solid_plate_width;
    bead_inset = profile_r + 2*bead_r;
    inner_y2   = pw - 2*bead_inset;
    inner_x2   = ph - 2*bead_inset;
    translate([bead_inset,    bead_inset, 6]) rotate([-90,0,0]) cylinder(r=bead_r, h=inner_y2, $fn=32);
    translate([ph-bead_inset, bead_inset, 6]) rotate([-90,0,0]) cylinder(r=bead_r, h=inner_y2, $fn=32);
    translate([bead_inset,    bead_inset, 6]) rotate([0, 90,0])  cylinder(r=bead_r, h=inner_x2, $fn=32);
    translate([bead_inset, pw-bead_inset, 6]) rotate([0, 90,0])  cylinder(r=bead_r, h=inner_x2, $fn=32);
    translate([bead_inset,    bead_inset, 6]) sphere(r=bead_r, $fn=32);
    translate([bead_inset, pw-bead_inset, 6]) sphere(r=bead_r, $fn=32);
    translate([ph-bead_inset, bead_inset, 6]) sphere(r=bead_r, $fn=32);
    translate([ph-bead_inset, pw-bead_inset, 6]) sphere(r=bead_r, $fn=32);
}

module plate_profile_fleurs() {
    ph = height_sizes[plate_size];
    pw = solid_plate_width;
    bead_inset = profile_r + 2*bead_r;
    fi = bead_inset + fleur_size/2;
    corners = [
        [fi,    fi,      135],
        [fi,    pw-fi,    45],
        [ph-fi, fi,      225],
        [ph-fi, pw-fi,   315],
    ];
    for (c = corners) {
        translate([c[0], c[1], 6])
            rotate([0, 0, c[2]])
                linear_extrude(height=bead_r, scale=fleur_scale)
                    text(fleur_symbol, size=fleur_size,
                         font=fleur_font,
                         halign="center", valign="center");
    }
}

// Two lines of scrollwork stacked vertically on the left side, between the corner fleurs.
// Each line is a separate extrusion so they can overlap independently.
// step > 0 = gap between lines; step < 0 = overlap.
module plate_scroll_left() {
    ph = height_sizes[plate_size];
    bead_inset = profile_r + 2*bead_r;
    fi = bead_inset + fleur_size/2;
    step = scroll_size - scroll_overlap;

    // Line 1 — top
    translate([ph/2 - step/2, fi, 6])
        rotate([0, 0, 90])
            linear_extrude(height=bead_r, scale=scroll_scale)
                text(scroll_line1, size=scroll_size,
                     font=scroll_font,
                     halign="center", valign="center");

    // Line 2 — bottom
    translate([ph/2 + step/2, fi, 6])
        rotate([0, 0, 90])
            linear_extrude(height=bead_r, scale=scroll_scale)
                text(scroll_line2, size=scroll_size,
                     font=scroll_font,
                     halign="center", valign="center");
}

module plate_body() {
    difference() {
        cube([height_sizes[plate_size], solid_plate_width, 6]);
        plate_profile_cuts();
    }
}

module plate_inner() {
    ts = plate_width < len(thinner_offset)
       ? thinner_offset[plate_width]
       : thinner_offset[len(thinner_offset)-1];
    scale([0.95, ts, 1])
    translate([3, 3, 0])
    difference() {
        cube([height_sizes[plate_size], solid_plate_width, 6]);
        plate_profile_cuts();
    }
}

  ////////////////
 // Screw Holes //
////////////////

module box_screws() {
    translate([height_sizes[plate_size]/2 + 41.67125, 0, -1]) cylinder(r=2, h=10, $fn=12);
    translate([height_sizes[plate_size]/2 + 41.67125, 0,  3.5]) cylinder(r1=2, r2=3.3, h=3);
    translate([height_sizes[plate_size]/2 - 41.67125, 0, -1]) cylinder(r=2, h=10, $fn=12);
    translate([height_sizes[plate_size]/2 - 41.67125, 0,  3.5]) cylinder(r1=2, r2=3.3, h=3);
}

module rocker_screws() {
    translate([height_sizes[plate_size]/2 + 48.41875, 0, -1]) cylinder(r=2, h=10, $fn=12);
    translate([height_sizes[plate_size]/2 + 48.41875, 0,  3.5]) cylinder(r1=2, r2=3.3, h=3);
    translate([height_sizes[plate_size]/2 - 48.41875, 0, -1]) cylinder(r=2, h=10, $fn=12);
    translate([height_sizes[plate_size]/2 - 48.41875, 0,  3.5]) cylinder(r1=2, r2=3.3, h=3);
}

module toggle_screws() {
    translate([height_sizes[plate_size]/2 + 30.1625, 0, -1]) cylinder(r=2, h=10, $fn=12);
    translate([height_sizes[plate_size]/2 + 30.1625, 0,  3.5]) cylinder(r1=2, r2=3.3, h=3);
    translate([height_sizes[plate_size]/2 - 30.1625, 0, -1]) cylinder(r=2, h=10, $fn=12);
    translate([height_sizes[plate_size]/2 - 30.1625, 0,  3.5]) cylinder(r1=2, r2=3.3, h=3);
}

  ///////////////////
 // Hole Cutouts: //
///////////////////

module hole(hole_type) {
    if (hole_type == "toggle") {
        translate([height_sizes[plate_size]/2, 0, 0]) cube([23.8125, 10.3188, 15], center=true);
    }
    if (hole_type == "rocker") {
        translate([height_sizes[plate_size]/2, 0, 0]) cube([67.1, 33.3, 15], center=true);
    }
    if (hole_type == "outlet") {
        translate([height_sizes[plate_size]/2 + 19.3915, 0, 0])
            difference() {
                cylinder(r=17.4625, h=15, center=true);
                translate([-24.2875,-15,-2]) cube([10,37,15]);
                translate([ 14.2875,-15,-2]) cube([10,37,15]);
            }
        translate([height_sizes[plate_size]/2 - 19.3915, 0, 0])
            difference() {
                cylinder(r=17.4625, h=15, center=true);
                translate([-24.2875,-15,-2]) cube([10,37,15]);
                translate([ 14.2875,-15,-2]) cube([10,37,15]);
            }
        translate([height_sizes[plate_size]/2, 0, -1]) cylinder(r=2, h=10);
        translate([height_sizes[plate_size]/2, 0,  3.5]) cylinder(r1=2, r2=3.3, h=3);
    }
    // "blank" and "none": no cutout
}

  ////////////////////////
 // Number One ENGAGE: //
////////////////////////

rotate([0, 180, 90])
translate([-height_sizes[plate_size]/2, -solid_plate_width/2, -6]) {

    color(color_plate) difference() {
        plate_body();
        translate([0, 0, -3]) plate_inner();
        for (n = [0 : plate_width-1]) plate_gang(n);
    }
    color(color_bead)   plate_profile_additions();
    color(color_fleur)  plate_profile_fleurs();
    color(color_scroll) plate_scroll_left();

}

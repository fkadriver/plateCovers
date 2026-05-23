// Crown Wall Plate — Fleur de Lis Tester
// Stripped to 1–2 gangs, top connector only (Rocker / Toggle / Duplex / Blank)
// Fleur symbol and size are customizer inputs for easy testing.

  //////////////////////////
 // Customizer Settings: //
//////////////////////////

// How many gangs?
plate_width = 1; // [1:2]

// Plate size
plate_size = 2; // [0:Standard, 1:Junior-Jumbo, 2:Jumbo]

// Edge profile applied to all sides
edge_profile = "crown"; // ["chamfer":Chamfer, "flat":Flat, "fillet":Fillet, "crown":Crown]

// Gang 1 — connector
gang1_top = "none"; // ["none":None, "blank":Blank, "toggle":Toggle Switch, "rocker":Rocker, "outlet":Duplex Outlet]

// Gang 2 — connector
gang2_top = "none"; // ["none":None, "blank":Blank, "toggle":Toggle Switch, "rocker":Rocker, "outlet":Duplex Outlet]

// Unicode code point — 4 hex digits from your chart (e.g. 004B for K)
fleur_hex = "004B";

// Symbol size (points)
fleur_size = 30; // [8:60]

// Symbol taper — 1.0 = no taper, 0.0 = sharp point
fleur_scale = 0.5; // [0:0.05:1]

// Preview color — plate body
color_plate = "WhiteSmoke"; // ["WhiteSmoke":White Smoke, "Ivory":Ivory, "Gainsboro":Gainsboro, "Silver":Silver, "LightGray":Light Gray, "Gray":Gray, "SlateGray":Slate Gray, "Tan":Tan, "BurlyWood":Burly Wood, "Peru":Peru, "Sienna":Sienna, "SaddleBrown":Saddle Brown, "Maroon":Maroon, "Navy":Navy, "MidnightBlue":Midnight Blue, "DarkSlateBlue":Dark Slate Blue, "DarkGreen":Dark Green, "DarkOliveGreen":Dark Olive Green]

// Preview color — raised bead
color_bead = "Goldenrod"; // ["Goldenrod":Goldenrod, "Gold":Gold, "DarkGoldenrod":Dark Goldenrod, "Peru":Peru, "Sienna":Sienna, "SaddleBrown":Saddle Brown, "Chocolate":Chocolate, "Maroon":Maroon, "Ivory":Ivory, "WhiteSmoke":White Smoke, "Silver":Silver, "Gray":Gray, "SlateGray":Slate Gray, "DarkSlateGray":Dark Slate Gray, "CornflowerBlue":Cornflower Blue, "SteelBlue":Steel Blue, "DarkSlateBlue":Dark Slate Blue]

// Preview color — fleur de lis
color_fleur = "SaddleBrown"; // ["SaddleBrown":Saddle Brown, "Sienna":Sienna, "Peru":Peru, "Chocolate":Chocolate, "Maroon":Maroon, "DarkRed":Dark Red, "Gold":Gold, "Goldenrod":Goldenrod, "DarkGoldenrod":Dark Goldenrod, "Ivory":Ivory, "WhiteSmoke":White Smoke, "Silver":Silver, "SlateGray":Slate Gray, "DarkSlateGray":Dark Slate Gray, "MidnightBlue":Midnight Blue, "DarkSlateBlue":Dark Slate Blue, "DarkGreen":Dark Green]

  //////////////////////
 // Static Settings: //
//////////////////////

module GoAwayCustomizer() {}

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

height_sizes  = [114.3, 123.825, 133.35];

edgewidth     = solid_plate_width + 10;
rightbevel    = solid_plate_width - 4;

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
		// "none" or "blank": screw holes only, no connector cutout
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

	if (edge_profile == "chamfer") {
		translate([-4.3,-e,6.2]) rotate([0,45,0]) cube([6,pw+e*2,6]);
		translate([ph-4.2,-e,6.25]) rotate([0,45,0]) cube([6,pw+e*2,6]);
		translate([ph+10,-4.4,6.1]) rotate([0,45,90]) cube([6,ph+20,6]);
		translate([ph+10,rightbevel,6]) rotate([0,45,90]) cube([6,ph+10,6]);
	}
	else if (edge_profile == "fillet") {
		translate([0,-e,6-r]) difference() {
			cube([r,pw+e*2,r]);
			translate([r,-1,0]) rotate([-90,0,0]) cylinder(r=r,h=pw+e*2+2,$fn=32);
		}
		translate([ph-r,-e,6-r]) difference() {
			cube([r,pw+e*2,r]);
			translate([0,-1,0]) rotate([-90,0,0]) cylinder(r=r,h=pw+e*2+2,$fn=32);
		}
		translate([-e,0,6-r]) difference() {
			cube([ph+e*2,r,r]);
			translate([-1,r,0]) rotate([0,90,0]) cylinder(r=r,h=ph+e*2+2,$fn=32);
		}
		translate([-e,pw-r,6-r]) difference() {
			cube([ph+e*2,r,r]);
			translate([-1,0,0]) rotate([0,90,0]) cylinder(r=r,h=ph+e*2+2,$fn=32);
		}
	}
	else if (edge_profile == "crown") {
		translate([0, -e, 6]) rotate([-90,0,0]) cylinder(r=r,h=pw+e*2,$fn=32);
		translate([ph,-e, 6]) rotate([-90,0,0]) cylinder(r=r,h=pw+e*2,$fn=32);
		translate([-e, 0, 6]) rotate([0, 90,0]) cylinder(r=r,h=ph+e*2,$fn=32);
		translate([-e,pw, 6]) rotate([0, 90,0]) cylinder(r=r,h=ph+e*2,$fn=32);
		translate([ 0,  0, 6]) sphere(r=r,$fn=32);
		translate([ 0, pw, 6]) sphere(r=r,$fn=32);
		translate([ph,  0, 6]) sphere(r=r,$fn=32);
		translate([ph, pw, 6]) sphere(r=r,$fn=32);
	}
}

module plate_profile_additions() {
	ph = height_sizes[plate_size];
	pw = solid_plate_width;
	if (edge_profile == "crown") {
		bead_inset = profile_r + 2*bead_r;
		inner_y2 = pw - 2*bead_inset;
		inner_x2 = ph - 2*bead_inset;
		translate([bead_inset, bead_inset, 6]) rotate([-90,0,0]) cylinder(r=bead_r,h=inner_y2,$fn=32);
		translate([ph-bead_inset, bead_inset, 6]) rotate([-90,0,0]) cylinder(r=bead_r,h=inner_y2,$fn=32);
		translate([bead_inset, bead_inset, 6]) rotate([0, 90,0]) cylinder(r=bead_r,h=inner_x2,$fn=32);
		translate([bead_inset, pw-bead_inset, 6]) rotate([0, 90,0]) cylinder(r=bead_r,h=inner_x2,$fn=32);
		translate([bead_inset, bead_inset, 6]) sphere(r=bead_r,$fn=32);
		translate([bead_inset, pw-bead_inset, 6]) sphere(r=bead_r,$fn=32);
		translate([ph-bead_inset, bead_inset, 6]) sphere(r=bead_r,$fn=32);
		translate([ph-bead_inset, pw-bead_inset, 6]) sphere(r=bead_r,$fn=32);
	}
}

module plate_profile_fleurs() {
	ph = height_sizes[plate_size];
	pw = solid_plate_width;
	bead_inset = profile_r + 2*bead_r;
	fi = bead_inset + fleur_size/2;
	if (edge_profile == "crown") {
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
	color(color_bead)  plate_profile_additions();
	color(color_fleur) plate_profile_fleurs();

}

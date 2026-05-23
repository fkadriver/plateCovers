// WALLY - Wall Plate Customizer v1.4
// by TheNewHobbyist 2013 (http://thenewhobbyist.com)
// http://www.thingiverse.com/thing:47956
//
// Most of the connectors used with this thing are panel mount connectors from
// www.DataPro.net I can't vouch for their quality but they did have easy to
// find dimensions for their products so I used them.
//
//   Notes:
//
// * "outlet", "long_toggle", "toggle", and "rocker" use the full gang.
//   The bottom slot is ignored when one of these is selected on top.
//
// * "none" centers the other connector; "blank" leaves the slot empty
//   without re-centering the remaining connector.
//
//	Change Log:
//	v1.3  ADDED: 3 plate sizes.
//	v1.4  REFACTOR: Generic plate_gang() module; edge profile selector;
//	               unlimited gang count (up to 6 via customizer, more by
//	               editing gang_top/bottom lookup functions directly).

  //////////////////////////
 // Customizer Settings: //
//////////////////////////

// How many gangs?
plate_width = 1; // [1:8]

// Connector type for each gang
connector = "none"; // ["none":None, "blank":Blank, "toggle":Toggle Switch, "long_toggle":Long Toggle Switch, "outlet":Duplex Outlet, "rocker":Rocker, "keystone1":Keystone Jack, "vga":VGA, "hdmi":HDMI, "dvi":DVI-I, "displayport":DisplayPort, "cat5e":Cat5e/Cat6, "usb-a":USB-A, "usb-b":USB-B, "firewire":Firewire, "db09":DB-09, "ps2":PS2, "f-type":F-Type/Coax, "svideo":S-Video, "stereo":Stereo Jack]

  //////////////////////
 // Static Settings: //
//////////////////////

module GoAwayCustomizer() {
// This module is here to stop Customizer from picking up the variables below
}

plate_size   = 2;        // 0:Standard, 1:Junior-Jumbo, 2:Jumbo
edge_profile = "crown";  // Crown profile only

// Map gang index (0-based) to connector type
function top_type(n)    = connector;
function bottom_type(n) = "none";

l_offset      = [34.925, 39.6875, 44.45];
r_offset      = [34.925, 39.6875, 44.45];
switch_offset = 46.0375;
solid_plate_width = l_offset[plate_size] + switch_offset * (plate_width - 1) + r_offset[plate_size];

height_sizes  = [114.3, 123.825, 133.35];
height        = 114.3;

edgewidth     = solid_plate_width + 10;
rightbevel    = solid_plate_width - 4;

left_offset   = 34.925;
thinner_offset = [0, 0.92, 0.95, 0.96, 0.97, 0.973];

positions = [height_sizes[plate_size]/2,
             height_sizes[plate_size]/2 - 14.25,
             height_sizes[plate_size]/2 + 14.25];

profile_r = 3;   // fillet radius and crown cope radius (= plate thickness / 2)
bead_r    = 1.5; // raised bead radius for crown profile

// preview[view:north, tilt:bottom]

  /////////////////////
 // Gang Controller: //
/////////////////////

module plate_gang(n) {
	top   = top_type(n);
	bot   = bottom_type(n);
	y_off = l_offset[plate_size] + switch_offset * n;

	if (top == "toggle" || bot == "toggle") {
		translate([0,y_off,0]) toggle_screws();
		translate([0,y_off,0]) hole("toggle");
	}
	else if (top == "long_toggle" || bot == "long_toggle") {
		translate([0,y_off,0]) toggle_screws();
		translate([0,y_off,0]) hole("long_toggle");
	}
	else if (top == "rocker" || bot == "rocker") {
		translate([0,y_off,0]) rocker_screws();
		translate([0,y_off,0]) hole("rocker");
	}
	else if (top == "outlet" || bot == "outlet") {
		translate([0,y_off,0]) hole("outlet");
	}
	else if (bot == "none") {
		translate([0,y_off,0]) box_screws();
		translate([positions[0],y_off,0]) hole(top);
	}
	else if (top == "none") {
		translate([0,y_off,0]) box_screws();
		translate([positions[0],y_off,0]) hole(bot);
	}
	else {
		translate([0,y_off,0]) box_screws();
		translate([positions[1],y_off,0]) hole(top);
		translate([positions[2],y_off,0]) hole(bot);
	}
}

module plate_gang_solid(n) {
	top   = top_type(n);
	bot   = bottom_type(n);
	y_off = l_offset[plate_size] - 11.5 + switch_offset * n;

	if (top == "keystone1" && bot == "none") {
		translate([height_sizes[plate_size]/2 + 14.3, y_off, -3.9]) hole("keystone_solid");
	}
	else if (top == "keystone1" && bot != "outlet" && bot != "toggle" && bot != "rocker") {
		translate([height_sizes[plate_size]/2, y_off, -3.9]) hole("keystone_solid");
	}
	if (bot == "keystone1" && top == "none") {
		translate([height_sizes[plate_size]/2 + 14.3, y_off, -3.9]) hole("keystone_solid");
	}
	else if (bot == "keystone1" && top != "outlet" && top != "toggle" && top != "rocker") {
		translate([height_sizes[plate_size]/2 + 28.5, y_off, -3.9]) hole("keystone_solid");
	}
}

  ///////////////////
 // PlateStation: //
///////////////////

// Subtractive edge cuts — crown profile only
module plate_profile_cuts() {
	ph = height_sizes[plate_size];
	pw = solid_plate_width;
	e  = 5;
	r  = profile_r;

	// Concave cope along each front-face edge, matching CrownPlate.scad
	translate([0, -e, 6]) rotate([-90,0,0]) cylinder(r=r,h=pw+e*2,$fn=32);
	translate([ph,-e, 6]) rotate([-90,0,0]) cylinder(r=r,h=pw+e*2,$fn=32);
	translate([-e, 0, 6]) rotate([0, 90,0]) cylinder(r=r,h=ph+e*2,$fn=32);
	translate([-e,pw, 6]) rotate([0, 90,0]) cylinder(r=r,h=ph+e*2,$fn=32);
	// Corner spheres blend the two perpendicular cope cuts at each corner
	translate([ 0,  0, 6]) sphere(r=r,$fn=32);
	translate([ 0, pw, 6]) sphere(r=r,$fn=32);
	translate([ph,  0, 6]) sphere(r=r,$fn=32);
	translate([ph, pw, 6]) sphere(r=r,$fn=32);
}

// Additive elements — raised bead for crown profile
module plate_profile_additions() {
	ph = height_sizes[plate_size];
	pw = solid_plate_width;
	// Beads run between the cope zones (profile_r inset from each end)
	// so their ends terminate cleanly inside the corner cope.
	inner_y = pw - 2*profile_r;
	inner_x = ph - 2*profile_r;

	// Edge beads (limited to the straight run between corners)
	translate([profile_r,           profile_r, 6]) rotate([-90,0,0]) cylinder(r=bead_r,h=inner_y,$fn=32);
	translate([ph-profile_r,        profile_r, 6]) rotate([-90,0,0]) cylinder(r=bead_r,h=inner_y,$fn=32);
	translate([profile_r,           profile_r, 6]) rotate([0, 90,0]) cylinder(r=bead_r,h=inner_x,$fn=32);
	translate([profile_r,    pw-profile_r,     6]) rotate([0, 90,0]) cylinder(r=bead_r,h=inner_x,$fn=32);
	// Corner spheres fill the bead junction at each plate corner
	translate([profile_r,    profile_r,    6]) sphere(r=bead_r,$fn=32);
	translate([profile_r,    pw-profile_r, 6]) sphere(r=bead_r,$fn=32);
	translate([ph-profile_r, profile_r,    6]) sphere(r=bead_r,$fn=32);
	translate([ph-profile_r, pw-profile_r, 6]) sphere(r=bead_r,$fn=32);
}

module plate() {
	union() {
		difference() {
			cube([height_sizes[plate_size],solid_plate_width,6]);
			plate_profile_cuts();
		}
		plate_profile_additions();
	}
}

// Thinning Plate — bounded thinner_offset lookup for unlimited gang counts
module plate_inner() {
	ts = plate_width < len(thinner_offset)
	   ? thinner_offset[plate_width]
	   : thinner_offset[len(thinner_offset)-1];
	scale([0.95,ts,1]) {
	translate([3,3,0]) {
	difference() {
		cube([height_sizes[plate_size],solid_plate_width,6]);
		plate_profile_cuts();
			}
		}
	}
}

// Box screw holes
module box_screws(){
	 translate([height_sizes[plate_size]/2 + 41.67125,0,-1]) cylinder(r=2, h=10, $fn=12);
	 translate([height_sizes[plate_size]/2 + 41.67125,0,3.5]) cylinder(r1=2, r2=3.3, h=3);
	 translate([height_sizes[plate_size]/2 - 41.67125,0,-1]) cylinder(r=2, h=10, $fn=12);
	 translate([height_sizes[plate_size]/2 - 41.67125,0,3.5]) cylinder(r1=2, r2=3.3, h=3);
}

// Rocker/Designer screw holes
module rocker_screws(){
	 translate([height_sizes[plate_size]/2 + 48.41875,0,-1]) cylinder(r=2, h=10, $fn=12);
	 translate([height_sizes[plate_size]/2 + 48.41875,0,3.5]) cylinder(r1=2, r2=3.3, h=3);
	 translate([height_sizes[plate_size]/2 - 48.41875,0,-1]) cylinder(r=2, h=10, $fn=12);
	 translate([height_sizes[plate_size]/2 - 48.41875,0,3.5]) cylinder(r1=2, r2=3.3, h=3);
}

// Toggle screw holes
module toggle_screws(){
	 translate([height_sizes[plate_size]/2 + 30.1625,0,-1]) cylinder(r=2, h=10, $fn=12);
	 translate([height_sizes[plate_size]/2 + 30.1625,0,3.5]) cylinder(r1=2, r2=3.3, h=3);
	 translate([height_sizes[plate_size]/2 - 30.1625,0,-1]) cylinder(r=2, h=10, $fn=12);
	 translate([height_sizes[plate_size]/2 - 30.1625,0,3.5]) cylinder(r1=2, r2=3.3, h=3);
}

  ///////////////
 // Portland: //
///////////////

// Hole Cutout definitions
module hole(hole_type) {

// Toggle switch hole
	if (hole_type == "toggle") {
		translate([height_sizes[plate_size]/2,0,0]) cube([23.8125,10.3188,15], center = true);
		 						}

// Toggle switch hole and screw holes
	if (hole_type == "long_toggle") {
		translate([height_sizes[plate_size]/2,0,0]) cube([43.6563,11.9063,15], center = true);
		 						}

// Rocker switch plate
	if (hole_type == "rocker") {
		translate([height_sizes[plate_size]/2,0,0]) cube([67.1,33.3,15], center = true);

		 						}

// Duplex power outlet plate or dual side toggles
	if (hole_type == "outlet" || hole_type == "dualsidetoggle") {
		translate([height_sizes[plate_size]/2 + 19.3915,0,0]) {
			difference() {
				cylinder(r=17.4625, h=15, center = true);
				translate([-24.2875,-15,-2]) cube([10,37,15], center = false);
				translate([14.2875,-15,-2]) cube([10,37,15], center = false);
								}
							}
		translate([height_sizes[plate_size]/2 - 19.3915,0,0]){
			difference(){
				cylinder(r=17.4625, h=15, center = true);
				translate([-24.2875,-15,-2]) cube([10,37,15], center = false);
				translate([14.2875,-15,-2]) cube([10,37,15], center = false);
								}
							}
		translate([height_sizes[plate_size]/2,0,-1]) cylinder(r=2, h=10);
		translate([height_sizes[plate_size]/2,0,3.5]) cylinder(r1=2, r2=3.3, h=3);
							}

// Blank plate
	if (hole_type == "blank") { }

// VGA & DB09 plate
// VGA Fits http://www.datapro.net/products/vga-dual-panel-mount-f-f-cable.html
// DB09 Fits http://www.datapro.net/products/db9-serial-panel-mount-male-extension.html
	if (hole_type == "vga" || hole_type == "db09") {

			translate([0,-12.5,3]) cylinder(r=1.75, h=10, center = true);
			translate([0,12.5,3]) cylinder(r=1.75, h=10, center = true);
				difference(){
					cube([10,19,13], center=true);
					translate([-5,-9.2,1]) rotate([0,0,-35.6]) cube([4.4,2.4,15], center=true);
					translate([.9,-11.2,0]) rotate([0,0,9.6]) cube([10,4.8,15], center=true);
					translate([4.6,-8.5,0]) rotate([0,0,37.2]) cube([4.4,2.4,15], center=true);
					translate([-5,9.2,1]) rotate([0,0,35.6]) cube([4.4,2.4,15], center=true);
					translate([0.9,11.2,0]) rotate([0,0,-9.6]) cube([10,4.8,15], center=true);
					translate([4.6,8.5,0]) rotate([0,0,-37.2]) cube([4.4,2.4,15], center=true);
								}
						}

// HDMI plate
// Fits http://www.datapro.net/products/hdmi-panel-mount-extension-cable.html
	if (hole_type == "hdmi") {
		translate([0,-13,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,13,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,0,3]) cube([6,16,10], center=true);
							}

// DVI-I plate
// Fits http://www.datapro.net/products/dvi-i-panel-mount-extension-cable.html
	if (hole_type == "dvi") {
		translate([0,-16,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,16,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,0,3]) cube([10,26,10], center=true);
							}

// DisplayPort plate
// Fits http://www.datapro.net/products/dvi-i-panel-mount-extension-cable.html
	if (hole_type == "displayport") {
		translate([0,-13.5,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,13.5,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,0,0]){
			difference(){
				translate([0,0,3]) cube([7,19,10], center=true);
				translate([2.47,-9.37,3]) rotate([0,0,-54.6]) cube([3,5,14], center=true);
						}
								}
									}

// USB-A Plate
// Fits http://www.datapro.net/products/usb-panel-mount-type-a-cable.html
	if (hole_type == "usb-a") {
		translate([0,-15,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,15,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,0,3]) cube([8,16,10], center=true);
							}

// USB-B Plate
// Fits http://www.datapro.net/products/usb-panel-mount-type-b-cable.html
	if (hole_type == "usb-b") {
		translate([0,-13,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,13,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,0,3]) cube([11,12,10], center=true);
							}

// 1394 Firewire Plate
// Fits http://www.datapro.net/products/firewire-panel-mount-extension.html
	if (hole_type == "firewire") {
		translate([0,-13.5,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,13.5,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,0,3]) cube([7,12,10], center=true);
							}

// F-Type / Cable TV Plate
// Fits http://www.datapro.net/products/f-type-panel-mounting-coupler.html
	if (hole_type == "f-type") {
		translate([0,0,3]) cylinder(r=4.7625, h=10, center=true);
							}

// Cat5e & Cat6 plate
// Cat5e Fits http://www.datapro.net/products/cat-5e-panel-mount-ethernet.html
// Cat6 Fits http://www.datapro.net/products/cat-6-panel-mount-ethernet.html
	if (hole_type == "cat5e" || hole_type == "cat6") {
		translate([0,-12.5,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,12.5,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,0,3]) cube([15,15,10], center=true);
		}

// S-Video & PS2 plate
// S-Video Fits http://www.datapro.net/products/cat-6-panel-mount-ethernet.html
// PS2 http://www.datapro.net/products/ps2-panel-mount-extension-cable.html
	if (hole_type == "svideo" || hole_type == "ps2") {
		translate([0,-10,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,10,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,0,3]) cylinder(r=5, h=10, center=true);
		}

// Stereo / 1/4" headphone jack coupler
// Stereo coupler Fits http://www.datapro.net/products/stereo-panel-mount-coupler.html
	if (hole_type == "stereo") {
		translate([0,0,3]) cylinder(r=2.985, h=10, center=true);
		}

//Keystone1 hole
//Hole for 1 Keystone Jack
	if (hole_type == "keystone1") {
		translate([0,0,5]) cube([16.5,15,10], center = true);
	}

//Keystone Solid
	if (hole_type == "keystone_solid") {
		rotate([0,0,90]) {
			difference(){
				translate([0,0,.1]) cube([23,30.5,9.8]);
					translate([4,4,0]){
						difference(){
							cube([15,22.5,10]);
							translate([-1,-0.001,3.501]) cube([17,2,6.5]);
							translate([-1,2.5,-3.40970]) rotate([45,0,0]) cube([17,2,6.5]);
							translate([-1,18.501,6.001]) cube([17,4,4]);
							translate([-1,20.5,0]) rotate([-45,0,0]) cube([17,2,6.5]);
						}
					}
				}
			}
		}

//End of module "hole"
}

  ////////////////////////
 // Number One ENGAGE: //
////////////////////////

// Rotate so it sits correctly on plate (whoops) and make upside down
rotate([0,180,90]) {
// put plate at 0,0,0 for easier printing
translate([-height_sizes[plate_size]/2,-solid_plate_width/2,-6]) {

difference() {
	plate();
	translate([0,0,-3]) plate_inner();
	for (n = [0 : plate_width-1]) plate_gang(n);
}
union() {
	for (n = [0 : plate_width-1]) plate_gang_solid(n);
}

//End Translate
}
//End Rotate
}

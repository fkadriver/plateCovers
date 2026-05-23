include <BOSL2/std.scad>

$fn=96;

///////////////////////////////////////////////////////////
// CONFIGURATION
///////////////////////////////////////////////////////////

gangs = 2;
plate_height = 4.5 * 25.4;
plate_thickness = 6;

// Standard decorator spacing
single_gang_width = 1.85 * 25.4;
gang_spacing = 1.81 * 25.4;
margin = 12;

///////////////////////////////////////////////////////////
// DERIVED
///////////////////////////////////////////////////////////

plate_width =
    single_gang_width +
    ((gangs-1) * gang_spacing) +
    (margin*2);

///////////////////////////////////////////////////////////
// IMPORTED CROWN PARTS
///////////////////////////////////////////////////////////

module crown_plate_raw() {
    import("CrownPlate.stl", convexity=10);
}

// You will measure these once from the STL
left_slice_width = 18;
right_slice_width = 18;
center_slice_width = 20;

///////////////////////////////////////////////////////////
// STL SLICES
///////////////////////////////////////////////////////////

module left_edge() {
    intersection() {
        crown_plate_raw();

        translate([-100,-100,-100])
        cube([left_slice_width,200,200]);
    }
}

module center_section() {
    intersection() {
        crown_plate_raw();

        translate([left_slice_width,-100,-100])
        cube([center_slice_width,200,200]);
    }
}

module right_edge() {
    intersection() {
        crown_plate_raw();

        translate([
            left_slice_width + center_slice_width,
            -100,
            -100
]);
include <BOSL2/std.scad>

// Size of the hole for the dog bowl in mm
opening_d= 130; 
// Area around the dog bowl and the edge of the top in mm
padding= 20; 
// Total height of the stand in mm
h= 100;
// How much the corners and legs are rounded in mm
rounding_radius= 20; 
// Difference in size between the top and bottom of the stand in mm
flare= 15;
// Width of the leg opening at the top in mm
leg_opening_top= 80;
// Width of the leg opening at the bottom in mm
leg_opening_bottom= 100;
// Height of the leg as a decimal percent of `h` 
leg_height_percent= 0.8; // [0:0.1:1]
// Approximate thickness of the walls and top in the print.
thickness= 5;

/* [Hidden] */
epsilon= 0.01; 

leg_height = h * leg_height_percent;
double_flare= flare * 2;
double_padding= padding * 2;
outer_dims= [double_padding + opening_d, double_padding + opening_d];
bottom_dims= outer_dims + [double_flare, double_flare];
double_thickness= thickness * 2;

difference() {
    outer();
    leg_openings();
    inner();
    bowl_hole();
}
 
module bowl_hole() 
    linear_extrude(h + (epsilon*2))
        circle(d= opening_d, $fn=50);

module outer()
    hull() {
        bottom();
        translate([0, 0, h]) 
            top();
    }

module inner()
    translate([0, 0, -epsilon])
        hull() {
            bottom([-double_thickness, -double_thickness]);
            translate([0, 0, h - thickness]) 
                top([-double_thickness, -double_thickness]);
        }

module top(additional= [0, 0])
    linear_extrude(epsilon)
        rect(outer_dims + additional, rounding= rounding_radius);

module bottom(additional= [0, 0])
    linear_extrude(epsilon)
        rect(bottom_dims + additional, rounding= rounding_radius);

module leg_openings() {
    leg_opening();
    rotate([0, 0, 90])
        leg_opening();
}

module leg_opening()
    translate([0, -bottom_dims.x/2, (leg_height/2) - epsilon])
        rotate([-90, 0, 0])
            linear_extrude(bottom_dims.x)
                trapezoid(
                    h= leg_height, 
                    w1= leg_opening_top, 
                    w2= leg_opening_bottom, 
                    rounding= [0, 0, rounding_radius,rounding_radius]
                );
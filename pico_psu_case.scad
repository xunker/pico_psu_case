/*

  Case for picoPCU-160-xt, but will probably work on picoPSU-120 and picoPSU-80,
  too.

  v1.1

  https://github.com/xunker/pico_psu_case
  http://www.thingiverse.com/thing:1621822

  Copyright 2016 Matthew Nielsen (xunker@pyxidis.org)

  License: "Creative Commons - Attribution - Non-Commercial - Share Alike"

*/

// VARIABLES

/*
  Which case parts do you want to render?
  If you choose "true" for both, they will rotated for printing. Otherwise,
  each part will be "upside down" and need to be rotated before printing. */
render_side_a = true;
render_side_b = true;

screw_hole_diameter = 2.5;

// CHANGE VARIABLES BELOW ONLY TO FIX THE FIT. CHANGING THESE MAY ALSO REQUIRE
// CHANGING OTHER OFFSETS AND SIZES ELSEWHERE IN THE CODE.

housing_length = 25.5;
housing_width = 56;

side_a_housing_height = 6;
side_b_housing_height = 10;

board_length = 21.5;
board_width = 54;

// END VARIABLES

module hdd_connector() {
  cube([14,6,10]);
}

module cooling_grille(len, number) {
  for (a =[0:number-1]) {
    translate([a*3,0,0]) cube([2,len,2]);
  }
}

module top_edge_cutouts(housing_height) {
  // ugly math below is to automatically generate the correct number of
  // cutouts and center then between the screw supports
  cutout_diameter = housing_height/2;
  usable_width = (housing_width-((screw_hole_diameter*3)*2));
  spacing = 1.5;
  cutouts = floor(usable_width/(cutout_diameter*spacing));

  width_of_cutouts_section = ((cutout_diameter+spacing)*cutouts)-spacing;

  translate([((housing_width-width_of_cutouts_section)/2)+1,housing_length+2,housing_height/2]) {
    for (a =[0:cutouts-1]) {
      translate([(a*cutout_diameter)+(spacing*a),0,0]) rotate([90,0,0]) cylinder(d=cutout_diameter, h=3, $fn=16);
    }
  }
}

module screw_holes(housing_height) {
  outer_d = screw_hole_diameter*3;

  module screw_hole(h) {
    difference() {
      cylinder(d=outer_d, h=h, $fn=8);
      translate([0,-screw_hole_diameter*1.5,0]) cube([outer_d,outer_d,h]);
      translate([-screw_hole_diameter/1.5,0,0]) cylinder(d=screw_hole_diameter, h=h, $fn=16);
    }
  }

  x_offset = -1;
  y_offset = 1;

  translate([x_offset,(outer_d/2)+y_offset,0]) screw_hole(h=housing_height);
  translate([housing_width+x_offset,(outer_d/2)+y_offset,0]) rotate([0,0,180]) screw_hole(h=housing_height);
  translate([(housing_width+x_offset)-(outer_d/2),housing_length+y_offset,0]) rotate([0,0,270]) screw_hole(h=housing_height);
  translate([(outer_d/2)+x_offset,housing_length+y_offset,0]) rotate([0,0,270]) screw_hole(h=housing_height);
}

module side_a() {


  module pw_in_atx() {
    // larger than expected so you can put the power connector through.
    cube([18,12.5,10]);
  }

  module clip() {
    cube([8,8,10]);
  }

  difference() {
    translate([-1,1,0])
      cube([housing_width, housing_length, side_a_housing_height]);
    union() {
      translate([0,4,0]) cube([board_width, board_length, side_a_housing_height-1]);
      translate([0,0,0]) cube([board_width, 5, 2.5]); // clear solder connections

      translate([0,13,0]) pw_in_atx();
      translate([40,19.5,0]) hdd_connector();
      translate([(housing_width/2)-4.5,1,0]) clip();

      translate([0.5,4.5,side_a_housing_height-1]) cooling_grille(7,6);
      translate([19,4.5,side_a_housing_height-1]) cooling_grille(20.5,1);
      translate([22,12,side_a_housing_height-1]) cooling_grille(13,4);
      translate([34,4.5,side_a_housing_height-1]) cooling_grille(20.5,2);
      translate([40,4.5,side_a_housing_height-1]) cooling_grille(13.5,5);

      top_edge_cutouts(side_a_housing_height);
    }
  }

  screw_holes(side_a_housing_height);
}

module side_b() {
  difference() {
    translate([-1,1,0]) cube([housing_width, housing_length, side_b_housing_height]);
    union() {
      translate([0,4,0]) cube([board_width, board_length, side_b_housing_height-1]);
      translate([0,0,0]) cube([board_width, 5, 2.5]); // clear solder connections

      translate([0,17,0]) hdd_connector();
      translate([0.5,4.5,side_b_housing_height-1]) cooling_grille(11,5);
      translate([15.5,4.5,side_b_housing_height-1]) cooling_grille(20,13);

      top_edge_cutouts(side_b_housing_height);
    }
  }

  screw_holes(side_b_housing_height);
}

if (render_side_a && render_side_b) {
  translate([0,0,side_a_housing_height])
    rotate([180,0,0])
      side_a();

  translate([0,-(housing_length+screw_hole_diameter)*1.2,side_b_housing_height])
    rotate([180,0,0])
      side_b();
} else {
  if (render_side_a) {
    side_a();
  }
  if (render_side_b) {
    side_b();
  }
}

/* 
  To change screw hole size, modify the diameter and positions
  in the `screw_holes` module.
*/

housing_length = 25.5;
housing_width = 56;

module hdd_connector() {
  cube([14,6,10]);
}

module cooling_grille(len, number) {
  for (a =[0:number-1]) {
    translate([a*3,0,0]) cube([2,len,2]);
  }
}

module screw_hole(h, hole_d) {
  difference() {
    cylinder(d=hole_d*3, h=h, $fn=8);
    translate([0,-hole_d*1.5,0]) cube([hole_d*3,hole_d*3,h]);
    translate([-hole_d/1.5,0,0]) cylinder(d=hole_d, h=h, $fn=16);
  }
}

module top_edge_cutouts(dia, number) {
  for (a =[0:number]) {
    spacing = 2;
    translate([(a*dia)+(spacing*a),0,0]) rotate([90,0,0]) cylinder(d=dia, h=3, $fn=16);
  }
}

module screw_holes(housing_height) {
  // For 2.5mm holes
  screw_hole_diameter = 2.5;
  translate([-1.0,4.75,0]) screw_hole(h=housing_height, hole_d=screw_hole_diameter);
  translate([55.0,4.75,0]) rotate([0,0,180]) screw_hole(h=housing_height, hole_d=screw_hole_diameter);
  translate([51.3,26.5,0]) rotate([0,0,270]) screw_hole(h=housing_height, hole_d=screw_hole_diameter);
  translate([2.7,26.5,0]) rotate([0,0,270]) screw_hole(h=housing_height, hole_d=screw_hole_diameter);

  // // for 3.5mm hiles
  // screw_hole_diameter = 3.5;
  // translate([-1.0,6.25,0]) screw_hole(h=housing_height, hole_d=screw_hole_diameter);
  // translate([55.0,6.25,0]) rotate([0,0,180]) screw_hole(h=housing_height, hole_d=screw_hole_diameter);
  // translate([49.75,26.5,0]) rotate([0,0,270]) screw_hole(h=housing_height, hole_d=screw_hole_diameter);
  // translate([4.25,26.5,0]) rotate([0,0,270]) screw_hole(h=housing_height, hole_d=screw_hole_diameter);
}

module side_a() {
  housing_height = 6;

  module pw_in_atx() {
    // larger than expected so you can put the power connector through.
    cube([18,12.5,10]);
  }

  module clip() {
    cube([8,8,10]);
  }

  difference() {
    translate([-1,1,0]) cube([housing_width, housing_length, housing_height]);
    union() {
      translate([0,4,0]) cube([54, 21.5, housing_height-1]);
      translate([0,0,0]) cube([54, 5, 2.5]); // clear solder connections
      translate([0,13,0]) pw_in_atx();
      translate([40,19.5,0]) hdd_connector();
      translate([(housing_width/2)-4.5,1,0]) clip();

      translate([0.5,4.5,housing_height-1]) cooling_grille(7,6);
      translate([19,4.5,housing_height-1]) cooling_grille(20.5,1);
      translate([22,12,housing_height-1]) cooling_grille(13,4);
      translate([34,4.5,housing_height-1]) cooling_grille(20.5,2);
      translate([40,4.5,housing_height-1]) cooling_grille(13.5,5);

      translate([8,housing_length+2,housing_height/2]) {
        top_edge_cutouts(housing_height/2, 8);
      }
    }
  }

  screw_holes(housing_height);
}

module side_b() {
  housing_height = 10;

  difference() {
    translate([-1,1,0]) cube([housing_width, housing_length, housing_height]);
    union() {
      translate([0,4,0]) cube([54, 21.5, housing_height-1]);
      translate([0,0,0]) cube([54, 5, 2.5]); // clear solder connections
      translate([0,17,0]) hdd_connector();
      translate([0.5,4.5,housing_height-1]) cooling_grille(11,5);
      translate([15.5,4.5,housing_height-1]) cooling_grille(20,13);

      translate([9.5,housing_length+2,housing_height/2]) {
        top_edge_cutouts(housing_height/2, 5);
      }

    }
  }

  screw_holes(housing_height);
}

translate([0,housing_length/10,0])
  side_a();

translate([0,-housing_length*1.4,0])
 side_b();
include <config.scad>;
use <x-ends.scad>;

for(side=[left,right]) {
  translate([bearing_outer_diam*.75*side,0,0]) {
    rotate([0,0,90*side]) {
      mirror([1-side,0,0]) {
        rotate([0,90,0]) {
          x_end_idler();
        }
      }
    }
  }
}

translate([0,(x_rod_spacing/2+bearing_outer_diam*1.5)*front,0]) {
  rotate([0,90,0]) {
    x_motor_mount();
  }
}

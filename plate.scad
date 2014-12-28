include <config.scad>;
use <x-ends.scad>;

translate([0,(x_rod_spacing/2+bearing_outer_diam*1.5)*front,motor_side/2]) {
  rotate([0,90,0]) {
    x_motor_mount();
  }
}

translate([x_rod_spacing*.75*left,0,x_end_base_width/2]) {
  mirror([1,0,0]) {
    rotate([0,-90,0]) {
      x_end_base();
    }
  }
}

translate([x_rod_spacing*.75*right,0,x_end_base_width/2]) {
  mirror([0,0,0]) {
    rotate([0,-90,0]) {
      x_end_idler();
    }
  }
}

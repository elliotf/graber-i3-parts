include <config.scad>;
use <x-ends.scad>;

translate([x_rod_spacing*.7*left,0,0]) {
  rotate([0,90,0]) {
    x_end_idler();
  }
}

translate([x_rod_spacing*.7*right,0,0]) {
  rotate([0,-90,0]) {
    mirror([1,0,0]) {
      x_end_base();
    }
  }
}

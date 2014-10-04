left = -1;
right = 1;
top = -1;
bottom = 1;

build_x = 180;
build_y = 180;
build_z = 180;

extrusion_height = 0.3;
extrusion_width = 0.5;
res = 24;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
}

wall_thickness   = 2;
nut_diam         = 5.65; // 5.5 + clearance
nut_height       = 2;

material_thickness = 6;

bearing_inner_diam = 3.2;
bearing_outer_diam = 10;
bearing_height     = 4;
idler_outer_diam   = 12;
idler_width        = 8;
belt_thickness     = 2;

bearing_dist_from_end      = material_thickness + idler_outer_diam/2 + belt_thickness + 2;

arm_spacing = idler_width;
arm_width   = 8;
arm_height  = 18;
arm_length  = bearing_dist_from_end + bearing_outer_diam/2 + wall_thickness;

module y_idler() {
  module body() {
    for(side=[0,1]) {
      mirror([side,0,0]) {
        translate([arm_spacing/2+arm_width/2,0,0]) {
          idler_arm();
        }
      }
    }

    translate([0,-arm_width/2,0]) {
      cube([arm_spacing + arm_width*2 + wall_thickness*4,arm_width,arm_height],center=true);
    }
  }

  module holes() {
    /*
    rotate([90,0,0]) {
      rotate([0,0,22.5]) {
        hole(bearing_inner_diam,arm_length,8);
      }

      rotate([0,0,0]) {
        hole(nut_diam,nut_height*3,6);
      }
    }
    */

    translate([0,material_thickness,0]) {
      rotate([-15,0,0]) {
        translate([0,0,arm_height]) {
          cube([arm_width*5,arm_length*3,arm_height],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }

  % translate([0,bearing_dist_from_end,0]) {
    rotate([0,90,0]) {
      cylinder(r=idler_outer_diam/2,h=idler_width,center=true);
    }
  }

  % translate([0,material_thickness/2,0]) {
    cube([arm_width*7,material_thickness,arm_height*1.5],center=true);
  }
}

module idler_arm() {
  bevel_height = 2;
  solid_arm_width = arm_width-bevel_height;

  module body() {
    translate([bevel_height/2,arm_length/2,0]) {
      cube([solid_arm_width,arm_length,arm_height],center=true);
    }

    translate([0,bearing_dist_from_end,0]) {
      hull() {
        rotate([0,90,0]) {
          rotate([0,0,22.5/4]) {
            hole(bearing_inner_diam+wall_thickness/2,arm_width-0.05,16*2);
            hole(bearing_inner_diam+wall_thickness+bevel_height*2,arm_width-bevel_height*2,16*2);
          }
        }
      }
    }
  }

  module holes() {
    translate([arm_width/2,bearing_dist_from_end,0]) {
      rotate([0,90,0]) {
        rotate([0,0,22.5]) {
          hole(bearing_inner_diam,arm_width*2,8);
        }
        rotate([0,0,90]) {
          hole(nut_diam,nut_height*2,6);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

//idler_arm();

y_idler();

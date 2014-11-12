include <config.scad>;
use <util.scad>;

x_rod_spacing           = 45;
smooth_threaded_spacing = 17;

base_depth  = bearing_inner_diam + min_material_thickness*2;
base_width  = motor_side/2 + smooth_threaded_spacing + bearing_outer_diam/2;
base_height = x_rod_spacing + base_depth;

belt_opening_depth  = idler_thickness*2 + 2;
belt_opening_height = x_rod_spacing - bearing_inner_diam - min_material_thickness*2;

leadscrew_diam          = 5;
leadscrew_nut_diam      = 8.2;
leadscrew_nut_thickness = 3;

bearing_retainer_diam   = bearing_outer_diam + min_material_thickness*4;
bearing_dist_from_x_rod = bearing_inner_diam/2+min_material_thickness+bearing_outer_diam/2;
bearing_pos_x           = base_width/2-bearing_retainer_diam/2;
bearing_pos_y           = bearing_dist_from_x_rod*front;

smooth_rod_hole_diam    = bearing_inner_diam + 1;

leadscrew_retainer_diam   = leadscrew_nut_diam+min_material_thickness*2;
leadscrew_retainer_height = leadscrew_nut_thickness*2;
leadscrew_retainer_pos_x  = bearing_pos_x+(left*smooth_threaded_spacing);
leadscrew_retainer_pos_y  = bearing_pos_y;
leadscrew_retainer_pos_z  = base_height/2-leadscrew_retainer_height/2;

zip_tie_hole_width     = 4;
zip_tie_hole_thickness = 3;

echo("BASE_HEIGHT - LEADSCREW_RETAINER_HEIGHT: ", base_height - leadscrew_retainer_height);

module zip_tie_hole(fit_around_diam) {
  rotate([0,0,rotation]) {
    difference() {
      hole(fit_around_diam+zip_tie_hole_thickness,zip_tie_hole_width,resolution);
      hole(fit_around_diam,zip_tie_hole_width+1,resolution);
    }
  }
}

module x_end_base() {
  module body() {
    // z rod material, main body
    hull() {
      for (side=[top,bottom]) {
        translate([0,0,x_rod_spacing/2*side]) {
          rotate([0,90,0]) {
            rotate([0,0,rotation]) {
              hole(base_depth,base_width,resolution);
            }
          }
        }
      }
    }

    // z bearing retainer
    hull() {
      for (side=[top,bottom]) {
        translate([leadscrew_retainer_pos_x+leadscrew_nut_diam/2,0,x_rod_spacing/2*side]) {
          rotate([0,90,0]) {
            rotate([0,0,rotation]) {
              hole(base_depth,leadscrew_nut_diam,resolution);
            }
          }
        }
      }
      translate([bearing_pos_x+bearing_retainer_diam/4,0,0]) {
        translate([0,front*bearing_dist_from_x_rod/2,0]) {
          cube([bearing_retainer_diam/2,bearing_dist_from_x_rod,base_height],center=true);
        }
      }
    }
    hull() {
      translate([bearing_pos_x+bearing_retainer_diam/4,0,0]) {
        translate([0,front*bearing_dist_from_x_rod/2,0]) {
          cube([bearing_retainer_diam/2,bearing_dist_from_x_rod,base_height],center=true);
        }
      }
      translate([bearing_pos_x+bearing_retainer_diam/4,front*(bearing_dist_from_x_rod+bearing_retainer_diam/2-base_depth/2),0]) {
        for(side=[top,bottom]) {
          translate([0,0,x_rod_spacing/2*side]) {
            rotate([0,90,0]) {
              rotate([0,0,rotation]) {
                hole(base_depth,bearing_retainer_diam/2,resolution);
              }
            }
          }
        }
      }
    }

    leadscrew_retainer_edge_to_edge = leadscrew_retainer_diam*1.125;
    // z leadscrew nut retainer
    hull() {
      translate([0,0,leadscrew_retainer_pos_z]) {
        translate([leadscrew_retainer_pos_x,0,0]) {
          translate([0,leadscrew_retainer_pos_y,0]) {
            rotate([0,0,90]) {
              hole(leadscrew_retainer_diam,leadscrew_retainer_height,6);
            }
          }
          cube([leadscrew_retainer_diam,0.5,leadscrew_retainer_height],center=true);
        }

        translate([base_width/2-2,front*(bearing_dist_from_x_rod+bearing_retainer_diam/2-base_depth),0]) {
          cube([1,base_depth,leadscrew_retainer_height],center=true);
        }
      }
    }
  }

  module holes() {
    // x smooth_rods
    for(side=[top,bottom]) {
      translate([0,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          hole(bearing_inner_diam,100,resolution);
        }
      }
    }
    // flange to avoid delamination in case of first layer squashedness
    for(side=[top,bottom]) {
      translate([base_width/2+1,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          hull() {
            hole(bearing_inner_diam,2+extrusion_height*4,resolution);
            hole(bearing_inner_diam+1,2,resolution);
          }
        }
      }
    }

    // bearing zip ties
    for (side=[top,bottom]) {
      translate([bearing_pos_x,bearing_pos_y,side*(belt_opening_height/2-belt_opening_depth/2)]) {
        zip_tie_hole(bearing_retainer_diam-zip_tie_hole_thickness*.8);
      }
    }

    // bearing retainer
    translate([bearing_pos_x,bearing_pos_y,0]) {
      // cavity for bearing
      translate([0,0,leadscrew_retainer_pos_z-leadscrew_retainer_height/2-base_height/2]) {
        rotate([0,0,-45]) {
          translate([bearing_outer_diam/4*left,bearing_retainer_diam/2*front,0]) {
            cube([bearing_outer_diam/2,bearing_retainer_diam,base_height],center=true);
          }
        }
        rotate([0,0,rotation]) {
          hole(bearing_outer_diam,base_height,resolution);
        }
      }

      // clearance for smooth rod allowing for support of leadscrew nut
      hull() {
        translate([smooth_rod_hole_diam/4*left,bearing_retainer_diam/2*front,0]) {
          cube([smooth_rod_hole_diam/2,bearing_retainer_diam,base_height*2],center=true);
        }
        rotate([0,0,-45]) {
          translate([smooth_rod_hole_diam/4*left,bearing_retainer_diam/2*front,0]) {
            cube([smooth_rod_hole_diam/2,bearing_retainer_diam,base_height*2],center=true);
          }
        }
      }
      rotate([0,0,rotation]) {
        hole(smooth_rod_hole_diam,base_height*2,resolution);
      }
    }

    // leadscrew shaft and captive nut
    translate([leadscrew_retainer_pos_x,leadscrew_retainer_pos_y,0]) {
      //rotate([0,0,90]) {
      rotate([0,0,22.5]) {
        hole(leadscrew_diam+1,base_height*2,8);
      }
      translate([0,0,leadscrew_retainer_pos_z-leadscrew_retainer_height/2]) {
        rotate([0,0,90]) {
          hole(leadscrew_nut_diam,leadscrew_nut_thickness*2,6);
        }
      }
    }

    // idler/belt opening
    hull() {
      for(side=[top,bottom]) {
        translate([0,0,(belt_opening_height/2-belt_opening_depth/2)*side]) {
          rotate([0,90,0]) {
            hole(belt_opening_depth,100,resolution);
          }
        }
      }
    }

    // idler screw shaft
    translate([(base_width/2-idler_outer_diam)*left,0,belt_pulley_diam/2-idler_outer_diam/2]) {
      rotate([90,0,0]) {
        rotate([0,0,22.5]) {
          hole(idler_inner_diam,base_depth+1,8);
        }
      }
    }

    // clamp area
    for (side=[top,bottom]) {
      translate([0,0,x_rod_spacing/2*side]) {
        translate([extrusion_height*2*left,bearing_inner_diam,0]) {
          cube([base_width,bearing_inner_diam*2,2],center=true);
        }

        for (x=[-base_width/2+bearing_inner_diam*.75,bearing_pos_x-bearing_outer_diam/2]) {
          translate([x,0,0]) {
            rotate([0,90,0]) {
              zip_tie_hole(base_depth);
            }
          }
        }
      }
    }
  }

  /*
  % translate([0,bearing_pos_y,0]) {
    translate([bearing_pos_x,0,0]) {
      cylinder(r=bearing_inner_diam/2,h=100,center=true,$fn=24);
    }
    translate([leadscrew_retainer_pos_x,0,0]) {
      cylinder(r=leadscrew_diam/2,h=100,center=true,$fn=24);

      translate([0,0,-base_height/2-10-motor_side/2]) {
        cube([motor_side,motor_side,motor_side],center=true);
      }

      translate([0,motor_side/2+7+3,0]) {
        cube([60,6,60],center=true);
      }
    }
  }
  */

  difference() {
    body();
    holes();
  }
}

module plate() {
  for(side=[right]) {
    translate([base_height*.6*side,0,base_width/2]) {
      rotate([0,side*90,0]) {
        mirror([1-side,0,0]) {
          x_end_base();
        }
      }
    }
  }
}

//plate();
x_end_base();

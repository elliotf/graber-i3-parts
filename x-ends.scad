include <config.scad>;
use <util.scad>;

smooth_threaded_spacing = 17;

base_depth  = bearing_inner_diam + min_material_thickness*2;
base_width  = motor_side/2 + smooth_threaded_spacing + bearing_outer_diam/2;
base_height = x_rod_spacing + base_depth;

leadscrew_diam          = 5;
leadscrew_nut_diam      = 8.2;
leadscrew_nut_thickness = 3;

bearing_retainer_diam   = bearing_outer_diam + min_material_thickness*3;
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

idler_shaft_x = (base_width/2-idler_outer_diam)*left;
idler_shaft_z = belt_pulley_diam/2-idler_outer_diam/2;
idler_shoulder = 1;

belt_opening_depth  = idler_thickness*2 + idler_shoulder*2;
belt_opening_height = x_rod_spacing - bearing_inner_diam - min_material_thickness*2;

motor_mount_width = motor_side;

z_rod_to_endstop_dist = 16;
endstop_from_motor_side_dist = z_rod_to_endstop_dist - bearing_retainer_diam/2 - 0.5;

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
            rotate([0,0,rotation]) {
              hole(belt_opening_depth,100,resolution);
            }
          }
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

module x_end_idler() {
  module body() {
    x_end_base();

    for(side=[front,rear]) {
      hull() {
        translate([idler_shaft_x,(idler_thickness+idler_shoulder/2)*side,idler_shaft_z]) {
          rotate([90,0,0]) {
            rotate([0,0,22.5]) {
              hole(idler_inner_diam+1.5,idler_shoulder,8);
            }
          }

          translate([0,(idler_shoulder/2+0.1)*side,0]) {
            rotate([90,0,0]) {
              rotate([0,0,22.5]) {
                hole(idler_inner_diam+4,0.2,8);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    // idler screw shaft
    translate([idler_shaft_x,0,idler_shaft_z]) {
      rotate([90,0,0]) {
        rotate([0,0,22.5]) {
          hole(idler_inner_diam,base_depth+1,8);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module x_motor_mount() {
  z_adjustment_block_width  = endstop_from_motor_side_dist*2;
  z_adjustment_block_height = base_depth-m3_nut_diam/2;

  module body() {
    for(side=[top,bottom]) {
      hull() {
        translate([0,0,x_rod_spacing/2*side]) {
          rotate([0,90,0]) {
            rotate([0,0,rotation]) {
              hole(base_depth,motor_mount_width,resolution);
              % cylinder(r=bearing_inner_diam/2,h=200,center=true,$fn=32);
            }
          }
        }

        translate([0,0,(motor_shoulder_diam/2+1)*side]) {
          cube([motor_mount_width,base_depth,5],center=true);
        }
      }
    }

    hull() {
      translate([motor_side/2-z_adjustment_block_width/2,0,(x_rod_spacing/2+base_depth/2-z_adjustment_block_height/2)*bottom]) {
        translate([0,bearing_dist_from_x_rod*front,0]) {
          cube([z_adjustment_block_width,base_depth,z_adjustment_block_height],center=true);
        }

        cube([z_adjustment_block_width,.1,z_adjustment_block_height],center=true);
      }
    }
  }

  module holes() {
    for(side=[top,bottom]) {
      // x rod holes
      translate([0,0,x_rod_spacing/2*side]) {
        rotate([0,90,0]) {
          rotate([0,0,rotation]) {
            hole(bearing_inner_diam,motor_mount_width*2,resolution);
          }
        }

        // expansion joint
        translate([extrusion_height*2*left,0,0]) {
          rotate([45*side,0,0]) {
            translate([0,bearing_outer_diam/2,0]) {
              cube([motor_mount_width,bearing_outer_diam,2],center=true);
            }
          }
        }

        // flange to avoid delamination in case of first layer squashedness
        translate([motor_mount_width/2+1,0,0]) {
          rotate([0,90,0]) {
            hull() {
              hole(bearing_inner_diam,2+extrusion_height*4,resolution);
              hole(bearing_inner_diam+1,2,resolution);
            }
          }
        }
      }


      // motor mount holes
      for(end=[left,right]) {
        translate([motor_hole_spacing/2*side,0,motor_hole_spacing/2*end]) {
          rotate([90,0,0]) {
            rotate([0,0,22.5]) {
              hole(motor_hole_diam,motor_mount_width+1,8);
            }
          }
        }
      }
    }

    // motor shoulder
    rotate([90,0,0]) {
      rotate([0,0,rotation]) {
        hole(motor_shoulder_diam,base_depth+1,resolution);
      }
    }

    // z adjustment screw, captive nut
    translate([motor_side/2-endstop_from_motor_side_dist,bearing_dist_from_x_rod*front,0]) {
      rotate([0,0,90]) {
        hole(m3_diam,200,6);
      }
      translate([0,0,(x_rod_spacing/2+base_depth/2)*bottom]) {
        rotate([0,0,90]) {
          hole(m3_nut_diam,6,6);
        }
      }
    }
  }

  % translate([0,base_depth/2+motor_length/2,0]) {
    cube([motor_side,motor_length,motor_side],center=true);
  }

  % translate([0,0,0]) {
    rotate([90,0,0]) {
      hole(belt_pulley_diam+2,belt_opening_depth,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

x_motor_mount();

translate([(motor_mount_width/2+base_width/2+0.5)*right,0,0]) {
  mirror([1,0,0]) {
    x_end_idler();
  }
}

translate([base_width*2.4*right,0,0]) {
  x_end_idler();
}

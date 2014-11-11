include <config.scad>;
use <util.scad>;

x_rod_spacing           = 45;
smooth_threaded_spacing = 17;

base_depth  = bearing_inner_diam + min_material_thickness*4;
base_width  = motor_side/2 + smooth_threaded_spacing + bearing_outer_diam/2;
base_height = x_rod_spacing + bearing_inner_diam + min_material_thickness*4;

belt_opening_depth  = idler_thickness*2 + 2;
belt_opening_height = x_rod_spacing - bearing_inner_diam - min_material_thickness*2;

leadscrew_diam          = 5;
leadscrew_nut_diam      = 8.2;
leadscrew_nut_thickness = 4;

bearing_retainer_diam   = bearing_outer_diam + min_material_thickness*4;
bearing_dist_from_x_rod = bearing_inner_diam/2+min_material_thickness+bearing_outer_diam/2;
bearing_pos_x           = base_width/2-bearing_retainer_diam/2;
bearing_pos_y           = bearing_dist_from_x_rod*front;

smooth_rod_hole_diam    = bearing_inner_diam + 1;

leadscrew_pos_x           = bearing_pos_x+(left*smooth_threaded_spacing);
leadscrew_pos_y           = bearing_pos_y;
leadscrew_retainer_diam   = leadscrew_nut_diam+min_material_thickness*2;
leadscrew_retainer_height = leadscrew_nut_thickness*2;

zip_tie_hole_width     = 4;
zip_tie_hole_thickness = 4;

echo("BASE_HEIGHT - LEADSCREW_RETAINER_HEIGHT: ", base_height - leadscrew_retainer_height);

module zip_tie_hole(fit_around_diam) {
  difference() {
    hole(fit_around_diam+zip_tie_hole_thickness,zip_tie_hole_width,36);
    hole(fit_around_diam,zip_tie_hole_width+1,36);
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
      translate([bearing_pos_x,0,0]) {
        translate([0,front*bearing_dist_from_x_rod/2,0]) {
          cube([bearing_retainer_diam,bearing_dist_from_x_rod,base_height],center=true);
        }
        translate([0,front*(bearing_dist_from_x_rod+bearing_retainer_diam/2-base_depth/2),0]) {
          //cube([bearing_retainer_diam,bearing_retainer_diam,base_height],center=true);
          for(side=[top,bottom]) {
            translate([0,0,x_rod_spacing/2*side]) {
              rotate([0,90,0]) {
                rotate([0,0,rotation]) {
                  hole(base_depth,bearing_retainer_diam,resolution);
                }
              }
            }
          }
        }
      }
    }

    leadscrew_retainer_edge_to_edge = leadscrew_retainer_diam*1.125;
    // z leadscrew nut retainer
    hull() {
      translate([0,0,base_height/2-leadscrew_retainer_height/2]) {
        translate([leadscrew_pos_x,0,0]) {
          translate([0,leadscrew_pos_y,0]) {
            rotate([0,0,90]) {
              hole(leadscrew_retainer_diam,leadscrew_retainer_height,6);
            }
          }
          cube([leadscrew_retainer_diam,0.5,leadscrew_retainer_height],center=true);
          translate([smooth_threaded_spacing/2,bearing_pos_y,0]) {
            rotate([0,0,90]) {
              hole(leadscrew_retainer_diam,leadscrew_retainer_height,6);
            }
          }
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

    // bearing zip ties
    for (side=[top,bottom]) {
      translate([bearing_pos_x,bearing_pos_y,side*(belt_opening_height/2-belt_opening_depth/2)]) {
        zip_tie_hole(bearing_retainer_diam-zip_tie_hole_thickness*.8);
      }
    }

    // bearing retainer
    translate([bearing_pos_x,bearing_pos_y,0]) {
      // cavity for bearing
      translate([0,0,leadscrew_retainer_height*bottom]) {
        hull() {
          translate([bearing_outer_diam/4*left,bearing_retainer_diam/2*front,0]) {
            cube([bearing_outer_diam/2,bearing_retainer_diam,base_height],center=true);
          }
          rotate([0,0,-45]) {
            translate([bearing_outer_diam/4*left,bearing_retainer_diam/2*front,0]) {
              cube([bearing_outer_diam/2,bearing_retainer_diam,base_height],center=true);
            }
          }
        }
        rotate([0,0,rotation]) {
          hole(bearing_outer_diam,base_height,resolution);
        }
      }

      // clearance for smooth rod allowing for support of leadscrew nut
      hull() {
        translate([smooth_rod_hole_diam/4*left,bearing_retainer_diam/2*front,0]) {
          cube([smooth_rod_hole_diam/2,bearing_retainer_diam,base_height+1],center=true);
        }
        rotate([0,0,-45]) {
          translate([smooth_rod_hole_diam/4*left,bearing_retainer_diam/2*front,0]) {
            cube([smooth_rod_hole_diam/2,bearing_retainer_diam,base_height+1],center=true);
          }
        }
      }
      rotate([0,0,rotation]) {
        hole(smooth_rod_hole_diam,base_height+1,resolution);
      }
    }

    // leadscrew shaft and captive nut
    translate([leadscrew_pos_x,leadscrew_pos_y,0]) {
      rotate([0,0,90]) {
        hole(leadscrew_diam+1,base_height+1,6);
      }
      translate([0,0,base_height/2-leadscrew_retainer_height]) {
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
  }

  % translate([0,bearing_pos_y,0]) {
    translate([bearing_pos_x,0,0]) {
      cylinder(r=bearing_inner_diam/2,h=100,center=true,$fn=24);
    }
    translate([leadscrew_pos_x,0,0]) {
      cylinder(r=leadscrew_diam/2,h=100,center=true,$fn=24);
    }
  }

  difference() {
    body();
    holes();
  }
}

x_end_base();

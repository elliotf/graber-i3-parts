include <util.scad>;

left  = -1;
right = 1;
front = -1;
rear  = 1;

x = 0;
y = 1;
z = 2;

extrusion_width     = 0.6;
extrusion_thickness = 0.3;
wall_thickness  = extrusion_width * 2;

screw_diam = 3.6;
nut_diam   = 5.65;

post_diam     = nut_diam + wall_thickness*4;
mount_height  = 8;
spacer_diam   = screw_diam + wall_thickness*4;
spacer_height = 8;

nut_height = mount_height-2;

x5_spacing_x = 89.00; // v1.1
x5_spacing_y = 43.00; // v1.1

sang_spacing_x = 94;
sang_spacing_y = 43.25;
x5_angle       = 20;

module x5_perpendicular_adapter() {
  offset_y = 10;
  offset_x = -x5_spacing_x/2+sang_spacing_y/2+4;

  /*
  points = [
    [x5_spacing_x/2*left,x5_spacing_y/2*front],
    [x5_spacing_x/2*left,x5_spacing_y/2*rear],
    [sang_spacing_y/2*left+offset_x,sang_spacing_x/2*rear+offset_y],
    [sang_spacing_y/2*right+offset_x,sang_spacing_x/2*rear+offset_y],
    [x5_spacing_x/2*right,x5_spacing_y/2*rear],
    [x5_spacing_x/2*right,x5_spacing_y/2*front],
    [sang_spacing_y/2*right+offset_x,sang_spacing_x/2*front+offset_y],
    [sang_spacing_y/2*left+offset_x,sang_spacing_x/2*front+offset_y]
  ];

  num_points = 8;
  */

  module body() {
    /*
    for(i=[0:num_points-1]) {
      hull() {
        translate([points[i][x],points[i][y],mount_height/2]) {
          hole(wall_thickness*4,mount_height,180);
        }
        translate([points[(i+1) % num_points][x],points[(i+1)% num_points][y],mount_height/2]) {
          hole(wall_thickness*4,mount_height,180);
        }
      }
    }
    */
    for(side=[left,right]) {
      translate([sang_spacing_y/2*side+offset_x,offset_y,mount_height/2]) {
        cube([wall_thickness*4,sang_spacing_x,mount_height],center=true);
      }
      translate([0,x5_spacing_y/2*side,mount_height/2]) {
        cube([x5_spacing_x,wall_thickness*4,mount_height],center=true);
      }
      for(end=[front,rear]) {
        hull() {
          translate([x5_spacing_x/2*side,x5_spacing_y/2*end,mount_height/2]) {
            hole(post_diam,mount_height,6);

            translate([0,0,mount_height/2+spacer_height/2]) {
              hole(spacer_diam,spacer_height,6);
            }
          }
        }
        // sanguinololu rotated 90deg
        translate([sang_spacing_y/2*side+offset_x,sang_spacing_x/2*end+offset_y,mount_height/2]) {
          rotate([0,0,90]) {
            hole(post_diam,mount_height,6);
          }
        }
      }
    }
  }

  module holes() {
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([x5_spacing_x/2*side,x5_spacing_y/2*end,0]) {
          hole(screw_diam,(mount_height+spacer_height)*2+1,6);
          hole(nut_diam,nut_height*2,6);
        }
        // sanguinololu rotated 90deg
        translate([sang_spacing_y/2*side+offset_x,sang_spacing_x/2*end+offset_y,mount_height/2]) {
          rotate([0,0,90]) {
            hole(screw_diam,mount_height+1,6);

            translate([0,0,mount_height]) {
              hole(nut_diam,nut_height*3,6);
            }
          }
        }
      }
    }
  }

  module bridges() {
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([x5_spacing_x/2*side,x5_spacing_y/2*end,nut_height]) {
          hole(nut_diam,extrusion_thickness,6);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

module x5_parallel_adapter() {
  x5_angle = 15;
  offset_x = 10;
  offset_y = sang_spacing_y*.75;

  min_x = left*min(x5_spacing_x/2,sang_spacing_x/2-offset_x);
  max_x = min(x5_spacing_x/2,sang_spacing_x/2+offset_x);
  y_brace_length = sang_spacing_y + offset_y;

  module body() {
    for(side=[left,right]) {
      rotate([0,0,x5_angle]) {
        translate([0,x5_spacing_y/2*side,mount_height/2]) {
          cube([x5_spacing_x,wall_thickness*4,mount_height],center=true);
        }
        translate([x5_spacing_x/2*side,0,mount_height/2]) {
          cube([wall_thickness*4,x5_spacing_y,mount_height],center=true);
        }
        for(end=[front,rear]) {
          hull() {
            translate([x5_spacing_x/2*side,x5_spacing_y/2*end,mount_height/2]) {
              hole(post_diam,mount_height,6);

              translate([0,0,mount_height/2+spacer_height/2]) {
                hole(spacer_diam,spacer_height,6);
              }
            }
          }
        }
      }

      translate([offset_x,offset_y,0]) {
        translate([0,sang_spacing_y/2*side,mount_height/2]) {
          cube([sang_spacing_x,wall_thickness*4,mount_height],center=true);
        }
        translate([sang_spacing_x/2*side,0,mount_height/2]) {
          cube([wall_thickness*4,sang_spacing_y,mount_height],center=true);
        }
      }
      for(end=[front,rear]) {
        translate([sang_spacing_x/2*side+offset_x,sang_spacing_y/2*end+offset_y,mount_height/2]) {
          hole(post_diam,mount_height,6);
        }
      }
    }

    /*
    translate([min_x,offset_y/2,mount_height/2]) {
      cube([wall_thickness*4,y_brace_length,mount_height],center=true);
    }
    translate([max_x,offset_y/2,mount_height/2]) {
      cube([wall_thickness*4,y_brace_length,mount_height],center=true);
    }
    */
  }

  module holes() {
    rotate([0,0,x5_angle]) {
      for(side=[left,right]) {
        for(end=[front,rear]) {
          translate([x5_spacing_x/2*side,x5_spacing_y/2*end,0]) {
            hole(screw_diam,(mount_height+spacer_height)*2+1,6);
            hole(nut_diam,nut_height*2,6);
          }
        }
      }
    }
    for(side=[left,right]) {
      for(end=[front,rear]) {
        translate([sang_spacing_x/2*side+offset_x,sang_spacing_y/2*end+offset_y,mount_height/2]) {
          hole(screw_diam,mount_height+1,6);

          translate([0,0,mount_height]) {
            hole(nut_diam,nut_height*3,6);
          }
        }
      }
    }
  }

  module bridges() {
    rotate([0,0,x5_angle]) {
      for(side=[left,right]) {
        for(end=[front,rear]) {
          translate([x5_spacing_x/2*side,x5_spacing_y/2*end,nut_height]) {
            hole(nut_diam,0.3,6);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

translate([0,0,0]) {
  //x5_perpendicular_adapter();
}

translate([0,0,0]) {
  x5_parallel_adapter();
}

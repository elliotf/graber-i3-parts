left   = -1;
right  = 1;
top    = 1;
bottom = -1;
front  = -1;
rear   = 1;

approximate_pi   = 3.14159265359;

extrusion_height = 0.3;
extrusion_width  = 0.5;
resolution       = 36;
rotation         = 180/resolution; // if possible, have faces line up with cubes

min_material_thickness = extrusion_width*4;

wall_thickness   = 2;
nut_diam         = 5.65; // 5.5 + clearance
nut_thickness    = 2;

motor_side         = 43; // nema17
motor_hole_spacing = 31;
motor_screw_diam   = 3;

// LM6UU
bearing_inner_diam = 6;
bearing_outer_diam = 12;
bearing_length     = 19;

// LM8UU
bearing_inner_diam = 8;
bearing_outer_diam = 15;
bearing_length     = 24;

// MR105
idler_outer_diam   = 10;
idler_inner_diam   = 5;
idler_thickness    = 4;

// 623
idler_outer_diam   = 10;
idler_inner_diam   = 3;
idler_thickness    = 4;

belt_width         = 2;
belt_thickness     = 6;
belt_pitch         = 2;
belt_pulley_circ   = belt_pitch*16;
belt_pulley_diam   = belt_pulley_circ / approximate_pi;

x_rod_spacing      = 45;
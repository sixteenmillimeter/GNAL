include <../libraries/threads.scad>;
//https://www.thingiverse.com/thing:186660
include <../libraries/path_extrude.scad>;

SPOKE_COUNT = 24;

OD = 10;
PITCH = 1.5;
THREAD = 1.6;
LEN = 21;

module gnal_spiral_bottom_core (thread = false) {
    $fn = 360;
    
    core_center_h = 3;
    
    core_bottom_outer_d = 53;
    core_bottom_outer_void_d = 44;
    core_bottom_outer_h = 4.2;
    
    core_d = 29.5;
    core_h = 8.5;
    
    core_bottom_d = 26;
    core_bottom_h = 5;
    
    top_z_offset = (core_h / 2) - (core_center_h / 2);
    
    arms_outer_d = 48;
    arms_inner_d = 48 - 7;
    
    core_void_outer_d = 20.5;
    core_void_inner_d = 14.5;
    core_void_h = 11.5;
    
    film_void = 0.8;
    
    translate([0, 0, -(core_bottom_outer_h / 2) - (core_center_h / 2) ]) difference () {
        cylinder(r = core_bottom_outer_d / 2, h = core_bottom_outer_h + core_center_h, center = true);
        cylinder(r = core_bottom_outer_void_d / 2, h = core_bottom_outer_h + core_center_h + 1, center = true);
    }
    difference () {
        union() {
            //center
            translate([0, 0, -core_center_h / 2]) {
                difference () {
                  cylinder(r = (core_bottom_outer_d - 1) / 2, h = core_center_h, center = true);
                  rotate([0, 0, -120]) translate([20, 0, 0]) rotate([0, 0, 45]) cube([20, 20, 20], center = true);
                }
                translate([0, 0, -1]) cylinder(r = core_d / 2, h = core_center_h, center = true);
            }
            //top
            translate([0, 0, top_z_offset]) {
                cylinder(r = core_d / 2, h = core_h + core_center_h, center = true); 
            }
            //bottom
            translate([0, 0, -(core_bottom_h / 2) - (core_center_h / 2)]) {
                cylinder(r = core_bottom_d / 2, h = core_bottom_h + core_center_h, center = true); 
            }
        }
        //thread
        if (thread) {
            translate([0, 0, -LEN / 2]) metric_thread (diameter=OD + .2, pitch=PITCH, thread_size = THREAD, length=LEN);
        } else {
            cylinder(r = (OD + 0.2) / 2, h = LEN, center = true);
        }
        translate([0, 0, -2.3]) difference () {
            cylinder(r = core_void_outer_d / 2, h = core_void_h, center = true);
            cylinder(r = core_void_inner_d / 2, h = core_void_h + 1, center = true);
        }
    }

    //arms
    difference () {
        union () {
            translate([0, 0, top_z_offset]) difference() {
                //adjust one arm inward
                intersection () {
                    cylinder(r = arms_outer_d / 2, h = core_h + core_center_h, center = true);
                    translate([1, 0, 0]) cylinder(r = arms_outer_d / 2, h = core_h + core_center_h, center = true);
                }
                intersection () {
                    cylinder(r = arms_inner_d / 2, h = core_h + core_center_h + 1, center = true);
                    translate([1, 0, 0]) cylinder(r = arms_inner_d / 2, h = core_h + core_center_h + 1, center = true);
                }
                translate([0, arms_outer_d / 2, 0]) cube([arms_outer_d, arms_outer_d, arms_outer_d], center = true);
            }
            
            translate([(arms_outer_d + arms_inner_d) / 4, 0, top_z_offset]) cylinder(r = 3.5 / 2, h = core_h + core_center_h, center = true, $fn = 40);
            //adjusted arm
            translate([-((arms_outer_d + arms_inner_d) / 4)  + 1, 0, top_z_offset]) cylinder(r = 3.5 / 2, h = core_h + core_center_h, center = true, $fn = 40);
            
            difference () {
                rotate([0, 0, -120]) translate([13.75, 0, top_z_offset]) cube([16, 20, core_h + core_center_h], center = true);
                //remove piece from adjusting arm
                translate([-19, -14, 0]) rotate([0, 0, 10]) cube([4, 4, 30], center = true);
                rotate([0, 0, -120 - 37]) translate([18, 0, top_z_offset]) {
                    cylinder(r = 6.8 / 2, h = 30, center = true);
                    translate([-4, -2, 0]) cube([4, 4, 30], center = true);
                }
                rotate([0, 0, -120 + 37]) translate([18, 0, top_z_offset]) {
                    cylinder(r = 6.8 / 2, h = 30, center = true);
                    translate([-4, 2, 0])  cube([4, 4, 30], center = true);
                }
            }
        }
        rotate([0, 0, -120]) translate([20, -5, 0]) rotate([0, 0, 45]) cube([20, film_void, 30], center = true);
        rotate([0, 0, -120]) translate([20, 5, 0]) rotate([0, 0, -45]) cube([20, film_void, 30], center = true);
        rotate([0, 0, -120]) translate([25, 0, 0]) difference () {
            cylinder(r = 8 / 2, h = 30, center = true);
            translate([-6.9, 0, 0]) cube([8, 8, 30], center = true);
        }
        cylinder(r = core_void_outer_d / 2, h = core_void_h, center = true);
        rotate([0, 0, -120]) translate([20, 0, -1.5]) rotate([0, 0, 45]) cube([20, 20, 3.01], center = true);
    }
}

module gnal_spiral_100ft_bottom (threads = false, spiral_count = 60) {
    outer_d = 299;
    outer_d_inside = outer_d - 6;
    outer_h = 7.5;
    
    spoke_len = 123;
    spoke_w = 3;
    spoke_h = 4.2 + 3;
    
    spoke_2_len = 83;
    spoke_2_h = 6;
    
    spoke_cross_1_d = 63;
    spoke_cross_1_w = 18;
    
    spoke_cross_2_d = 108;
    spoke_cross_2_w = 15;
    
    spoke_3_len = 39;
    spoke_3_w = 2;
    
    translate([0, 0, -3.75]) difference () {
        cylinder(r = outer_d / 2, h = outer_h, center = true, $fn = 500);
        cylinder(r = outer_d_inside / 2, h = outer_h + 1, center = true, $fn = 500);
    }
    
    //rounding voids
    difference () {
        gnal_spiral_bottom_core(threads);
        for (i = [0 : SPOKE_COUNT]) {
            rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) translate([0, 26.75, 0]) cylinder(r = 2, h = 20, center = true, $fn = 40);
        }
    }
    //main spokes
    for (i = [0 : SPOKE_COUNT]) {
        rotate([0, 0, i * (360 / SPOKE_COUNT)]) translate([(spoke_len / 2) + (48 / 2), 0, -3.6]) cube([spoke_len, spoke_w, spoke_h], center = true);
    }
    //second spokes
    for (i = [0 : SPOKE_COUNT]) {
        rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) translate([(outer_d / 2) - (spoke_2_len / 2) - 2, 0, -3]) cube([spoke_2_len, spoke_w, spoke_2_h], center = true);
    }
    //main spoke cross pieces
    for (i = [0 : SPOKE_COUNT]) {
        rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) translate([spoke_cross_1_d, 0, -3]) rotate([0, 0, 20]) cube([ spoke_w, spoke_cross_1_w, spoke_2_h], center = true);
    }
    //second spoke cross pieces
    for (i = [0 : SPOKE_COUNT * 2]) {
        rotate([0, 0, (i + 0.5) * (360 / (SPOKE_COUNT * 2))]) translate([spoke_cross_2_d, 0, -3]) rotate([0, 0, -20]) cube([ spoke_w, spoke_cross_2_w, spoke_2_h], center = true);
    }
    
    //third spokes
    for (i = [0 : SPOKE_COUNT * 2]) {
        rotate([0, 0, (i + 0.5) * (360 / (SPOKE_COUNT * 2))]) translate([(outer_d / 2) - (spoke_3_len / 2) - 2, 0, -3]) cube([spoke_3_len, spoke_3_w, spoke_2_h], center = true);
    }

    //translate([0, 0, 1]) rotate([0, 0, 0]) spiral_2 (START_D = 46.95, SPIRALS = spirals); //12 //40
    translate([0, 0, -.1]) spirals(spiral_count, 46.95 - 1.2, 2.075);
}

module gnal_spiral_middle_core () {
    $fn = 360;
    
    core_center_h = 3;
    
    core_bottom_outer_d = 53;
    core_bottom_outer_void_d = 44;
    core_bottom_outer_h = 4.2;
    
    core_d = 29.5;
    core_h = 8.5;
    
    core_bottom_d = 26;
    core_bottom_h = 4.2;
    
    top_z_offset = (core_h / 2) - (core_center_h / 2);
    
    core_void_outer_d = 20.5;
    core_void_inner_d = 14.5;
    core_void_h = 11.5;
    
    arms_outer_d = 48;
    arms_inner_d = 48 - 7;
    
    void_d = 18;
    
    film_void = 0.8;
    
    translate([0, 0, -(core_bottom_outer_h / 2) - (core_center_h / 2) ]) difference () {
        cylinder(r = core_bottom_outer_d / 2, h = core_bottom_outer_h + core_center_h, center = true);
        cylinder(r = core_bottom_outer_void_d / 2, h = core_bottom_outer_h + core_center_h + 1, center = true);
    }
    difference () {
        union() {
            //center
            translate([0, 0, -core_center_h / 2]) {
                difference () {
                  cylinder(r = (core_bottom_outer_d - 1) / 2, h = core_center_h, center = true);
                  rotate([0, 0, -120]) translate([20, 0, 0]) rotate([0, 0, 45]) cube([20, 20, 20], center = true);
                }
                translate([0, 0, -1]) cylinder(r = core_d / 2, h = core_center_h, center = true);
            }
            //top
            translate([0, 0, top_z_offset]) {
                cylinder(r = core_d / 2, h = core_h + core_center_h, center = true); 
            }
            //bottom
            translate([0, 0, -(core_bottom_h / 2) - (core_center_h / 2)]) {
                cylinder(r = core_bottom_d / 2, h = core_bottom_h + core_center_h, center = true); 
            }
        }
        cylinder(r = void_d / 2, h = 30, center = true);
        translate([0, 0, -12]) spacer_ridges();
    }

    //arms
    difference () {
        union () {
            translate([0, 0, top_z_offset]) difference() {
                //adjust the shorter arm
                intersection () {
                    cylinder(r = arms_outer_d / 2, h = core_h + core_center_h, center = true);
                    translate([1, 0, 0]) cylinder(r = arms_outer_d / 2, h = core_h + core_center_h, center = true);
                }
                intersection () {
                    cylinder(r = arms_inner_d / 2, h = core_h + core_center_h + 1, center = true);
                    translate([1, 0, 0]) cylinder(r = arms_inner_d / 2, h = core_h + core_center_h + 1, center = true);
                }
                translate([0, arms_outer_d / 2, 0]) cube([arms_outer_d, arms_outer_d, arms_outer_d], center = true);
            }
            
            translate([(arms_outer_d + arms_inner_d) / 4, 0, top_z_offset]) cylinder(r = 3.5 / 2, h = core_h + core_center_h, center = true, $fn = 40);
            //adjusted arm
            translate([-((arms_outer_d + arms_inner_d) / 4)  + 1, 0, top_z_offset]) cylinder(r = 3.5 / 2, h = core_h + core_center_h, center = true, $fn = 40);
            
            difference () {
                rotate([0, 0, -120]) translate([13.75, 0, top_z_offset]) cube([16, 20, core_h + core_center_h], center = true);
                //remove piece from adjusting arm
                translate([-19, -14, 0]) rotate([0, 0, 10]) cube([4, 4, 30], center = true);
                rotate([0, 0, -120 - 37]) translate([18, 0, top_z_offset]) {
                    cylinder(r = 6.8 / 2, h = 30, center = true);
                    translate([-4, -2, 0]) cube([4, 4, 30], center = true);
                }
                rotate([0, 0, -120 + 37]) translate([18, 0, top_z_offset]) {
                    cylinder(r = 6.8 / 2, h = 30, center = true);
                    translate([-4, 2, 0]) cube([4, 4, 30], center = true);
                }
            }
        }
        rotate([0, 0, -120]) translate([20, -5, 0]) rotate([0, 0, 45]) cube([20, film_void, 30], center = true);
        rotate([0, 0, -120]) translate([20, 5, 0]) rotate([0, 0, -45]) cube([20, film_void, 30], center = true);
        rotate([0, 0, -120]) translate([25, 0, 0]) difference () {
            cylinder(r = 8 / 2, h = 30, center = true);
            translate([-6.9, 0, 0]) cube([8, 8, 30], center = true);
        }
        cylinder(r = core_void_outer_d / 2, h = core_void_h, center = true);
        rotate([0, 0, -120]) translate([20, 0, -1.5]) rotate([0, 0, 45]) cube([20, 20, 3.01], center = true);
        cylinder(r = void_d / 2, h = 30, center = true);
    }
}

module gnal_spiral_100ft_middle (spiral_count = 60) {
    outer_d = 299;
    outer_d_inside = outer_d - 6;
    outer_h = 7.5;
    
    spoke_len = 123;
    spoke_w = 3;
    spoke_h = 4.2 + 3;
    
    spoke_2_len = 83;
    spoke_2_h = 6;
    
    spoke_cross_1_d = 63;
    spoke_cross_1_w = 18;
    
    spoke_cross_2_d = 108;
    spoke_cross_2_w = 15;
    
    spoke_3_len = 39;
    spoke_3_w = 2;
    
    translate([0, 0, -3.75]) difference () {
        cylinder(r = outer_d / 2, h = outer_h, center = true, $fn = 500);
        cylinder(r = outer_d_inside / 2, h = outer_h + 1, center = true, $fn = 500);
    }
    
    //rounding voids
    difference () {
        gnal_spiral_middle_core();
        for (i = [0 : SPOKE_COUNT]) {
            rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) translate([0, 26.75, 0]) cylinder(r = 2, h = 20, center = true, $fn = 40);
        }
    }
    
    //main spokes
    for (i = [0 : SPOKE_COUNT]) {
        rotate([0, 0, i * (360 / SPOKE_COUNT)]) translate([(spoke_len / 2) + (48 / 2), 0, -3.6]) cube([spoke_len, spoke_w, spoke_h], center = true);
    }
    //second spokes
    for (i = [0 : SPOKE_COUNT]) {
        rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) translate([(outer_d / 2) - (spoke_2_len / 2) - 2, 0, -3]) cube([spoke_2_len, spoke_w, spoke_2_h], center = true);
    }
    //main spoke cross pieces
    for (i = [0 : SPOKE_COUNT]) {
        rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) translate([spoke_cross_1_d, 0, -3]) rotate([0, 0, 20]) cube([ spoke_w, spoke_cross_1_w, spoke_2_h], center = true);
    }
    //second spoke cross pieces
    for (i = [0 : SPOKE_COUNT * 2]) {
        rotate([0, 0, (i + 0.5) * (360 / (SPOKE_COUNT * 2))]) translate([spoke_cross_2_d, 0, -3]) rotate([0, 0, -20]) cube([ spoke_w, spoke_cross_2_w, spoke_2_h], center = true);
    }
    
    //third spokes
    for (i = [0 : SPOKE_COUNT * 2]) {
        rotate([0, 0, (i + 0.5) * (360 / (SPOKE_COUNT * 2))]) translate([(outer_d / 2) - (spoke_3_len / 2) - 2, 0, -3]) cube([spoke_3_len, spoke_3_w, spoke_2_h], center = true);
    }
    
    //translate([0, 0, 1]) rotate([0, 0, 0]) spiral_2 (START_D = 46.95, SPIRALS = spiral_count);//12 //40
    translate([0, 0, -.1]) spirals(spiral_count, 46.95 - 1.2, 2.075);
}

module spacer_ridges () {
    ridges = 16;
    for (i = [0 : ridges]) {
        rotate([0, 0, i * (360 / ridges)]) translate([13.5, 0, 0]) cylinder(r = 1.25, h = 8, $fn = 60);
    }
}

module spacer_ridges_loose () {
    ridges = 16;
    intersection () {
        union () {
            for (i = [0 : ridges]) {
                rotate([0, 0, i * (360 / ridges)]) translate([13.7, 0, 0]) cylinder(r = 1.25, h = 8, $fn = 60);
            }
        }
        cylinder(r = 13.7, h = 12, center = true);
    }
}
module spacer_outer_ridges () {
    ridges = 24;
    H = 6.5;
    difference () {
        union () {
            for (i = [0 : ridges]) {
                rotate([0, 0, i * (360 / ridges)]) translate([14.6, 0, -4.75]) cylinder(r = 1.25, h = 8, $fn = 30);
            }
        }
        translate([0, 0, -4.1]) difference () {
            cylinder(r = 33 / 2, h = 4, center = true, $fn = 100);
            cylinder(r2 = 33 / 2, r1 = 27.75 / 2, h = 4.1, center = true, $fn = 100);
        }
    }
}
module gnal_spiral_100ft_spacer () {
    add = 3.25;
    core_d = 29.5;
    core_bottom_d = 26.2 + .2;
    void_d = 22.5;
    h = 8 + add;
    translate([0, 0, (add / 2) - 1]) difference () {
        union () {
            difference () {
                cylinder(r = core_d / 2, h = h, center = true, $fn = 200);
                translate([0, 0, 8]) cylinder(r = core_bottom_d / 2, h = h, center = true, $fn = 200);
                cylinder(r = void_d / 2, h = h + 1, center = true, $fn = 200);
            }
            translate([0, 0, 0]) spacer_ridges_loose();
            spacer_outer_ridges();
        }
        //trim top
        translate([0, 0, h - 0.1]) cylinder(r = (core_d + 1) / 2, h = h, center = true, $fn = 200);
        //trim bottom
        translate([0, 0, -h + 0.9]) cylinder(r = (core_d + 1) / 2, h = h, center = true, $fn = 200);
        //finger grips
        //translate([0, 24, 0]) rotate([-6, 0, 0]) cylinder(r = 10, h = 6, center = true, $fn = 100);
        //translate([0, -24, 0]) rotate([6, 0, 0]) cylinder(r = 10, h = 6, center = true, $fn = 100);
    }
}

module gnal_spiral_100ft_top () {
    H = 5;
    center_d = 53;
    spoke_w = 4.5;
    spokes = 12;
    outer_d = 299;
    inner_d = 150;
    inner_d_2 = 215;
    void_d = 22.5;
    hole_d = 3.5;
    hole_spacing = 37;
    core_d = 29.5;
    core_bottom_d = 26.2;
    
    difference () {
        union () {
            cylinder(r = center_d / 2, h = H, center = true, $fn = 100);
            for (i = [0 : spokes]) {
                rotate([0, 0, i * (360 / spokes)]) translate([0, outer_d / 4, 0]) cube([spoke_w, (outer_d / 2) - 1, H], center = true);
            }
            //outer spokes
            for (i = [0 : spokes * 2]) {
                rotate([0, 0, i * (360 / (spokes * 2))]) translate([0, (outer_d / 2) - 25, 0]) cube([spoke_w, (outer_d / 2) - (inner_d_2 / 2) , H], center = true);
            }
        }
        //void
        cylinder(r = void_d / 2, h = H + 1, center = true, $fn = 100);
        //speed holes
        for (i = [0 : 3]) {
            rotate([0, 0, (i * 90) + 45]) translate([0, hole_spacing / 2, 0]) cylinder(r = hole_d / 2, h = H + 1, center = true);
        }
        //rounding of center cylinder
        for (i = [0 : spokes]) {
            rotate([0, 0, (i + 0.5) * (360 / spokes)]) translate([-2.75, 26.5, 0]) cylinder(r = 2, h = H+1, center = true, $fn = 40);
            rotate([0, 0, (i + 0.5) * (360 / spokes)]) translate([2.75, 26.5, 0]) cylinder(r = 2, h = H+1, center = true, $fn = 40);
             rotate([0, 0, (i + 0.5) * (360 / spokes)]) translate([0, 26.5, 0]) cube([5, 4, H + 1], center = true);
        }
    }
    difference () {
        cylinder(r = (center_d / 2) - 1.8, h = H, center = true, $fn = 200);
        cylinder(r = (hole_spacing / 2) + 2, h = H + 1, center = true, $fn = 200);
    }
    //outer ring
    difference () {
        cylinder(r = outer_d / 2, h = H, center = true, $fn = 200);
        cylinder(r = (outer_d / 2) - 5, h = H + 1, center = true, $fn = 200);
    }
    //inner ring
    difference () {
        cylinder(r = inner_d / 2, h = H, center = true, $fn = 200);
        cylinder(r = (inner_d / 2) - 5, h = H + 1, center = true, $fn = 200);
    }
    //second inner ring
    difference () {
        cylinder(r = inner_d_2 / 2, h = H, center = true, $fn = 200);
        cylinder(r = (inner_d_2 / 2) - 5, h = H + 1, center = true, $fn = 200);
    }
    
    //rounded cross connectors
    for (i = [0 : spokes]) {
                rotate([0, 0, i * (360 / spokes)]) translate([0, (inner_d / 2) - (spoke_w / 2), 0]) difference() {
                    cylinder(r = 6.5, h = H, center = true);
                    translate([6.25, 6, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
                    translate([-6.25, 6, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
                    translate([-6.1, -7, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
                    translate([6.1, -7, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
                }
            }
            difference () {
                union () {
                    translate([0, 0, 3.75 + 1]) cylinder(r = core_d / 2, h = H, center = true, $fn = 60);
                    translate([0, 0, 3.75 + 1 + 3.2]) cylinder(r = core_bottom_d / 2, h = H, center = true, $fn = 60);
                }
                cylinder(r = void_d / 2, h = H * 5 , center = true, $fn = 100);
                translate([0, 0, 4 + 1 + 2.25]) spacer_ridges();
            }
    //rounded second ring connectors
    for (i = [0 : spokes]) {
            rotate([0, 0, i * (360 / spokes)]) translate([0, 205 / 2, 0]) difference () {
                translate([0, 2, 0]) cube([13, 12, H], center = true);
                translate([6.2, -4.2, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
                translate([-6.2, -4.2, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
                translate([6.2, 8.75, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
                translate([-6.2, 8.75, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
            }
        }
    //second ring connectors
    for (i = [0 : spokes * 2]) {
        rotate([0, 0, i * (360 / (spokes * 2))]) translate([0, 205 / 2, 0]) difference () {
                translate([0, 4, 0]) cube([13, 8, H], center = true);
                translate([6.2, 8.75, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
                translate([-6.2, 8.75, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
        }
    }     
    
    for (i = [0 : spokes * 2]) {
        rotate([0, 0, i * (360 / (spokes * 2))]) translate([0, 289 / 2, 0]) difference () {
                translate([0, 0, 0]) cube([13, 9, H], center = true);
                translate([6.2, -4.2, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
                translate([-6.2, -4.2, 0]) cylinder(r = 4, h = H + 1, center = true, $fn = 60);
        }
    }    
}

module spirals (count = 40, start_d = 48, spacing = 2) {
    facet_size = 30;
    bottom = 1.2;
    top = .3;
    top_offset = (bottom - top);
    h = 2.2;
    
    od = start_d + (spacing * 2 * count);
    echo("SPIRAL LENGTH", PI * count * (od + start_d + 1) / 2);
    echo("OUTER D", od);
    
    facetProfile = [[0, 0], [top_offset, -h], [bottom, -h], [bottom, 0]];
    union () {
        for (s = [0 : count - 1]) {
            d = start_d + (s * spacing * 2);
            c = PI * pow(d / 2, 2);
            $fn = ceil( c / facet_size );
            angle_i = 360 / $fn;
            increment = spacing / $fn;
            spiralPath = [ for(t = [0 : $fn + 1]) [((d / 2) + (t * increment)) * cos(t * angle_i), ((d / 2) + (t * increment)) * sin(t * angle_i), 0] ];
            path_extrude(exShape=facetProfile, exPath=spiralPath);
        }
    }
}

//translate([0, 0, -16]) gnal_spiral_100ft_bottom(false);
//gnal_spiral_100ft_middle();
//translate([0, 0, 16]) rotate([0, 0, 0]) gnal_spiral_100ft_top();
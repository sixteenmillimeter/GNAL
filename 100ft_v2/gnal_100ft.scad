//V2

include <../libraries/gnal.scad>;

SPOKE_COUNT = 24;
PART="";

module gnal_100ft_spiral (spiral_count = 60, od = 298.75) {
    outer_d = 299;
    outer_d_inside = outer_d - 6;
    outer_h = 7.5;
    
    spoke_len = 123;
    spoke_w = 3;
    spoke_h = 4.2 + 3;
    
    spoke_2_len = 85;
    
    spoke_cross_1_d = 63;
    spoke_cross_1_w = 18;
    
    spoke_cross_2_d = 108;
    spoke_cross_2_w = 15;
    
    spoke_3_len = 39;
    spoke_3_w = 2;
    
    translate([0, 0, -3.6]) difference () {
        cylinder(r = outer_d / 2, h = spoke_h, center = true, $fn = 500);
        cylinder(r = outer_d_inside / 2, h = outer_h + 1, center = true, $fn = 500);
    }
    
    difference () {
        gnal_spiral_core();
        //rounded spoke voids
        for (i = [0 : SPOKE_COUNT]) {
            rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) {
                translate([0, 26.75, 0]) {
                    cylinder(r = 2, h = 20, center = true, $fn = 40);
                }
            }
        }
    }
    
    //main spokes
    for (i = [0 : SPOKE_COUNT]) {
        rotate([0, 0, i * (360 / SPOKE_COUNT)]) {
            translate([(spoke_len / 2) + (48 / 2), 0, -3.6]) {
                cube([spoke_len, spoke_w, spoke_h], center = true);
            }
        }
    }
    //secondary spokes
    for (i = [0 : SPOKE_COUNT]) {
        rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) {
            translate([(outer_d / 2) - (spoke_2_len / 2) - 2, 0, -3.6]) {
                cube([spoke_2_len, spoke_w, spoke_h], center = true);
            }
        }
    }
    //spoke cross bars
    for (i = [0 : SPOKE_COUNT]) {
        rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) {
            translate([63, 0, -3.6]) {
                rotate([0, 0, 20]) {
                    cube([ spoke_w, 18, spoke_h], center = true);
                }
            }
        }
    }
    
    //second spokes
    for (i = [0 : SPOKE_COUNT]) {
        rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) {
            translate([(outer_d / 2) - (spoke_2_len / 2) - 2, 0, -3.6]) {
                cube([spoke_2_len, spoke_w, spoke_h], center = true);
            }
        }
    }

    //second spoke cross pieces
    for (i = [0 : SPOKE_COUNT * 2]) {
        rotate([0, 0, (i + 0.5) * (360 / (SPOKE_COUNT * 2))]) {
            translate([spoke_cross_2_d, 0, -3.6]) {
                rotate([0, 0, -20]) {
                    cube([ spoke_w, spoke_cross_2_w, spoke_h], center = true);
                }
            }
        }
    }
    
    //third spokes
    for (i = [0 : SPOKE_COUNT * 2]) {
        rotate([0, 0, (i + 0.5) * (360 / (SPOKE_COUNT * 2))]) {
            translate([(outer_d / 2) - (spoke_3_len / 2) - 2, 0, -3.6]) {
                cube([spoke_3_len, spoke_3_w, spoke_h], center = true);
            }
        }
    }

    //translate([0, 0, 1]) rotate([0, 0, 0]) spiral_2 (START_D = 46.95, SPIRALS = spirals); //12 //40
    //translate([0, 0, -.1]) rotate([0, 0, -90]) film_guide(spiral_count, 298.75);
    //translate([0, 0, -.1]) spirals_old(spiral_count, 46.95 - 1.2, 2.075);
    
    translate([0, 0, -.1]) {
        rotate([0, 0, -90]) {
            difference () {
                film_guide(spiral_count, od);
                for (i = [0 : SPOKE_COUNT]) {
                    rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT) ]) {
                        translate([(83 / 4) + (48 / 2), 0, -3.6]) triangle_void(); 
                    }
                }
                for (i = [0 : SPOKE_COUNT * 2]) {
                    rotate([0, 0, (i + 0.5) * (360 / (SPOKE_COUNT * 2)) ]) {
                       translate([(258 / 2) - (spoke_2_len / 2) + 1 , 0, -3.6]) triangle_void_2(); 
                    }
                }
                for (i = [0 : SPOKE_COUNT * 4]) {
                    rotate([0, 0, (i + 0.5) * (360 / (SPOKE_COUNT * 4)) ]) {
                        if (i % 2 == 0) {
                       translate([(outer_d / 2) - (spoke_3_len / 2) + 1 , 0.3, -3.6]) triangle_void_3(); 
                        } else {
                            translate([(outer_d / 2) - (spoke_3_len / 2) + 1, -0.3, -3.6]) triangle_void_3();
                        }
                    }
                }
            }
        }
    }
}

module gnal_100ft_top () {
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



module film_guide (rotations = 40, od = 215.75) {
    SPIRALROTATION=rotations * 360;
    SPIRALSTEPS=180;
    INITIALRADIUS= od / 2; //300 / 2;
    PITCH=2.07675;
    XMAXSHAPE=2;
    
    InwardSpiral (
        SPIRALROTATION/SPIRALSTEPS,
        SPIRALSTEPS,
        INITIALRADIUS,
        PITCH,
        XMAXSHAPE);
}

if (PART == "spiral") {
    gnal_100ft_spiral();
} else if (PART == "top") {
    gnal_100ft_top();
} else if (PART == "spacer") {
    gnal_spacer();
} else if (PART == "insert_s8") {
    gnal_spiral_bottom_insert_s8();
} else if (PART == "insert_16") {
    gnal_spiral_bottom_insert_16();
} else if (PART == "spacer_16") {
    gnal_spacer_16();
}

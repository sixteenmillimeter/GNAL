//V3

include <../libraries/gnal_v3.scad>;

SPOKE_COUNT = 24;

module gnal_100ft_spiral (spiral_count = 60, od = 298.75, quarter = false) {
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
        for (i = [0 : SPOKE_COUNT - 1]) {
            rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) {
                translate([0, 26.75, 0]) {
                    cylinder(r = 2, h = 20, center = true, $fn = 40);
                }
            }
        }
    }
    
    //main spokes
    for (i = [0 : SPOKE_COUNT - 1]) {
        rotate([0, 0, i * (360 / SPOKE_COUNT)]) {
            translate([(spoke_len / 2) + (48 / 2), 0, -3.6]) {
                if (quarter && i % 3 == 0 && i % 6 != 0) { //phew!
                    cube([spoke_len, spoke_w * 2, spoke_h], center = true);
                } else {
                    cube([spoke_len, spoke_w, spoke_h], center = true);
                }
            }
        }
    }
    //secondary spokes
    for (i = [0 : SPOKE_COUNT - 1]) {
        rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) {
            translate([(outer_d / 2) - (spoke_2_len / 2) - 2, 0, -3.6]) {
                cube([spoke_2_len, spoke_w, spoke_h], center = true);
            }
        }
    }
    //spoke cross bars
    for (i = [0 : SPOKE_COUNT - 1]) {
        rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) {
            translate([63, 0, -3.6]) {
                rotate([0, 0, 20]) {
                    cube([ spoke_w, 18, spoke_h], center = true);
                }
            }
        }
    }
    
    //second spokes
    for (i = [0 : SPOKE_COUNT - 1]) {
        rotate([0, 0, (i + 0.5) * (360 / SPOKE_COUNT)]) {
            translate([(outer_d / 2) - (spoke_2_len / 2) - 2, 0, -3.6]) {
                cube([spoke_2_len, spoke_w, spoke_h], center = true);
            }
        }
    }

    //second spoke cross pieces
    for (i = [0 : (SPOKE_COUNT * 2) - 1]) {
        rotate([0, 0, (i + 0.5) * (360 / (SPOKE_COUNT * 2))]) {
            translate([spoke_cross_2_d, 0, -3.6]) {
                rotate([0, 0, -20]) {
                    cube([ spoke_w, spoke_cross_2_w, spoke_h], center = true);
                }
            }
        }
    }
    
    //third spokes
    for (i = [0 : (SPOKE_COUNT * 2) - 1]) {
        rotate([0, 0, (i + 0.5) * (360 / (SPOKE_COUNT * 2))]) {
            translate([(outer_d / 2) - (spoke_3_len / 2) - 2, 0, -3.6]) {
                cube([spoke_3_len, spoke_3_w, spoke_h], center = true);
            }
        }
    }

    translate([0, 0, -.1]) {
        rotate([0, 0, -90]) {
            film_guide(spiral_count);
        }
    }
}

module gnal_100ft_spiral_quarter (quarter = "a") {
    LEN = 220;

    module notch (NOTCH = 5) {
        cube([NOTCH, NOTCH, 5], center = true);
        translate([0, 0, (5 / 2) + (1 / 2)]) rotate([0, 0, 45]) cylinder(r1 = NOTCH / 1.4, r2 = 0.1, h = 1, center = true, $fn = 4);
    }
    
    module quarter () {
        NOTCH = 3;
        NOTCH_H = -5;
        NOTCHES = 7;
        OFFSET = 60;
        difference () {
            cube([LEN, LEN, LEN], center = true);
            for (i = [0 : NOTCHES - 1]) {
                translate([OFFSET - (i * (LEN / NOTCHES)), -(LEN / 2), NOTCH_H]) rotate([0, 0, 45]) notch(NOTCH);
            }
        }
        for (i = [0 : NOTCHES - 2]) {
            translate([-(LEN / 2), OFFSET - (i * (LEN / NOTCHES)), NOTCH_H]) rotate([0, 0, 45]) notch(NOTCH);
        }
    }

    intersection () {
        rotate([0, 0, 45]) gnal_100ft_spiral(quarter = true);
        if (quarter == "a") {
            rotate([0, 0, 0]) translate([LEN / 2, LEN / 2, 0]) quarter();
        } else if (quarter == "b") {
            rotate([0, 0, 90]) translate([LEN / 2, LEN / 2, 0]) quarter();
        } else if (quarter == "c") {
            rotate([0, 0, 180]) translate([LEN / 2, LEN / 2, 0]) quarter();
        } else if (quarter == "d") {
            rotate([0, 0, 270]) translate([LEN / 2, LEN / 2, 0]) quarter();
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

FN = 200;
$fn = FN;

module film_guide (rotations = 60, id = 45.55, spacing = 2.075, bottom = -2) {
    spiral(rotations, id, spacing, bottom, $fn);
}

PART="spindle_top";

if (PART == "spiral") {
    gnal_100ft_spiral();
} else if (PART == "quarter_a") {
    gnal_100ft_spiral_quarter("a");
} else if (PART == "quarter_b") {
    gnal_100ft_spiral_quarter("b");
} else if (PART == "quarter_c") {
    gnal_100ft_spiral_quarter("c");
} else if (PART == "quarter_d") {
    gnal_100ft_spiral_quarter("d");
} else if (PART == "top") {
    gnal_100ft_top();
} else if (PART == "spacer") {
    gnal_spacer();
} else if (PART == "insert_s8") {
    gnal_spiral_bottom_insert_s8();
} else if (PART == "insert_16") {
    gnal_spiral_bottom_insert_16();
} else if (PART == "insert_single") {
    gnal_spiral_bottom_insert_single();
} else if (PART == "spacer_16") {
    gnal_spacer_16();
} else if (PART == "spindle_top") {
    gnal_spindle_top();
} else if (PART == "spindle_bottom") {
    gnal_spindle_bottom();
} else if (PART == "spindle_single") {
    gnal_spindle_single();
}
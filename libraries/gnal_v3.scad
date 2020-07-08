//GNAL v3 Shared Library

include <./path_extrude.scad>;
include <./threads.scad>;

/**
 * THREADS
 * TOP (large screw) 
 * metric_thread (diameter=13.6, pitch=1.5 ,thread_size = 1.6, length = 21);
 * TOP VOID
 * metric_thread (diameter=13.6 + .5, pitch=1.5, thread_size = 1.6, length = 21);
 * + clone translated along Z by 0.2mm
 * BOTTOM (small screw)
 * metric_thread (diameter=10, pitch=1.5, thread_size = 1.6, length=LEN);
 */

OD = 10 + .5;
PITCH = 1.5;
THREAD = 1.6;
LEN = 21;

INSERT_D = 26;

function X (start_r, spacing, fn, r, i) = (start_r + (r * spacing) + (i * calcIncrement(spacing, fn))) * cos(i * calcAngle(fn));
function Y (start_r, spacing, fn, r, i) = (start_r + (r * spacing) + (i * calcIncrement(spacing, fn))) * sin(i * calcAngle(fn));

function circ (d) = PI * d;
function calcFacetSize (end_d, fn) = circ( end_d ) / fn;
//function calcSteps(rotations, fn) = fn * rotations;
function calcAngle (fn) = 360 / fn;
function calcFn(start_d, start_fn, end_d, spacing, r) = start_fn + 
    ( ((circ(calcR(start_d, spacing, r) * 2) - circ(start_d) ) 
        / (circ(end_d) - circ(start_d))) * ($fn - start_fn));
function calcR(start_d, spacing, r) = (start_d / 2) + (spacing * r);
function calcIncrement(spacing, fn) = spacing / fn;

/**
 * spiral_7 - Combination of spiral_3 and spiral_4 that doesn't sacrifice
 * performance. Hits an overflow when $fn is higher than 245 which creates
 * 8418 vectors at 60 rotations. This is an edge case, only appearing in OpenSCAD
 * 2019.05 (and maybe earlier), but should be explored.
 **/
module spiral (rotations = 40, start_d = 48, spacing = 2.075, fn) {

    bottom = -7.1;
    w = 1.4;
    top_w = .8;
    top_offset = (w - top_w);
    h = 2.2;
    
    facetProfile = [
        [w, -bottom],
        [0, -bottom],
        [0, 0], 
        [top_offset, -h],
        [w, -h],
        [w, 0]
    ];

    end_d = start_d + (spacing * 2 * rotations);
    end_r = end_d / 2;
    start_r = start_d / 2;

    facetSize = calcFacetSize(end_d, fn);
    start_fn = round(circ(start_d) / facetSize);


    spiralPath = [ for (r = [0 : rotations - 1]) for (i = [0 : round(calcFn(start_d, start_fn, end_d, spacing, r )) - 1 ])
                    [
                        X(start_r, spacing, round(calcFn(start_d, start_fn, end_d, spacing, r )), r, i), 
                        Y(start_r, spacing, round(calcFn(start_d, start_fn, end_d, spacing, r )), r, i), 
                        0] 
                    ];
    path_extrude(exShape=facetProfile, exPath=spiralPath);
}

/**
 * Core (center of the reel)
 **/
module gnal_spiral_core () {
    $fn = 360;
    
    core_center_h =  4.2 + 3;;
    
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
    
    film_void = 0.6;
    
    difference () {
        union() {
            //center
            translate([0, 0, -core_center_h / 2]) {
                cylinder(r = (core_bottom_outer_d - 1) / 2, h = core_center_h, center = true);
            }
            //top
            translate([0, 0, top_z_offset]) {
                cylinder(r = core_d / 2, h = core_h + core_center_h, center = true); 
            }
        }
        cylinder(r = void_d / 2, h = 30, center = true);
        translate([0, 0, -7.2]) spiral_bottom_insert_void();
    }

    //arms
    difference () {
        union () {
            translate([0, 0, top_z_offset]) difference() {
                //adjusted arm (shorter)
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
            //rounded arm end
            translate([(arms_outer_d + arms_inner_d) / 4, 0, top_z_offset]) cylinder(r = 3.5 / 2, h = core_h + core_center_h, center = true, $fn = 40);
            //adjusted arm
            translate([-((arms_outer_d + arms_inner_d) / 4)  + 1, 0, top_z_offset]) cylinder(r = 3.5 / 2, h = core_h + core_center_h, center = true, $fn = 40);
            difference () {
                rotate([0, 0, -120]) translate([13.75, 0, top_z_offset]) cube([16, 20, core_h + core_center_h], center = true);
                //remove piece from adjusted arm
                translate([-19, -14, 0]) rotate([0, 0, 10]) cube([4, 4, 30], center = true);
                //remove piece from non-adjusted arm
                rotate([0, 0, 45]) translate([-19, -14, 0]) rotate([0, 0, -10]) cube([4, 4, 30], center = true);
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
        //film void (notches)
        rotate([0, 0, -120]) {
            translate([20, -5, 0]) {
                rotate([0, 0, 45]) {
                    cube([20, film_void, 30], center = true);
                }
            }
        }
        rotate([0, 0, -120]) {
            translate([20, 5, 0]) {
                rotate([0, 0, -45]) {
                    cube([20, film_void, 30], center = true);
                }
            }
        }
        
        //flatten piece
        rotate([0, 0, -120]) translate([25, 0, 0]) difference () {
            cylinder(r = 8 / 2, h = 30, center = true);
            translate([-6.9, 0, 0]) cube([8, 8, 30], center = true);
        }
        cylinder(r = core_void_outer_d / 2, h = core_void_h, center = true);
        rotate([0, 0, -120]) translate([20, 0, -1.5]) rotate([0, 0, 45]) cube([20, 20, 3.01], center = true);
        cylinder(r = void_d / 2, h = 30, center = true);
        translate([0, 0, -7.2]) spiral_bottom_insert_void();
    }
}

module spiral_bottom_insert_void () {
    intersection () {
        rotate([0, 45, 0]) cube([3, INSERT_D + 2, 3], center = true);
        cylinder(r = (INSERT_D + 1) / 2, h = 6, center = true);
    }
    intersection () {
        rotate([0, 45, 90]) cube([3, INSERT_D + 2, 3], center = true);
        cylinder(r = (INSERT_D + 1) / 2, h = 6, center = true);
    }
}

module gnal_spiral_bottom_insert_s8 () {
    $fn = 160;
    void_d = 18 - .3;
    H = 17;
    D2 = INSERT_D;
    
    translate([0, 0, 0]) difference () {
        union () {
            cylinder(r = void_d / 2, h = H, center = true);
            //skirt
            translate([0, 0, -(H - 1) / 2]) cylinder(r = D2 / 2, h = 1.5, center = true);
            //notches
            translate([0, 0, -((H - 2.5) / 2) - .1]) {
                intersection () {
                    cylinder(r = D2 / 2, h = 6, center = true);
                    difference () {
                        rotate([0, 45, 0]) cube([3, D2 + 2, 3], center = true);
                        translate([0, 0, -1.5]) cube([6, D2 + 3, 3], center = true);
                    }
                }
                intersection () {
                    cylinder(r = D2 / 2, h = 6, center = true);
                    rotate([0, 0, 90]) difference () {
                        rotate([0, 45, 0]) cube([3, D2 + 2, 3], center = true);
                        translate([0, 0, -1.5]) cube([6, D2 + 3, 3], center = true);
                    }
                }
            }
        }
        translate([0, 0, -LEN / 2]) metric_thread (diameter=OD, pitch=PITCH, thread_size = THREAD, length=LEN);
    }
}

module gnal_spiral_bottom_insert_16 () {
    $fn = 160;
    
    void_d = 18 - .3;
    H = 17 + 8;
    D2 = INSERT_D;
    
    RIDGES = 8;
    RIDGE_D = 3;
    
    translate([0, 0, 0]) difference () {
        union () {
            cylinder(r = void_d / 2, h = H, center = true);
            //skirt
            translate([0, 0, -(H - 1) / 2]) cylinder(r = D2 / 2, h = 1.5, center = true);
            //notches
            translate([0, 0, -((H - 2.5) / 2) - .1]) {
                intersection () {
                    cylinder(r = D2 / 2, h = 6, center = true);
                    difference () {
                        rotate([0, 45, 0]) cube([3, D2 + 2, 3], center = true);
                        translate([0, 0, -1.5]) cube([6, D2 + 3, 3], center = true);
                    }
                }
                intersection () {
                    cylinder(r = D2 / 2, h = 6, center = true);
                    rotate([0, 0, 90]) difference () {
                        rotate([0, 45, 0]) cube([3, D2 + 2, 3], center = true);
                        translate([0, 0, -1.5]) cube([6, D2 + 3, 3], center = true);
                    }
                }
            }
        }
        translate([0, 0, -(H / 2) - 2]) metric_thread (diameter=OD, pitch=PITCH, thread_size = THREAD, length=LEN + 8);
        translate([0, 0, 8.5]) {
            for (i = [0: RIDGES - 1]) {
                rotate([0, 0, i * (360 / RIDGES)]) translate([void_d / 2, 0, 0]) cylinder(r = RIDGE_D / 2, h = 8.1, center = true);
            }
        }
    }
}

/**
 * Spacers
 **/

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
module gnal_spacer () {
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

module gnal_spacer_16 () {
    core_d = 29.5;
    core_bottom_d = 26.2 + .2;
    void_d = 18;
    h = 8;
    
    RIDGES = 8;
    RIDGE_D = 3;
    translate([0, 0, 0]) difference () {
        union () {
            difference () {
                cylinder(r = core_d / 2, h = h, center = true, $fn = 200);
                cylinder(r = void_d / 2, h = h + 1, center = true, $fn = 200);
            }
            translate([0, 0, -.75]) rotate([0, 180, 0]) spacer_outer_ridges();
        }
    }
    translate([0, 0, 0]) {
            for (i = [0: RIDGES - 1]) {
                rotate([0, 0, i * (360 / RIDGES)]) translate([void_d / 2, 0, 0]) cylinder(r = RIDGE_D / 2, h = 8, center = true);
            }
        }
}

/**
 * Spokes
 **/

module triangle_void () {
    length = (81 / 2) - 9 + 10;
    width = 12;
    height = 4.5 + 2.7;
    ANGLE_A = 34.8;
    ANGLE_B = 180 / SPOKE_COUNT;
    ANGLE_C = 20;
    difference () {
        translate([-1, 0, 0]) cube([length, width, height], center = true);
        translate([0, 10.3, 0]) rotate([0, 0, ANGLE_B]) cube([length * 2, width, height + 1], center = true);   
        translate([0, -10.3, 0]) rotate([0, 0, -ANGLE_B]) cube([length * 2, width, height + 1], center = true);

        translate([0, 10.3, -.7]) rotate([ANGLE_A, 0, 0]) cube([length *2, width, height * 10], center = true);   
        translate([0, -10.3, -.7]) rotate([-ANGLE_A, 0, 0]) cube([length *2, width, height * 10], center = true);

        translate([(length / 2) + 2, 0, 0]) rotate([0, 0, ANGLE_C]) cube([10, width * 2, height + 1], center = true);
    }  
    
}

module triangle_void_2 (i) {
    length = 43 - 8 + 12;
    width = 12;
    height = 4.5 + 2.7;
    ANGLE_A = 34.8;
    ANGLE_B = 90 / SPOKE_COUNT;
    ANGLE_C = 20;
    angle_w = 10.2;

    difference () {
        translate([-3, 0, 0]) cube([length, width, height], center = true);
        translate([0, angle_w, 0]) rotate([0, 0, ANGLE_B]) cube([length *2, width, height * 10], center = true);   
        translate([0, -angle_w, 0]) rotate([0, 0, -ANGLE_B]) cube([length *2, width, height * 10], center = true);

        translate([0, angle_w, -.7]) rotate([ANGLE_A, 0, 0]) cube([length *2, width, height * 10], center = true);   
        translate([0, -angle_w, -.7]) rotate([-ANGLE_A, 0, 0]) cube([length *2, width, height * 10], center = true);
        if (i % 2 == 0) {
            translate([-(length / 2) - 5, 0, 0]) rotate([0, 0, ANGLE_C]) cube([10, width * 2, height + 1], center = true);
        } else {
            translate([-(length / 2) - 7, 0, 0]) rotate([0, 0, ANGLE_C]) cube([10, width * 2, height + 1], center = true);
        }
        translate([(length / 2) + 1, 0, 0]) rotate([0, 0, -ANGLE_C]) cube([10, width * 2, height + 1], center = true);;
    }  
}

module triangle_void_3 (i) {
    length = 32 + 10;
    width = 10;
    height = 4.5 + 2.7;
    ANGLE_A = 31;
    ANGLE_B = 45 / SPOKE_COUNT;
    ANGLE_C = 20;
    angle_w = 7.8;
    difference () {
        translate([-3, 0, 0]) cube([length, width, height], center = true);
        translate([0, angle_w, 0]) rotate([0, 0, ANGLE_B]) cube([length *2, width, height * 10], center = true);   
        translate([0, -angle_w, 0]) rotate([0, 0, -ANGLE_B]) cube([length *2, width, height * 10], center = true);

        translate([0, angle_w, -.7]) rotate([ANGLE_A, 0, 0]) cube([length *2, width, height * 10], center = true);   
        translate([0, -angle_w, -.7]) rotate([-ANGLE_A, 0, 0]) cube([length *2, width, height * 10], center = true);
        if (i % 2 == 0) {
            translate([-(length / 2) - 7, 0, 0]) rotate([0, 0, -ANGLE_C]) cube([10, width * 2, height + 1], center = true);
        } else {
            translate([-(length / 2) - 5, 0, 0]) rotate([0, 0, -ANGLE_C]) cube([10, width * 2, height + 1], center = true);
        }
    }  
}
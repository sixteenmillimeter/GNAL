//GNAL v3 Shared Library

include <./path_extrude.scad>;
include <./threads.scad>;
include <./Triangles.scad>;

/**
 * THREADS
 * TOP (large screw) 
 * metric_thread (diameter=13.6, pitch=1.5 ,thread_size = 1.6, length = 21);
 * TOP VOID
 * metric_thread (diameter=13.6 + .5, pitch=1.5, thread_size = 1.6, length = 21);
 * + clone translated along Z by 0.2mm
 * BOTTOM (small screw)
 * metric_thread (diameter=10, pitch=1.5, thread_size = 1.6, length=LEN);
 * SINGLE LEVEL (middle screw)
 *
 */

DEBUG = false;
FINE = 200;

OD = 10 + .5;
PITCH = 1.5;
THREAD = 1.6;
LEN = 21;

INSERT_D = 26;
SINGLE_THREAD_D = 12;

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
module spiral (rotations = 40, start_d = 48, spacing = 2.075, bottom = -7.1, fn) {
    diam = (rotations * spacing * 2) + start_d;
    echo("DIAM", diam);
    echo("SPIRAL", rotations * PI * ((start_d + diam) / 2));
    //bottom = -7.1;
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

module spiral_reinforcement ( start_d = 48, spacing = 2.075, bottom = -2, fn) {
    rotations = 1;
    w = 1;
    top_w = .8;
    top_offset = (w - top_w);
    h = 2.2;
    
    facetProfile = [
        [w, -bottom],
        [0, -bottom],
        [0, 0], 
        [0, -h],
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
        translate([0, 0, -7.2]) spiral_insert_void();
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
        translate([0, 0, -7.2]) spiral_insert_void();
    }
}

module spiral_insert_void () {
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
    OD = 10.5 + .3;
    void_d = 18 - .6;
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
        translate([0, 0, -LEN / 2]) {
            if (DEBUG) {
                cylinder(r = OD / 2, h = LEN);
            } else {
                metric_thread (diameter=OD, pitch=PITCH, thread_size = THREAD, length=LEN);
            }
        }
    }
}

module gnal_spiral_bottom_insert_16 () {
    $fn = 160;
    OD = 10.5 + .3;
    
    void_d = 18 - .6;
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
        translate([0, 0, -(H / 2) - 2]) {
            if (DEBUG) {
                cylinder(r = OD / 2, h = LEN + 8);
            } else {
                metric_thread (diameter=OD, pitch=PITCH, thread_size = THREAD, length=LEN + 8);
            }
        }
        translate([0, 0, 8.5]) {
            for (i = [0: RIDGES - 1]) {
                rotate([0, 0, i * (360 / RIDGES)]) translate([void_d / 2, 0, 0]) cylinder(r = RIDGE_D / 2, h = 8.1, center = true);
            }
        }
    }
}

/**
 * Comment to preserve my sanity when developing: This single-spiral
 * insert is the same height as the s8 insert but has a different
 * diameter void fo the screw to prevent mismatching of spindle screws
 * designed for different purposes.
 **/
module gnal_spiral_bottom_insert_single () {
    $fn = 160;
    void_d = 18 - .6;
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
        translate([0, 0, -LEN / 2]) {
            if (DEBUG) {
                cylinder(r = SINGLE_THREAD_D / 2, h = LEN);
            } else {
                metric_thread (diameter=SINGLE_THREAD_D, pitch=PITCH, thread_size = THREAD, length = LEN);
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

module gnal_spacer_solid () {
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
            }
            translate([0, 0, -.75]) rotate([0, 180, 0]) spacer_outer_ridges();
        }
    }
}

/**
 * This spacer attaches to the top piece when it is used
 * for Super8 film.
 **/
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
    }
}


module gnal_spacer_16 () {
    core_d = 29.5;
    core_bottom_d = 26.2 + .2;
    void_d = 18.3;
    h = 8;
    
    RIDGES = 8;
    RIDGE_D = 3;
    difference () {
        gnal_spacer_solid();
        cylinder(r = void_d / 2, h = h + 1, center = true, $fn = 200);
    }
    translate([0, 0, 0]) {
            for (i = [0: RIDGES - 1]) {
                rotate([0, 0, i * (360 / RIDGES)]) translate([void_d / 2, 0, 0]) cylinder(r = RIDGE_D / 2, h = 8, center = true);
            }
        }
}

/**
 * Spindles
 **/

module gnal_spindle_base ( ) {
    D = 8.45 * 2;
    H = 20;
    union() {
        translate([0, 0, -15]) {
            cylinder(r = D / 2, h = H, center = true, $fn = FINE);
        }
    }
}

module gnal_spindle_bottom_base ( HEX = false) {
    //for grip
    BUMP = 2; //diameter
    BUMPS = 6;
    TOP_D = 19;
    TOP_H = 9.5;
    TOP_OFFSET = -24.5;
    
    union() {
        gnal_spindle_base();
        //hex version
        if (HEX) {
            translate([0, 0, TOP_OFFSET]) {
                cylinder(r = 11.1, h = TOP_H, center = true, $fn = 6);
            }
        } else {
            translate([0, 0, TOP_OFFSET]) {
                cylinder(r = TOP_D / 2, h = TOP_H, center = true, $fn = FINE); 
            }
        }
        for (i = [0 : BUMPS]) {
            rotate([0, 0, (360 / BUMPS) * i]) {
                translate([0, 8.9, TOP_OFFSET]) {
                    cylinder(r = BUMP, h = TOP_H, center = true, $fn = 60);
                }
            }
        }
    }
}

module outer_screw (LEN) {
    OD = 10;
    PITCH = 1.5;
    THREAD = 1.6;
    
    difference () {
        translate([0, 0, -7.1]) {
            if (DEBUG) {
                cylinder(r = OD / 2, h = LEN);
            } else {
                metric_thread (diameter=OD, pitch=PITCH, thread_size = THREAD, length=LEN);
            }
        }
        //bevel top of screw
        translate([0, 0, LEN - 8]) difference() {
            cylinder(r = 8, h = 3, center = true, $fn = FINE);
            cylinder(r1 = 6, r2 = 3, h = 3.01, center = true, $fn = FINE);
        }
    }
}

module gnal_spindle_bottom (ALT = false, HEX = false) {
    OD = 13.6 + .5;
    PITCH = 1.5;
    THREAD = 1.6;
    IN_LEN = 21;
    
    LEN = 17.1;
    ALT_LEN = 27.1;
    difference () {
        gnal_spindle_bottom_base(HEX);
        //inner screw negative
        translate([0, 0, -30]) union() {
            if (DEBUG) {
                cylinder(r = OD / 2, h = IN_LEN);
            } else { 
                metric_thread (diameter=OD, pitch=PITCH, thread_size = THREAD, length = IN_LEN);
            }
            translate([0, 0, 0.2]) {    
                if (DEBUG) {
                    cylinder(r = OD / 2, h = IN_LEN);
                } else {
                    metric_thread (diameter=OD, pitch=PITCH, thread_size = THREAD, length = IN_LEN);
                }
            }
        }
   }

    difference () {
        //outer screw
        if (ALT) {
            outer_screw(ALT_LEN);
        } else {
            outer_screw(LEN);
        }
    }  
}

module number_one () {
    rotate([0, 45, 0]) cube([1, 6, 1], center = true);
    translate([0, 6 / 2, 0]) rotate([45, 0, 0]) cube([2, 1, 1], center = true);
    translate([0, -6 / 2, 0]) rotate([45, 0, 0]) cube([2, 1, 1], center = true);
}

module gnal_spindle_top () {
    D = 50;
    THICKNESS = 2.5;
    H = 19.5;
    ROUND = 8;

    HANDLE_D = 13.25;
    HANDLE_BASE = 16;
    HANDLE_TOP = 13;
    HANDLE_H = 54.5;

    NOTCHES = 17;
    NOTCH = 1.5;
    FINE = 200;

    difference () {
        //cup
        translate([0, 0, ROUND - 2]) minkowski () {
            cylinder(r = (D / 2) - ROUND, h = (H * 2) - ROUND, center = true, $fn = FINE);
            sphere(r = ROUND, $fn = FINE);
        }
        translate([0, 0, ROUND  - 2 + THICKNESS]) minkowski () {
            cylinder(r = (D / 2) - THICKNESS - ROUND, h = (H * 2) - ROUND, center = true, $fn = 200);
            sphere(r = ROUND, $fn = FINE);
        }
        //hollow out cup
        translate([0, 0, H + ROUND - 4 -  3]) {
            cylinder(r = (D / 2) + 1, h = H * 2, center = true);
        }
        
        //inner cup bevel
        translate([0, 0, (H / 2) - ROUND - 1]) {
            cylinder(r1 = (D / 2) - 2.5, r2 = (D / 2) - 2.5 + 1, h = 1, center = true, $fn = FINE);
        }
        //outer cup bevel
        translate([0, 0, (H / 2) - ROUND - 1]) {
            difference () {
                cylinder(r = (D / 2) + .25, h = 1, center = true, $fn = FINE);
                cylinder(r2 = (D / 2) - .8, r1 = (D / 2) - .8 + 1, h = 1, center = true, $fn = FINE);
            }
        }
        //hole in cup
        translate([21, 0, -10]) cylinder(r = 3 / 2, h = 40, center = true, $fn = 40);
    }
    
    //reference cylinder
    //translate([0, 0, -6.6]) color("red") cylinder(r = 50 / 2, h = 19.57, center = true);

    //handle
    translate([0, 0, -15]) {
        difference() {
            cylinder(r1 = HANDLE_BASE / 2, r2 = HANDLE_TOP / 2, h = HANDLE_H, $fn = FINE);
            //text
            translate([3 / 2, 0, 15 + 39.75]) number_one();
            translate([-3 / 2, 0, 15 + 39.75]) number_one();
            //ring negative
            translate([0, 0, 31 + 14.5]) {
                difference () {
                        cylinder(r = HANDLE_D / 2 + 2, h = 20, center = true);
                        cylinder(r = HANDLE_D / 2 - .5, h = 20 + 1, center = true);
                }
            }
            //handle notches
            for(i = [0 : NOTCHES]) {
                rotate([0, 0, i * (360 / NOTCHES)]) {
                    translate([0, HANDLE_D / 2 - .5, 31 + 14.5]) {
                       rotate([0.75, 0, 0]) rotate([0, 0, 45]) { 
                           Right_Angled_Triangle(a = NOTCH, b = NOTCH, height = 20, centerXYZ=[true, true, true]);
                       }
                    }
                }
            }
            //bevel handle at top
           translate([0, 0, 54.01]) {
                difference () {
                    cylinder(r = 13 / 2, h = 1, center = true);
                    cylinder(r1 = 12.5 / 2, r2 = 11.5 / 2, h = 1.01, center = true);
                }
            }
        }

    }
    //attach handle with pyramid cylinder
    translate ([0, 0, -13.7]) {
        cylinder(r1 = 16 / 2 + 2, r2 = 16 / 2 - .1, h = 3, center = true, $fn = FINE);
    }
    //plate under cup
    translate([0, 0, -17.75]) {
        cylinder(r = 31.5 / 2, h = 1, center = true, $fn = FINE);
    }
    //screw
    translate([0, 0, -37.5]) {
        if (DEBUG) {
            cylinder(r = 13.6 / 2, h =  21);
        } else {
            metric_thread (diameter=13.6, pitch = PITCH, thread_size = THREAD, length = 21);
        }
    }
    //cylinder plug
    translate([0, 0, -37.5 + (21 / 2) - 1]) {
        cylinder(r = 12 / 2, h = 21, center = true, $fn = FINE);
    }
}

module gnal_spindle_single () {
    D = 50;
    THICKNESS = 2.5;
    H = 19.5;
    ROUND = 8;

    HANDLE_D = 13.25;
    HANDLE_BASE = 16;
    HANDLE_TOP = 13;
    HANDLE_H = 54.5;

    NOTCHES = 17;
    NOTCH = 1.5;
    FINE = 200;

    SINGLE_INSERT = 11;

    difference () {
        //cup
        translate([0, 0, ROUND - 2]) minkowski () {
            cylinder(r = (D / 2) - ROUND, h = (H * 2) - ROUND, center = true, $fn = FINE);
            sphere(r = ROUND, $fn = FINE);
        }
        translate([0, 0, ROUND  - 2 + THICKNESS]) minkowski () {
            cylinder(r = (D / 2) - THICKNESS - ROUND, h = (H * 2) - ROUND, center = true, $fn = 200);
            sphere(r = ROUND, $fn = FINE);
        }
        //hollow out cup
        translate([0, 0, H + ROUND - 4 -  3]) {
            cylinder(r = (D / 2) + 1, h = H * 2, center = true);
        }
        
        //inner cup bevel
        translate([0, 0, (H / 2) - ROUND - 1]) {
            cylinder(r1 = (D / 2) - 2.5, r2 = (D / 2) - 2.5 + 1, h = 1, center = true, $fn = FINE);
        }
        //outer cup bevel
        translate([0, 0, (H / 2) - ROUND - 1]) {
            difference () {
                cylinder(r = (D / 2) + .25, h = 1, center = true, $fn = FINE);
                cylinder(r2 = (D / 2) - .8, r1 = (D / 2) - .8 + 1, h = 1, center = true, $fn = FINE);
            }
        }
        //hole in cup
        translate([21, 0, -10]) cylinder(r = 3 / 2, h = 40, center = true, $fn = 40);
    }
    
    //reference cylinder
    //translate([0, 0, -6.6]) color("red") cylinder(r = 50 / 2, h = 19.57, center = true);

    //handle
    
    translate([0, 0, -15]) {
        difference() {
            cylinder(r1 = HANDLE_BASE / 2, r2 = HANDLE_TOP / 2, h = HANDLE_H, $fn = FINE);
            //text
            translate([0, 0, 15 + 39.75]) number_one();
            //ring negative
            translate([0, 0, 31 + 14.5]) {
                difference () {
                        cylinder(r = HANDLE_D / 2 + 2, h = 20, center = true);
                        cylinder(r = HANDLE_D / 2 - .5, h = 20 + 1, center = true);
                }
            }
            //handle notches
            for(i = [0 : NOTCHES]) {
                rotate([0, 0, i * (360 / NOTCHES)]) {
                    translate([0, HANDLE_D / 2 - .5, 31 + 14.5]) {
                       rotate([0.75, 0, 0]) rotate([0, 0, 45]) { 
                           Right_Angled_Triangle(a = NOTCH, b = NOTCH, height = 20, centerXYZ=[true, true, true]);
                       }
                    }
                }
            }
            //bevel handle at top
           translate([0, 0, 54.01]) {
                difference () {
                    cylinder(r = 13 / 2, h = 1, center = true);
                    cylinder(r1 = 12.5 / 2, r2 = 11.5 / 2, h = 1.01, center = true);
                }
            }
        }

    }
    //attach handle with pyramid cylinder
    translate ([0, 0, -13.7]) {
        cylinder(r1 = 16 / 2 + 2, r2 = 16 / 2 - .1, h = 3, center = true, $fn = FINE);
    }
    //plate under cup
    translate([0, 0, -17.75]) {
        cylinder(r = 31.5 / 2, h = 1, center = true, $fn = FINE);
    }
    //insert for single layer
    translate ([0, 0, -24.25]) {
        cylinder(r = 22 / 2, h = 14, center = true, $fn = FINE);
    }
    //screw
    translate([0, 0, -37.5 - SINGLE_INSERT]) {
        if (DEBUG) {
            cylinder(r = SINGLE_THREAD_D / 2, h = 21);
        } else {
            metric_thread (diameter=SINGLE_THREAD_D, pitch = PITCH, thread_size = THREAD, length = 21);
        }
    }
    //cylinder plug
    translate([0, 0, -37.5 - SINGLE_INSERT + (21 / 2) - 1]) {
        cylinder(r = 10 / 2, h = 21, center = true, $fn = FINE);
    }
}

module gnal_stacking_spindle () {
    OD = 10.5 + .3;
    IN_LEN = 21;
    
    LEN = 17.1;
    ALT_LEN = 27.1;
    difference () {
        union () {
            gnal_spindle_base();
            translate([0, 0, -23.75]) gnal_spacer_solid();
        }
        //inner screw negative
        translate([0, 0, -30]) union() {
            if (DEBUG) {
                cylinder(r = OD / 2, h = IN_LEN);
            } else { 
                metric_thread (diameter=OD, pitch=PITCH, thread_size = THREAD, length = IN_LEN);
            }
            translate([0, 0, 0.2]) {    
                if (DEBUG) {
                    cylinder(r = OD / 2, h = IN_LEN);
                } else {
                    metric_thread (diameter=OD, pitch=PITCH, thread_size = THREAD, length = IN_LEN);
                }
            }
        }
   }

    difference () {
         outer_screw(LEN - 2);
    }  
}
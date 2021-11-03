/**
 * Used to workshop the stacking screw 
 * */

module stacking_debug () {
    translate([0, 0, 72 + 72 + 36]) {
        color("blue") gnal_spindle_top();
    }
    translate([0, 0, 72 + 72]) rotate([0, 180, 0]) intersection () {
        gnal_50ft_top();
        cylinder(r = 50 / 2, h = 50, center = true);
    }
    
    translate([0, 0, 72 + 30]) {
        color("blue") rotate([0, 180, 0]) gnal_spindle_bottom();
    }
    
    translate([0, 0, 72 + 36]) difference () {
        cylinder(r = 50 / 2, h = 16, center = true);
        cylinder(r = 22.5 / 2, h = 16 + 1, center = true);
    }
    
    translate([0, 0, 36 + 30]) {
        color("green") rotate([0, 180, 0]) gnal_stacking_spindle();
    }
    
    translate([0, 0, 72]) difference () {
        cylinder(r = 50 / 2, h = 16, center = true);
        cylinder(r = 22.5 / 2, h = 16 + 1, center = true);
    }
    
    translate([0, 0, 30]) {
        color("green") rotate([0, 180, 0]) gnal_stacking_spindle();
    }
    
    translate([0, 0, 36]) difference () {
        cylinder(r = 50 / 2, h = 16, center = true);
        cylinder(r = 22.5 / 2, h = 16 + 1, center = true);
    }
    
    color("blue") translate([0, 0, 12 + 3]) gnal_spacer_16();
    //#1 - bottom spiral
    difference () {
        cylinder(r = 50 / 2, h = 16, center = true);
        cylinder(r = 22.5 / 2, h = 16 + 1, center = true);
        translate([0, 0, -8]) spiral_insert_void();
    }
    
    color("blue") translate([0, 0, -12]) gnal_spiral_bottom_insert_16();
    
}

module stacking_debug2 () {
    translate([0, 0, 72 + 47]) {
        color("blue") gnal_spindle_top();
    }
    translate([0, 0, 72 + 26]) rotate([0, 180, 0]) intersection () {
        gnal_50ft_top();
        cylinder(r = 50 / 2, h = 50, center = true);
    }
    
    translate([0, 0, 72 - 4]) {
        color("blue") rotate([0, 180, 0]) gnal_spindle_bottom();
    }
    
    translate([0, 0, 72 + 8]) difference () {
        cylinder(r = 50 / 2, h = 16, center = true);
        cylinder(r = 22.5 / 2, h = 16 + 1, center = true);
    }
    
    translate([0, 0, 36 + 8]) {
        color("green") rotate([0, 180, 0]) gnal_stacking_spindle();
    }
    
    translate([0, 0, 55.5]) difference () {
        cylinder(r = 50 / 2, h = 16, center = true);
        cylinder(r = 22.5 / 2, h = 16 + 1, center = true);
    }
    
    translate([0, 0, 20]) {
        color("green") rotate([0, 180, 0]) gnal_stacking_spindle();
    }
    
    translate([0, 0, 32]) difference () {
        cylinder(r = 50 / 2, h = 16, center = true);
        cylinder(r = 22.5 / 2, h = 16 + 1, center = true);
    }
    
    color("blue") translate([0, 0, 12 + 3 + 5]) gnal_spacer_16();
    //#1 - bottom spiral
    translate([0, 0, 8]) difference () {
        cylinder(r = 50 / 2, h = 16, center = true);
        cylinder(r = 22.5 / 2, h = 16 + 1, center = true);
        translate([0, 0, -8]) spiral_insert_void();
    }
    color("blue") translate([0, 0, 11]) gnal_spiral_bottom_insert_16();
    H = 120;
    translate([0, 0, H / 2 - 2]) color("red") cube([1, 50, H], center = true);
}
D=300; // start diameter
N=1;   // number of spirals
FN=100;
$fn=FN;


H = 2.1;

/**
 * Render all spiral facets for as many rotations as supplied
 */
module spiral (START_D = 50, SPIRALS = 39) {
    //STOP_D = 100;
  
    SPACING = 0.86;//1.34;
  
  	TOP_T = 0.86; //thickness
  	BOTTOM_T = 1.4;
  
  	START_R = START_D / 2;
    union () {
        for (i = [0 : $fn]) {
            rotate ([0, 0, i * (360 / $fn)]) {
                for (x = [0: (SPIRALS - 1)]) {
                      spiral_facet(i, x, START_R, SPACING, BOTTOM_T, TOP_T, H);
                }
            }
        }
    }
}

/**
 * Generates a single face of the spiral, in this case a trapazoidal
 * shape. Issues are (1) performance (maybe use of hull()) and (2) all
 * facet lenths are the same, despite the diameter. This means that
 * there are excessive numbers of facets for the smaller spirals to
 * compensate for the number of facets needed for the outer spiral.
 */

module spiral_facet (i, x, START_R, SPACING, BOTTOM_T, TOP_T, H) {
    STEP_SIZE = ((SPACING + BOTTOM_T) / $fn); 
    
    STEP_OFFSET =  i * STEP_SIZE;
    SPIRAL_START_OFFSET = (x * (SPACING + BOTTOM_T));
    
    ACTUAL_R = START_R + SPIRAL_START_OFFSET + STEP_OFFSET;
    
	L = 2 * (ACTUAL_R * tan((360 / $fn) / 2));
    
    ANGLE = -atan( STEP_SIZE / (L / 2) ) / 2; 
    
    OFFSET = START_R - (BOTTOM_T / 2) + SPIRAL_START_OFFSET + STEP_OFFSET;
    
    translate ([OFFSET, 0, - H / 2]) {
        rotate ([0, 0, ANGLE]) {
            //replace hull for quick render?
            //test spiral lib
            hull () {
                translate([0, 0, H]) 
                    cube([TOP_T, L, 0.1], center=true);
                    cube([BOTTOM_T, L, 0.1], center=true);   
            }
        }
    }
}

spiral(D, N);

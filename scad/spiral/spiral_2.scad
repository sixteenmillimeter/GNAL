D=300; // start diameter
N=1;   // number of spirals
FN=100;
$fn=FN;

module spiral_facet (i, SPIRAL, START_R = 48, SPACING = 2, FACET_SIZE = 1, FN = 360) {
    BOTTOM_T = 1.2;
    TOP_T = .3;
    H = 2.1;
    
    STEP_SIZE = SPACING / FN; 
    STEP_OFFSET =  (SPIRAL * SPACING) + (i * STEP_SIZE);
    
    ROT = i* (360 / FN);
    ANGLE = 0;
    
    OFFSET = START_R + STEP_OFFSET;
    
    rotate([0, 0, ROT]) translate ([OFFSET, 0, - H / 2]) {
        rotate ([0, 0, ANGLE]) {
            hull () {
                translate([(BOTTOM_T - TOP_T) / 2, 0, H]) 
                    cube([TOP_T, FACET_SIZE, 0.1], center=true);
                    cube([BOTTOM_T, FACET_SIZE, 0.1], center=true);   
            }
            //cube([BOTTOM_T, FACET_SIZE, H], center = true);
        }
    }
}

//https://www.youtube.com/watch?v=lsSeRxpoIaY
//https://www.mathportal.org/calculators/plane-geometry-calculators/right-triangle-calculator.php
module spiral (SPIRALS = 40, START_D = 48) {
    SPACING = 2.075;
    FACET_SIZE = 1;
    for (SPIRAL = [0 : SPIRALS - 1]) {
        //C = PI * R^2
        C = PI * pow(( (START_D / 2) + (SPIRAL * SPACING) ) / 2, 2);
        FN = ceil( (C / FACET_SIZE) * .37 );
        
        for (i = [0 : FN - 1]) {
            spiral_facet(i, SPIRAL, START_D / 2, SPACING, FACET_SIZE, FN);
        }
    }
}

spiral(N, D);
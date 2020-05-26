D=300; // start diameter
N=1;   // number of spirals
FN=100;
$fn=FN;

include <../libraries/path_extrude.scad>;

/**
 * This approach is the fastest by far (!!!). Unlike spiral_4, this does not adjust
 * the $fn value as the spiral grows in diameter, but simply uses it as a constant
 * for all spirals. This means that the innermost spiral will have n=$fn facets and 
 * the outermost facets will have the same number. Need to find a hybrid between
 * this and #4.
 **/

module spiral (count = 40, start_d = 48, spacing = 2.075) {
    
    //$fn = 80;
    
    bottom = 1.2;
    top = .3;
    top_offset = (bottom - top);
    h = 2.2;
    
    angle_i = 360 / $fn;
    increment = spacing / $fn;
    
    facetProfile = [[0, 0], [top_offset, -h], [bottom, -h], [bottom, 0]];

    /**
     * Verbose
         spiralPath = [ 
            //for facet number times "count" or number of rotations
            //create an array containing [ x, y, z] values for path extrude
            for(t = [0 : $fn * count]) {
                  [
                    //starting radius + (iterator * increment size) * (cosine || sine) of (iterator * fractional angle
                    ((start_d / 2) + (t * increment)) * cos(t * angle_i), //x value
                    ((start_d / 2) + (t * increment)) * sin(t * angle_i), //y value
                    0 //z value
                  ] 
                }
            ];
     **/
    
    
    spiralPath = [ for(t = [0 : $fn * count])
    [((start_d / 2) + (t * increment)) * cos(t * angle_i), ((start_d / 2) + (t * increment)) * sin(t * angle_i), 0] ];
    
    path_extrude(exShape=facetProfile, exPath=spiralPath);
}

spiral(N, D);
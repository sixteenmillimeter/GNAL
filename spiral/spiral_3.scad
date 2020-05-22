D=300; // start diameter
N=1;   // number of spirals
FN=100;
$fn=FN;

include <../libraries/path_extrude.scad>;

module spiral (count = 40, start_d = 48, spacing = 2.075) {
    
    //$fn = 80;
    
    bottom = 1.2;
    top = .3;
    top_offset = (bottom - top);
    h = 2.2;
    
    angle_i = 360 / $fn;
    increment = spacing / $fn;
    
    facetProfile = [[0, 0], [top_offset, -h], [bottom, -h], [bottom, 0]];
    
    
    spiralPath = [ for(t = [0 : $fn * count])
    [((start_d / 2) + (t * increment)) * cos(t * angle_i), ((start_d / 2) + (t * increment)) * sin(t * angle_i), 0] ];
    
    path_extrude(exShape=facetProfile, exPath=spiralPath);
}

spiral(N, D);
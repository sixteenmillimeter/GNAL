D=300; // start diameter
N=1;   // number of spirals
FN=100;
$fn=FN;

include <../libraries/path_extrude.scad>;

/**
 * Distinction from spiral_3: use of for loop and union to join rotations.
 **/

module spiral (count = 40, start_d = 48, spacing = 2.075) {
    facet_size = 30;
    bottom = 1.2;
    top = .4;
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

spiral(N, D);
D=300; // start diameter
N=1;   // number of spirals
FN=100;
$fn=FN;

include <../libraries/path_extrude.scad>;

//Distinction from v4 compressed spiralPath generation into single line

module spiral (count = 40, start_d = 48, spacing = 2.095) {
    facet_size = 10;
    bottom = 1.2;
    top = .3;
    top_offset = (bottom - top);
    h = 2.2;
    
    facetProfile = [[0, 0], [top_offset, -h], [bottom, -h], [bottom, 0]];
    
    spiralPath = [ for (s = [0 : count - 1]) for(t = [0 : ceil( (PI * pow((start_d + (s * spacing * 2)) / 2, 2)) / facet_size ) - 1]) [(((start_d + (s * spacing * 2)) / 2) + (t * (spacing / ceil( (PI * pow((start_d + (s * spacing * 2)) / 2, 2)) / facet_size )))) * cos(t * (360 / ceil( (PI * pow((start_d + (s * spacing * 2)) / 2, 2)) / facet_size ))), (((start_d + (s * spacing * 2)) / 2) + (t * (spacing / ceil( (PI * pow((start_d + (s * spacing * 2)) / 2, 2)) / facet_size )))) * sin(t * (360 / ceil( (PI * pow((start_d + (s * spacing * 2)) / 2, 2)) / facet_size ))), 0] ];
    
    path_extrude(exShape=facetProfile, exPath=spiralPath);
}

spiral(N, D);
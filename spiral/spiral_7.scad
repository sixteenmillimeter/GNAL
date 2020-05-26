D=300; // start diameter
N=1;   // number of spirals
FN=100;
$fn=FN;

include <../libraries/path_extrude.scad>;


bottom = 1.2;
top = .3;
top_offset = (bottom - top);
h = 2.2;

facetProfile = [[0, 0], [top_offset, -h], [bottom, -h], [bottom, 0]];


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
 * 8418 vectors at 60 rotations. It's an edge casem 
 **/
module spiral (rotations = 40, start_d = 48, spacing = 2.075, fn) {

    end_d = start_d + (spacing * 2 * rotations);
    end_r = end_d / 2;
    start_r = start_d / 2;

    facetSize = calcFacetSize(end_d, fn);
    start_fn = round(circ(start_d) / facetSize);

    echo(facetSize);

    spiralPath = [ for (r = [0 : rotations - 1]) for (i = [0 : round(calcFn(start_d, start_fn, end_d, spacing, r )) - 1 ])
                    [
                        X(start_r, spacing, round(calcFn(start_d, start_fn, end_d, spacing, r )), r, i), 
                        Y(start_r, spacing, round(calcFn(start_d, start_fn, end_d, spacing, r )), r, i), 
                        0] 
                    ];
    echo(len(spiralPath));
    path_extrude(exShape=facetProfile, exPath=spiralPath);
}


spiral(N, D, 2.075, $fn);


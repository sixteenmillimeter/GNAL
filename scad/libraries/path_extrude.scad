//  path_extrude.scad -- Extrude a path in 3D space
//  usage: add "use <path_extrude.scad>;" to the top of your OpenSCAD source code

//  Copyright (C) 2014-2019  David Eccles (gringer) <bioinformatics@gringene.org>

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.

//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

// Determine the projection of a point on a plane centered at c1 with normal n1
function project(p, c, n) =
    p - (n * (p - c)) * n / (n * n);

// determine angle between two points with a given normal orientation
// see https://stackoverflow.com/questions/14066933/
//        direct-way-of-computing-clockwise-angle-between-2-vectors
//    dot = p1 * p2;
//    det = (p1[0]*p2[1]*n1[2] + p2[0]*n1[1]*p1[2] + n1[0]*p1[1]*p2[2]) -
//          (n1[0]*p2[1]*p1[2] + p1[0]*n1[1]*p2[2] + p2[0]*p1[1]*n1[2]);
//    atan2(det, dot);
// determine angle between two planar points and a centre
// with a given normal orientation
function getPlanarAngle(p1, p2, c1, n1) =
    let(p1 = p1-c1, n1=n1 / norm(n1), p2=p2-c1)
    atan2((p1[0]*p2[1]*n1[2] + p2[0]*n1[1]*p1[2] + n1[0]*p1[1]*p2[2]) -
          (n1[0]*p2[1]*p1[2] + p1[0]*n1[1]*p2[2] + p2[0]*p1[1]*n1[2]), p1 * p2);

function c3D(tPoints) =
    (len(tPoints[0]) == undef) ? // single point
        c3D([tPoints])[0] :
        (len(tPoints[0]) < 3) ?  // collection of 2D points
            tPoints * [[1,0,0],[0,1,0]] :
            tPoints;             // 3D points

// translate a point (or points)
function myTranslate(ofs, points, acc = []) =
    (len(points[0]) == undef) ?
        myTranslate(ofs, [points])[0] :
        [ for(i = [0:(len(points) - 1)])
          [ for(d = [0:(len(points[0])-1)]) (ofs[d] + points[i][d])]];

// rotate a point (or points)
function myRotate(rotVec, points) =
    let(rotX = [[1,              0,               0],
                [0, cos(rotVec[0]), -sin(rotVec[0])],
                [0, sin(rotVec[0]),  cos(rotVec[0])]],
        rotY = [[ cos(rotVec[1]), 0,-sin(rotVec[1])],
                [              0, 1,              0],
                [ sin(rotVec[1]), 0, cos(rotVec[1])]],
        rotZ = [[ cos(rotVec[2]), sin(rotVec[2]), 0],
                [ sin(rotVec[2]), -cos(rotVec[2]), 0],
                [0,              0,               1]])
    (len(points[0]) == undef) ?
        myRotate(rotVec, [points])[0] :
        c3D(points) * rotX * rotY * rotZ;

// Determine spherical rotation for cartesian coordinates
function rToS(pt) =
    [-acos((pt[2]) / norm(pt)),
         0,
         -atan2(pt[0],pt[1])];

function calcPreRot(p1, p2, p3) =
  let(n1=p2-p1, // normal between the two points (i.e. the plane that the polygon sits on)
      n2=p3-p2,
      rt1=rToS(n1),
      rt2=rToS(n2),
      pj1=(p2 + myRotate(rt2, [[1e42,0,0]])[0]),
      pj2=project(p=(p1 + myRotate(rt1, [[1e42,0,0]])[0]), c=p2, n=n2))
  getPlanarAngle(p1=pj1, p2=pj2, c1=p2, n1=n2);

function cumSum(x, res=[]) =
  (len(x) == len(res)) ? concat([0], res) :
    (len(res) == 0) ? cumSum(x=x, res=[x[0]]) :
        cumSum(x=x, res=concat(res, [x[len(res)] + res[len(res)-1]]));

// Create extrusion side panels for one polygon segment as triangles.
// Note: panels are not necessarily be planar due to path twists
function makeSides(shs, pts, ofs=0) =
  concat(
    [for(i=[0:(shs-1)]) [i+ofs, ((i+1) % shs + ofs + shs) % (shs * pts),
                         (i+1) % shs + ofs]],
    [for(i=[0:(shs-1)]) [((i+1) % shs + ofs + shs) % (shs * pts),
                         i+ofs, (i + ofs + shs) % (shs * pts)]]);

// Concatenate the contents of the outermost list
function flatten(A, acc = [], aDone = 0) =
    (aDone >= len(A)) ? acc :
       flatten(A, acc=concat(acc, A[aDone]), aDone = aDone + 1);

// Linearly interpolate between two shapes
function makeTween(shape1, shape2, t) =
    (t == 0) ? shape1 :
      (t == 1) ? shape2 :
        [for (i=[0:(len(shape1)-1)])
          (shape1[i]*(1-t) + shape2[i % len(shape2)]*(t))];

// Extrude a 2D shape through a 3D path
// Note: merge has two effects:
//   1) Removes end caps
//   2) Adjusts the rotation of each path point
//      so that the end and start match up
module path_extrude(exPath, exShape, exShape2=[],
    exRots = [0], exScale = [1], merge=false, preRotate=true){
  exShapeTween = (len(exShape2) == 0) ?
    exShape : exShape2;
  shs = len(exShape); // shs: shape size
  pts = len(exPath);  // pts: path size
  exPathX = (merge) ? concat(exPath, [exPath[0], exPath[1]]) :
      concat(exPath,
            [exPath[pts-1] + (exPath[pts-1] - exPath[pts-2]),
             exPath[pts-1] + 2*(exPath[pts-1] - exPath[pts-2])]);
  exScaleX = (len(exScale) == len(exPath)) ? exScale :
      [for (i = [0:(pts-1)]) exScale[i % len(exScale)]];
  preRots = [for(i = [0:(pts-1)])
    preRotate ?
      calcPreRot(p1=exPathX[i], // "current" point on the path
                p2=exPathX[(i+1)], // "next" point on the path
                p3=exPathX[(i+2)]) :
      0 ];
  cumPreRots = cumSum(preRots);
  seDiff = cumPreRots[len(cumPreRots)-1]; // rotation difference (start - end)
  // rotation adjustment to get start to look like end
  seAdj = -seDiff / (len(cumPreRots));
  adjPreRots = (!merge) ? cumPreRots :
    [for(i = [0:(pts-1)]) (cumPreRots[i] + seAdj * i)];
  adjExRots = (len(exRots) == 1) ?
    [for(i = [0:(len(adjPreRots)-1)]) (adjPreRots[i] + exRots[0])] :
    [for(i = [0:(len(adjPreRots)-1)]) (adjPreRots[i] + exRots[i % len(exRots)])];
  phPoints = flatten([
    for(i = [0:(pts-1)])
      let(p1=exPathX[i],
          p2=exPathX[(i+1)],
          n1=p2-p1, // normal between the two points
          rt1=rToS(n1))
      myTranslate(p1, myRotate(rt1, myRotate([0,0,-adjExRots[i]],
        c3D(makeTween(exShape, exShapeTween, i / (pts-1)) *
          exScaleX[i]))))
    ]);
  if(merge){ // just the surface, no end caps
      polyhedron(points=phPoints,
        faces=flatten([
              for(i = [0:(pts-1)])
                makeSides(shs, pts, ofs=shs*i)
              ])
          );
  } else {
      polyhedron(points=phPoints,
        faces=concat(
            flatten([
              for(i = [0:(pts-2)])
                makeSides(shs, pts, ofs=shs*i)
              ]),
            concat( // add in start / end covers
              [[for(i= [0:(shs-1)]) i]],
              [[for(i= [(len(phPoints)-1):-1:(len(phPoints)-shs)]) i]]
            )
          ));
  }
}

myPathTrefoil = [ for(t = [0:(360 / 101):359]) [ // trefoil knot
    5*(.41*cos(t) - .18*sin(t) - .83*cos(2*t) - .83*sin(2*t) -
       .11*cos(3*t) + .27*sin(3*t)),
    5*(.36*cos(t) + .27*sin(t) - 1.13*cos(2*t) + .30*sin(2*t) +
       .11*cos(3*t) - .27*sin(3*t)),
    5*(.45*sin(t) - .30*cos(2*t) +1.13*sin(2*t) -
       .11*cos(3*t) + .27*sin(3*t))] ];

myPointsOctagon =
  let(ofs1=15)
  [ for(t = [0:(360/8):359])
     ((t==90)?1:2) * [cos(t+ofs1),sin(t+ofs1)]];
myPointsChunkOctagon =
  let(ofs1=15)
  [ for(t = [0:(360/8):359])
    ((t==90)?0.4:1.9) *
     [cos((t * 135/360 + 45)+ofs1+45)+0.5,sin((t * 135/360 + 45)+ofs1+45)]];
//myPoints = [ for(t = [0:(360/8):359]) 2 * [cos(t+45),sin(t+45)]];

pts=[2,0,0.5];

/*translate([0,0,0]) {
    path_extrude(exRots = [$t*360], exShape=myPointsOctagon,
                 exPath=myPathTrefoil, merge=true);
}*/

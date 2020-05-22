D=300; // start diameter
N=1;   // number of spirals
FN=100;
$fn=FN;

R = (D + (N * 2.095)) / 2;

module ShapeToExtrude ()
{
    bottom = 1.2;
    top = .3;
    top_offset = (bottom - top);
    h = 2.2;
	// Build in +x space. The outside edge of this shape must follow the extrusion path, or there will be open seams..
	polygon ( points= [
        [0, 0], 
        [top_offset, h],
        [bottom, h],
        [bottom, 0]
	]);
}

module InwardSpiral (StepSize, Steps, StartRadius, Pitch, ShapeX) {
		for (i=[0 : Steps - 1]) {
		// This could be made more computationally efficient
		// by collapsing intermediate values and by doing only
		// essential calculations inside the loop, but for now
		// let's just leave it easy to read.

		ThisTheta = StepSize * i;
		NextTheta = StepSize * (i + 1);
		ThisRadius = StartRadius - i * (Pitch * (StepSize / 360));

		// Spiral step approximated by arc of radius ThisRadius,
		// passing through the start and end points calculated here.
		
		NextRadius = StartRadius - (i + 1) * (Pitch * (StepSize / 360));
		ThisX = ThisRadius * sin(ThisTheta);
		ThisY = ThisRadius * cos(ThisTheta);
		NextX = NextRadius * sin(NextTheta);
		NextY = NextRadius * cos(NextTheta);
		DeltaX = NextX - ThisX;
		DeltaY = NextY - ThisY;
		SlopeToNext = DeltaY / DeltaX;
		BisecSlope = -1 / SlopeToNext;
		ThisXYToBisector = sqrt(DeltaX * DeltaX + DeltaY * DeltaY) / 2;
		BisectX = ThisX + (DeltaX / 2);
		BisectY = ThisY + (DeltaY / 2);
		BisectToCentre = sqrt(pow(ThisRadius, 2) - pow(ThisXYToBisector, 2));
		AbsXComponent = sqrt(pow(BisectToCentre, 2) / ( 1 + pow(BisecSlope, 2)));
		XComponent = NextY < ThisY ? AbsXComponent: -AbsXComponent;
		YComponent = XComponent * BisecSlope;
		CentreX = BisectX - XComponent;
		CentreY = BisectY - YComponent;
		ExtrudeAngle = -2 * acos(BisectToCentre / ThisRadius);
		ArcOrientation = NextY < ThisY ? atan(BisecSlope) - (ExtrudeAngle / 2) : -180 + atan(BisecSlope) -(ExtrudeAngle / 2);
		translate([CentreX, CentreY, 0]) {
			rotate ([0, 0, ArcOrientation]) {
				rotate_extrude (angle=ExtrudeAngle, $fn=300) translate ([ThisRadius - ShapeX, 0, 0])ShapeToExtrude();
            }
        }
	}
}


module spiral () {
    SPIRALROTATION=N * 360;
    SPIRALSTEPS=180;
    INITIALRADIUS= 300 / 2 ;
    PITCH=2.095;
    XMAXSHAPE=2;
    
    InwardSpiral (
        SPIRALROTATION/SPIRALSTEPS,
        SPIRALSTEPS,
        INITIALRADIUS,
        PITCH,
        XMAXSHAPE);
}

spiral();
// Made by Matthew Dirks - http://skylogic.ca

// the "Y Belt Clip.stl" that comes with MendelMax 2 has screw holes that are
// 60 mm apart by 16 mm apart.

include <nutsnbolts/cyl_head_bolt.scad>;
include <nutsnbolts/materials.scad>;

RES = 200;

plankThickness = 4;
beltHoleWidth = 8;
beltHoleLength = 10;
beltHoleMarginFromEdge = 5;

screwHoleDistanceX = 29;
screwHoleDistanceY = 100;

screwHoleMargin = 5; //mm
screwHoleDiam = 3;

blockWY = screwHoleDiam + screwHoleMargin*2;
blockWX = screwHoleDistanceX + screwHoleDiam + screwHoleMargin*2;
// echo("blockWX",blockWX);
blockWZ = plankThickness; //mm
holeLength = blockWZ+2;

legDistance = 100;
baseCenterZ = 10 + 22 + 15;

difference() {
	union() {
		translate([-blockWX/2, legDistance/2-blockWY/2, 0]) 
			cube([blockWX, blockWY, blockWZ], $fn=RES);
		translate([-blockWX/2, -legDistance/2-blockWY/2, 0]) 
			cube([blockWX, blockWY, blockWZ], $fn=RES);
	}

	translate([screwHoleDistanceX/2, legDistance/2, -1]) rotate(a=[180,0,0]) 
		hole_through(name="M3", l=holeLength, cl=0.1, h=0, hcl=0.4, $fn=RES);
	translate([-screwHoleDistanceX/2, legDistance/2, -1]) rotate(a=[180,0,0]) 
		hole_through(name="M3", l=holeLength, cl=0.1, h=0, hcl=0.4, $fn=RES);

	//(2)
	translate([screwHoleDistanceX/2, -legDistance/2, -1]) rotate(a=[180,0,0]) 
		hole_through(name="M3", l=holeLength, cl=0.1, h=0, hcl=0.4, $fn=RES);
	translate([-screwHoleDistanceX/2, -legDistance/2, -1]) rotate(a=[180,0,0]) 
		hole_through(name="M3", l=holeLength, cl=0.1, h=0, hcl=0.4, $fn=RES);
}

//Part that holds the belt (the "clip")
clipWY = 20;
clipWX = blockWX;
clipWZ = plankThickness;
clipZ = 10+22+15;


// 2 Legs
dy = legDistance/2-blockWY/2;
dz = clipZ;
legAngle = atan(dz/dy)+4.57;

legLength = sqrt(dy*dy+dz*dz)-4.87;
legThickness = plankThickness;
legWidth = blockWX;

translate([-legWidth/2, 6.88, clipZ-0.5])
rotate([-legAngle, 0, 0])
cube([legWidth, legLength, legThickness]);

translate([-legWidth/2, -dy+0.03, 0.03])
rotate([legAngle, 0, 0])
cube([legWidth, legLength, legThickness]);

// Parts I need to avoid colliding with:
/*
translate([0, -20, 0])
cube([10, 40, 10]);
translate([0, -11, 0])
cube([10, 22, 22]);
*/

module fillet(r, h) {
    translate([r / 2, r / 2, 0])
        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true, $fn=RES);
        }
}

radius = plankThickness/2;

module beltHole(holeLength) {
	union() {
		translate([-holeLength, -0.5, -beltHoleWidth/2])
			cube([holeLength, plankThickness+1, beltHoleWidth]);

		fillet(radius, beltHoleWidth);
		translate([0, 2*radius, 0])
		rotate([0,0,-90])
			fillet(radius, beltHoleWidth);
	}
}

//Part that holds the belt (the "clip")
difference() {
	translate([-clipWX/2, -clipWY/2, clipZ-clipWZ/2]) 
		cube([clipWX, clipWY, clipWZ]);

	translate([clipWX/2-beltHoleMarginFromEdge,0,clipZ-radius])
	rotate([90,0,0])
	beltHole(beltHoleLength);

	translate([-clipWX/2+beltHoleMarginFromEdge,0,clipZ-radius])
	rotate([90,0,180])
	beltHole(beltHoleLength);

	//middle hole
	translate([-radius+0.2,0,clipZ-radius])
	rotate([90,0,180])
	beltHole(radius);
	translate([radius-0.2,0,clipZ-radius])
	rotate([90,0,0])
	beltHole(radius);
}
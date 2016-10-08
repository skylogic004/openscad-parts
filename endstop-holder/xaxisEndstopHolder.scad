
include <../nutsnbolts/cyl_head_bolt.scad>;
include <../nutsnbolts/materials.scad>;

RES = 200;


dx = 7;

// dyBottomM3Block = 6; // a part of dyTop
dyTopM3Block = 4+3;
aLittleHigher = 3;
dyTop = 20+dyTopM3Block + aLittleHigher;

dyBottom = 7+5;

dzTop = 10;
dzBottomB = dzTop;
dzBottomA = 3.5; // 2 <= val <= 4

dzBottomScrewHeadLen = 7;



module part() {
	translate([-dx/2, -dyTop, 0])
	cube(size=[dx, dyTop, dzTop], center=false);
	
	// translate([0, 
	translate([-dx/2, 0, 0])
	cube(size=[dx, dyBottom, dzBottomB], center=false);
}


extra = 1;
dxGap = 2;
dyGap = 20 - 3 - 3;

screwLength = 10;
M3HeadLen = 2;



difference() {
	part();

	// The "bridge" gap
	translate([
		dx/2-dxGap,
		-dyTop + dyTopM3Block,
		-dzTop/2])
	cube(size=[dxGap+extra, dyGap, dzTop*2]);


	// Screw holes
	translate([
		0 - M3HeadLen - dx/2 + M3HeadLen - 1, 
		-dyTop + 4 + 20, 
		//-(dyBottomM3Block/2), 
		dzTop/2
	])
	rotate([0,-90,0])
	hole_through(name="M3", l=screwLength, cl=0.1, h=M3HeadLen+1, hcl=0.4, $fn=RES);

	translate([
		0 - M3HeadLen - dx/2 + M3HeadLen - 1, 
		-dyTop + 4, 
		dzTop/2
	])
	rotate([0,-90,0])
	hole_through(name="M3", l=screwLength, cl=0.1, h=M3HeadLen+1, hcl=0.4, $fn=RES);


	// extra hole
	// translate([-3.5, -2, dzBottomA])
	// cube([2, 2, 4]);

	// Screw hole to attach to T-nut
	translate([0, 3.5, dzBottomA+dzBottomScrewHeadLen])
	hole_through(name="M3", l=screwLength, cl=0.1, h=dzBottomScrewHeadLen, hcl=0.4, $fn=RES);

}

// Module instantiation
translate([-1,-16,5])
rotate([90,0,-90])
Letters("MD");

// Module definition.
// size=30 defines an optional parameter with a default value.
module Letters(letter, size=10, height=3) {
	// convexity is needed for correct preview
	// since characters can be highly concave
	linear_extrude(height=height, convexity=4)
	text(letter, 
		size=size*13/30,
		font="Bitstream Vera Sans",
		halign="center",
		valign="center", $fn=RES);
}

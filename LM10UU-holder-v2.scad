// Made by Matthew Dirks - http://skylogic.ca

include <nutsnbolts/cyl_head_bolt.scad>;
include <nutsnbolts/materials.scad>;

RES = 200;

//I have customized this part specifically to hold a LM10UU and to screw onto 
//a MendelMax 2.0

//"bottom of part" refers to the -z side
//(you would see the bottom if viewer located at z = -999 and looking toward origin)

//LM10UU: gap between where the "snap rings" should go is 20mm
// see http://www.thingiverse.com/thing:307608/#comments
gapBetweenSnapRings = 20;
//LM10UU has inside diameter 10mm, and outer diameter 19mm
LM10UU_outer = 19; 

//### Block containing holes for screws/nuts ###
screwGap = 9; //distance between the centers of the 2 screw holes
blockHeight = 9;
screwFromEdge = 2;
nutCatchGap = 5; //distance from bottom of part to top of nut catch
screwLength = 8; //if using M3-8, specify 8mm here. Will make screw hole this long.
blockWidthY = gapBetweenSnapRings;
blockLengthX = screwGap + 2*screwFromEdge;

yTranslate = (blockWidthY/2);

difference() {
	translate([0, -yTranslate, 0]) 
		cube([blockLengthX, blockWidthY, blockHeight], $fn=RES);

	//Nutcatch & screw hole (1)
	translate([screwGap + screwFromEdge, 0, nutCatchGap]) 
		nutcatch_sidecut("M3", l=100, clk=0.1, clh=0.1, clsl=0.1);
	translate([screwGap + screwFromEdge, 0, -11]) rotate(a=[180,0,0]) 
		hole_through(name="M3", l=screwLength, cl=0.1, h=10, hcl=0.4, $fn=RES);

	//Nutcatch & screw hole (2)
	translate([0 + screwFromEdge, 0, nutCatchGap]) rotate(a=[0,0,180]) 
		nutcatch_sidecut("M3", l=100, clk=0.1, clh=0.1, clsl=0.1);
	translate([0 + screwFromEdge, 0, -11]) rotate(a=[180,0,0]) 
		hole_through(name="M3", l=screwLength, cl=0.1, h=10, hcl=0.4, $fn=RES);
}

//### Hollow cylinder that holds the LM10UU (linear slider) ###
height = gapBetweenSnapRings;
opening = 20;
thickness = 2;
cylHoleRadius = LM10UU_outer / 2;
cylOutsideRadius = cylHoleRadius + thickness;

blockCenter = blockLengthX/2;
cylY = 18.5;

module cylinderPart() {
	translate([blockCenter, yTranslate, cylY])
	rotate([90,0,0])
	difference() {
		cylinder(r1=cylOutsideRadius, r2=cylOutsideRadius, h=height, $fn=RES);
		// translate([0,0,-thickness/2])
		// cylinder(r1=cylHoleRadius, r2=cylHoleRadius, h=height+2, $fn=RES);
	}
}
//### Top
// cd = 3;
// translate([0,0,31])
// rotate([90,0,90])
// cylinder(r1=cd, r2=cd, h=20, $fn=RES);

topGap = 2;

topScrewYLen = 10;
topScrewXLen = 3 + topGap;
topScrewZLen = 4;
topScrewRad = 4;

topScrewZ = blockHeight + cylOutsideRadius*2 - topScrewZLen/2 - 1; //29

module topScrewPart() {
	// translate([blockLengthX/2-topScrewXLen/2, -(topScrewYLen/2), topScrewZ])
	//cube([topScrewXLen, topScrewYLen, topScrewZLen]);

	translate([
		blockLengthX/2-topScrewXLen/2, 
		0, 
		topScrewZ
	])
	rotate([0,90,0]) 
	cylinder(r1=topScrewRad, r2=topScrewRad, h=topScrewXLen, $fn=RES);
}

subYLen = blockWidthY + 2;
topNutGapXLen = 3;
difference() {
	union() {
		topScrewPart();
		cylinderPart();
	}

	//Gap at the top of the part
	translate([
		blockLengthX/2 - topGap/2,
		-subYLen/2,
		topScrewZ - 1.5
	]) {
		cube([topGap, subYLen, topScrewZLen+thickness]);
	}

	//Screw hole in top
	translate([
		screwLength/2 + blockLengthX/2, 
		0, 
		topScrewZ + topScrewZLen/2
	])
	rotate([0,90,0])
	hole_through(name="M3", l=screwLength, cl=0.1, h=0, hcl=0.4, $fn=RES);

	//Hole for LM10UU
	translate([blockCenter, yTranslate, cylY])
	rotate([90,0,0])
	translate([0,0,-thickness/2])
		cylinder(r1=cylHoleRadius, r2=cylHoleRadius, h=height+2, $fn=RES);

	//Hole for nut for top screw hole
	translate([
		blockLengthX/2, 
		0, 
		topScrewZ + topScrewZLen/2
	])
	rotate([0,90,0])
	{
		translate([0,0,-topNutGapXLen - topScrewXLen/2])
		cylinder(r1=3, r2=3, h=topNutGapXLen, $fn=RES);
		translate([0,0,topScrewXLen/2])
		cylinder(r1=3, r2=3, h=topNutGapXLen, $fn=RES);
	}
}

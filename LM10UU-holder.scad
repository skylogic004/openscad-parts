// Made by Matthew Dirks - http://skylogic.ca

include <nutsnbolts/cyl_head_bolt.scad>;
include <nutsnbolts/materials.scad>;

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
	translate([0, -yTranslate, 0]) cube([blockLengthX, blockWidthY, blockHeight]);

	//Nutcatch & screw hole (1)
	translate([screwGap + screwFromEdge, 0, nutCatchGap]) nutcatch_sidecut("M3", l=100, clk=0.1, clh=0.1, clsl=0.1);
	translate([screwGap + screwFromEdge, 0, -11]) rotate(a=[180,0,0]) hole_through(name="M3", l=screwLength, cl=0.1, h=10, hcl=0.4);

	//Nutcatch & screw hole (2)
	translate([0 + screwFromEdge, 0, nutCatchGap]) rotate(a=[0,0,180]) nutcatch_sidecut("M3", l=100, clk=0.1, clh=0.1, clsl=0.1);
	translate([0 + screwFromEdge, 0, -11]) rotate(a=[180,0,0]) hole_through(name="M3", l=screwLength, cl=0.1, h=10, hcl=0.4);
}

//### Hollow cylinder that holds the LM10UU (linear slider) ###
height = gapBetweenSnapRings;
opening = 20;
thickness = 2;
cylHoleRadius = LM10UU_outer / 2;
cylOutsideRadius = cylHoleRadius + thickness;

blockCenter = blockLengthX/2;
cylY = 18.4;

translate([blockCenter, yTranslate, cylY])
rotate([90,0,0])
difference() {
	cylinder(r1=cylOutsideRadius, r2=cylOutsideRadius, h=height);
	translate([0,0,-1])
	cylinder(r1=cylHoleRadius, r2=cylHoleRadius, h=height+2);
}

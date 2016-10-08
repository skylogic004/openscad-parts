include <../nutsnbolts/cyl_head_bolt.scad>;
include <../nutsnbolts/materials.scad>;

echo("################# START PROGRAM ###############");
echo("Maybe: let print bottom be XZ plane, with the letters being on top.");

RES = 200;

// There are 2 main components:
// 1. The part that screws into the aluminum extrusion of the MendelMax.
//		Codename: "ext"
// 2. The part that screws into the optical endstop.
//		Codename: "opt"
//
// dx, dy, and dz means width or height or depth, along one axis


M3screwRadius = 1.5;
M3nutThickness = 2;

extra = 1; // extra room while subtracting holes. This is any positive non-zero value.

zMoveOptAwayFromExtrusion = 5;

//### OPT
optM3nutCatchThickness = M3nutThickness; // This makes room for a M3 nut (or M3 head depending on how you orient your screw)
optScrewLength = 10; // arbitrary length, must be long enough to go through the part
opt_nScrews = 2;
optM3block = 5.5;
opt_screwToScrew = 14+optM3block/2*opt_nScrews;

dyOpt_extra_connectorSide = 1; // max 1mm (to allow connector to fit off the end)
dyOpt_extra_otherSide = 1; //0;

endstopLength = 14+optM3block*opt_nScrews;
endstopThickness = 5;

dyOpt = endstopLength + dyOpt_extra_connectorSide + dyOpt_extra_otherSide;
dxOpt = 7;
dzOpt = 10;

dxOptGap = 2;
dyOptGap = 19 - 3 - 3;

xOpt = -15;
yOpt = 0;
zOpt = -zMoveOptAwayFromExtrusion;

//### EXT
M3HeadPass = 7; // this is bigger than an M3 head, so that M3 screw can pass through

extScrewMargin = 3;
extScrewDist = 20;

dxExt = extScrewMargin*3 + extScrewDist;
dyExt = 12;
dzExt = 3.5;

elongate = 2;

neededScrewLen = 6.5; // after the part, to screw into aluminum extrusion

//### info
opt_requiredM3Length = dxOpt - optM3nutCatchThickness + M3nutThickness + endstopThickness;
echo(str(">>>> Required minimum M3 length for OPT part is ", opt_requiredM3Length, " mm"));

echo(str(">>>> Required M3 length for EXT part is ", dzExt+neededScrewLen, " mm"));

// Calculate distance (along y-axis) from ext screw center
// to endstop sensor center
tmpDist = dyExt/2 + dyOpt_extra_otherSide + optM3block + dyOptGap/2;
echo(str(">>>> Distance from ext screw center to endstop sensor center is ", tmpDist));

tmpDist = dyExt - dzOpt + dzExt;
echo(str(">>>> Distance from alum. ext. to OPT part MUST be at least 5mm. Current dist is ", tmpDist));


visualizeTmpDist = false;
if (visualizeTmpDist) {
	translate([-11,dyExt/2,0]) {
		cube([1,1,1], center=true);
		translate([0,-tmpDist,0]) cube([1,1,1], center=true);
	}
}

module optPart() {
	translate([-dxOpt/2, -dyOpt, 0])
	cube(size=[dxOpt, dyOpt, dzOpt], center=false);

	//V.1
	// translate([-1,-dyOpt_extra_otherSide - endstopLength/2,5]) // center of text
	// rotate([90,-90,-90])
	// Letters("MD", height=0.5);

	// Quarter-cylinder: extra support to hold opt to ext
	translate([-dxOpt/2,0,dyExt])
	rotate([0,90,0])
	pie_slice(r=dyExt,a=90,h=dxOpt);

	// support that connects quarter-cylinder to ext part
	// translate([-dxOpt/2,0,dyExt])
	// cube([dxOpt, dyExt, 0]);

}

module optSubtracts() {
	// The "bridge" gap
	translate([
		dxOpt/2-dxOptGap,
		-dyOptGap/2 - dyOpt_extra_otherSide - endstopLength/2,
		-dzOpt/2])
	cube(size=[dxOptGap+extra, dyOptGap, dzOpt*2]);

	// Screw holes
	translate([
		- dxOpt/2 - extra,
		-dyOpt_extra_otherSide - optM3block/2,
		dzOpt/2
	]) {
		rotate([0,-90,0])
		// hole_through(name="M3", l=optScrewLength, cl=0.1, h=optM3nutCatchThickness+extra, hcl=0.4, $fn=RES);
		hole_through(name="M3", l=optScrewLength, cl=0.1, h=0, hcl=0.4, $fn=RES);

		translate([optM3nutCatchThickness+0.5*M3nutThickness,0,0])
		rotate([0,90,0])
		nutcatch_parallel("M3", l=M3nutThickness+extra);


		translate([0, -opt_screwToScrew, 0]) {
			rotate([0,-90,0])
			// hole_through(name="M3", l=optScrewLength, cl=0.1, h=optM3nutCatchThickness+extra, hcl=0.4, $fn=RES);
			hole_through(name="M3", l=optScrewLength, cl=0.1, h=0, hcl=0.4, $fn=RES);

			translate([optM3nutCatchThickness+0.5*M3nutThickness,0,0])
			rotate([0,90,0])
			nutcatch_parallel("M3", l=M3nutThickness+extra);

			translate([0,-10,-2])
			cube([M3nutThickness+extra, 10, 4]);
		}
	}

}


module extPart() {
	// square corners
	// translate([-dxExt, 0, 0])
	// cube(size=[dxExt, dyExt, dzExt], center=false);

	// rounded corner version of above
	hull() {
		translate([-dxExt+dyExt/2, dyExt/2, 0]) {
			translate([dxExt-dyExt,0,0]) 
			cylinder(r=dyExt/2, h=dzExt, $fn=RES);
			cylinder(r=dyExt/2, h=dzExt, $fn=RES);
		}
	}

	translate([-dxExt/2-0.4,0,.5]) // center of text
	rotate([90,0,0])
	Letters("M", height=0.6, size=12);

}

module extSubtracts() {
	// Screw hole to attach to T-nut
	translate([
		-(extScrewMargin + M3screwRadius),
		dyExt/2,
		dzExt+extra
	]) {
		// SCREW HOLE 1
		hull() { //make elongated screw hole by making a hull from 2 holes
			translate([0,-elongate,0])
			hole_through(name="M3", l=dzExt+2*extra, cl=0.1, h=0, hcl=0.4, $fn=RES);
			translate([0,elongate,0])
			hole_through(name="M3", l=dzExt+2*extra, cl=0.1, h=0, hcl=0.4, $fn=RES);
		}

		// SCREW HOLE 2
		translate([-extScrewDist,0,0]) {
		hull() { //make elongated screw hole by making a hull from 2 holes
			translate([0,-elongate,0])
			hole_through(name="M3", l=dzExt+2*extra, cl=0.1, h=0, hcl=0.4, $fn=RES);
			translate([0,elongate,0])
			hole_through(name="M3", l=dzExt+2*extra, cl=0.1, h=0, hcl=0.4, $fn=RES);
		}}
	}
}

difference() {
	union() {
		color([1,0,0])
		translate([xOpt, yOpt, zOpt])
		optPart();

		color([0,1,0])
		translate([0,0,-dzOpt/2+dyExt])
		extPart();
	};

	translate([xOpt, yOpt, zOpt])
	optSubtracts();

	translate([0,0,dzOpt-dzExt])
	extSubtracts();
}


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

module pie_slice(r=3.0,a=30,h=1) {
	$fn=RES;
	linear_extrude(height = h, center=false)
	intersection() {
		circle(r=r);

		square(r);
		rotate(a-90) square(r);
	}
}

echo("################# END PROGRAM #################");

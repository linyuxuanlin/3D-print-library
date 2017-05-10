use <backbone.scad>;
use <hip.scad>;
use <leg.scad>;
use <servo_button.scad>;
use <shoulder.scad>;

bb_length=100;
bb_width=14;
bb_height=8;

// generic 9g
servo_length = 23;
servo_width = 12.5;
servo_tall = 26;	//top to bottom of servo casing (w/o drive gear)
servo_clear = 5.5;  	//servo clearance from inside shoulder wall
horn_radius1 = 3.5;
horn_radius2 = 2;
horn_rdist = 13;

/*
// uncomment for tower pro servo
servo_length = 23.5;
servo_width = 12.5;
servo_tall = 27;
servo_clear = 7;  
horn_radius1 = 3.6;
horn_radius2 = 1.75;
horn_rdist = 14;
/*

/* individual parts (for export) - uncomment one line at a time */
//backbone(bb_length,bb_width,bb_height,servo_length,servo_width);
//hip(servo_length,servo_width);
//leg(servo_length,servo_width);
//shoulder(servo_tall,servo_clear,horn_radius1,horn_radius2,horn_rdist);
//servo_button();

show_full_assembly=1;
h_pos = (bb_length-20)/2;	


if (show_full_assembly==1){
	//full assembly example
	backbone(bb_length,bb_width,bb_height,servo_length,servo_width);
	
	for ( i = [h_pos, -h_pos]){
		translate([0,i,(bb_height/2)]) hip(servo_length,servo_width);
	}
	
	translate([-h_pos,h_pos,0]) rotate([0,90,0]) shoulder(servo_tall,servo_clear,horn_radius1,horn_radius2,horn_rdist);
	translate([-h_pos,-h_pos,0]) rotate([0,90,0]) shoulder(servo_tall,servo_clear,horn_radius1,horn_radius2,horn_rdist);
	translate([h_pos,h_pos,0]) rotate([0,-270,180]) shoulder(servo_tall,servo_clear,horn_radius1,horn_radius2,horn_rdist);
	translate([h_pos,-h_pos,0]) rotate([0,-270,180]) shoulder(servo_tall,servo_clear,horn_radius1,horn_radius2,horn_rdist);
	
	translate([-h_pos,h_pos,0]) rotate([90,0,-90]) shoulder(servo_tall,servo_clear,horn_radius1,horn_radius2,horn_rdist);
	translate([-h_pos,-h_pos,0]) rotate([-90,0,-270]) shoulder(servo_tall,servo_clear,horn_radius1,horn_radius2,horn_rdist);
	translate([h_pos,h_pos,0]) rotate([-90,0,270]) shoulder(servo_tall,servo_clear,horn_radius1,horn_radius2,horn_rdist);
	translate([h_pos,-h_pos,0]) rotate([90,0,90]) shoulder(servo_tall,servo_clear,horn_radius1,horn_radius2,horn_rdist);
	
	
	translate([h_pos*2,h_pos,0]) rotate([90,0,0]) leg(servo_length,servo_width);
	translate([h_pos*2,-h_pos,0]) rotate([90,0,0]) leg(servo_length,servo_width);
	translate([-h_pos*2,h_pos,0]) rotate([90,180,0]) leg(servo_length,servo_width);
	translate([-h_pos*2,-h_pos,0]) rotate([90,180,0]) leg(servo_length,servo_width);
}

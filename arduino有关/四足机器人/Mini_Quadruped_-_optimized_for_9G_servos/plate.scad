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

//tower pro
//servo_length = 23.5;
//servo_width = 12.5;
//servo_tall = 27;
//servo_clear = 7;  
//horn_radius1 = 4;
//horn_radius2 = 2;
//horn_rdist = 15;

translate([0,-82,4]) rotate([0,0,90]) backbone(bb_length,bb_width,bb_height,servo_length,servo_width);	

translate([-62,-49,0]) rotate([0,0,90]) leg(servo_length,servo_width);
translate([-48,-30,0]) rotate([0,0,-90]) leg(servo_length,servo_width);
translate([62,-49,0])  rotate([0,0,90]) leg(servo_length,servo_width);
translate([48,-30,0]) rotate([0,0,-90]) leg(servo_length,servo_width);
		
translate([41,-40,0]) servo_button();
translate([41,-50,0]) servo_button();
translate([41,-60,0]) servo_button();
translate([41,-70,0]) servo_button();
translate([-41,-40,0]) servo_button();
translate([-41,-50,0]) servo_button();
translate([-41,-60,0]) servo_button();
translate([-41,-70,0]) servo_button();


translate([-34,-102,0]) hip(servo_length,servo_width);
translate([34,-102,0]) hip(servo_length,servo_width);

for (y=[-53, -13]){
	for (i= [ -27 : 18 : 27 ]){
		translate([i,y,0]) rotate([0,0,90]) shoulder(servo_tall,servo_clear,horn_radius1,horn_radius2,horn_rdist); 
	}
}



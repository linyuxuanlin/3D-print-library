//9g generic
shoulder(26,5.5,3.5,2,13);
//tower servo
translate([0,20,0]) shoulder(27,7,3.6,1.75,14);


module shoulder(st,sc,hr1,hr2,hrd){
	// st = servo tall gap
	// cc = servo clearance from inside wall
	// hr1 = horn radius1
	// hr2 = horn radius2
	// hrd = distance between horn radii

	//bottom plate constants
	plate_thick = 3.5;
	offset_x = 4; offset_y = 4;
	m3_screw_dia = 3;
	m3_screw_head_dia = 7;
	m3_screw_head_height = 1.75;
	m3_nut_wrench_size = 6.5;
	m3_nut_height = 1.75;

	//calc'd starts
	ch_st = (st/2)-1;
	hr_st = -((st/2)+6);

	hh = sc+14.15;

	//channel bracket
	difference(){
		union(){
			//vert wall
			translate([ch_st,-8,0]) cube([6,16,hh+.35]);
			//round top
			translate([ch_st,0,hh+.35]) rotate([0,90,0]) cylinder(r=8, h=6, $fn=100);
		}
		// button hole bottom
		translate([ch_st,0,hh]) rotate([0,90,0]) cylinder(r=3,h=6,$fn=100);		
		// button hole top
		translate([ch_st-2,0,hh-.1]) rotate([0,90,0]) cylinder(r=5.6,h=3,$fn=100);	
		//bottom channel
		translate([ch_st+5,-5,-1]) cube([2,10,30]);
	}
	
	//horn bracket
	difference(){
		union(){
			//vert wall
			translate([hr_st,-8,0]) cube([5,16,hh+.35]);
			//round top
			translate([hr_st,0,hh+.35]) rotate([0,90,0]) cylinder(r=8, h=5, $fn=100);
		}
		//servo horn hole
		translate([hr_st,0,hh]) rotate([0,90,0]) cylinder(r=hr1,h=6,$fn=100);
		//servo horn channel
		hull(){	
			//top channel
			translate([hr_st-1,-3.5,hh]) cube([3,7,9]);
			//large round
			translate([hr_st-1,0,hh]) rotate([0,90,0]) cylinder(r=hr1,h=3,$fn=100);	
			//small round
			translate([hr_st-1,0,hh-hrd]) rotate([0,90,0]) cylinder(r=hr2,h=3,$fn=100);
		}
	}

	
	
	
	difference(){
		//main plate
		translate([-19,-8,0]) cube([37,16,plate_thick]);
		//screw holes
		for (i = [[offset_x-.5,offset_y,-1],[offset_x-.5,-offset_y,-1],[-offset_x-.5,offset_y,-1],[-offset_x-.5,-offset_y,-1]]){	
			translate(i) cylinder(r=m3_screw_dia/2, h=plate_thick+2, $fn=20);
		}
		//screw head holes
		for (i = [[offset_x-.5,-offset_y,plate_thick-m3_screw_head_height+.1],[-offset_x-.5,-offset_y,plate_thick-m3_screw_head_height+.1]]){
			translate(i) cylinder(r=m3_screw_head_dia/2, h=m3_screw_head_height, $fn=20);
		}
		//nut traps
		for (i = [[offset_x-.5,offset_y,plate_thick-m3_nut_height+.1],[-offset_x-.5,offset_y,plate_thick-m3_nut_height+.1]]){
			translate(i) cylinder(r=m3_nut_wrench_size/2, h=m3_nut_height, $fn=6);
		}
	}
}

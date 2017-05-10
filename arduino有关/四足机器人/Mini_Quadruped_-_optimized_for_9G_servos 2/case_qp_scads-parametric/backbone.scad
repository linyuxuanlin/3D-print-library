backbone(90,14,8,23,12.5);

module backbone(bl,bw,bh,sl,sw){
	h_pos = ((bl-20) / 2);		
	difference(){
		// main
		translate([-(bw/2),-(bl/2),-(bh/2)]) color("purple") cube([bw,bl,bh]);

		//servo body cutouts
		for (i = [[-16.5,h_pos,0],[16.5,h_pos,0],[-16.5,-h_pos,0],[16.5,-h_pos,0]]){
			translate(i) #cube([sl,sw,bh], center=true);
		}		

		//servo mount holes
		for (i = [[2.5,h_pos,-10],[-2.5,h_pos,-10],[-2.5,-h_pos,-10],[2.5,-h_pos,-10]]){
			translate(i) cylinder(r=1,h=20,$fn=20);
		}

		//round side indents
		for (i = [[34,17,-5],[34,-17,-5],[-34,17,-5],[-34,-17,-5]]) {
			translate(i) cylinder(r=30,h=10,$fn=200);
		}

		//center hole
		translate([0,0,-4]) cylinder(r=3,h=10,$fn=200);
	}
}

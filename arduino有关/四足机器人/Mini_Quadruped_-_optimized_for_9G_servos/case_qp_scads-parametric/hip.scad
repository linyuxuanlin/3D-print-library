

hip(23,12.5);

module hip(l,w){
   difference(){
            union(){
         //main
         translate([-29,-10,0]) cube([58.5,20,4]);

         //outside edges
         for (i = [[-32.5,-7,0],[26.5,-7,0]] ){
         	   translate(i) cube([6,14,4]);
         }

         //rounded corners
         for (i = [[-29.5,7,0],[-29.5,-7,0],[29.5,7,0],[29.5,-7,0]] ){
            translate(i) cylinder(r=3,h=4,$fn=50);
         }
      }
      
      //servo mount holes
      for (i = [[-2.5,0,-2],[-30.5,0,-2],[2.5,0,-2],[30.5,0,-2]] ){
         translate(i) cylinder(r=1,h=20,$fn=20);
      }
      
      //servo body cutouts
      for (i = [[-16.5,0,2],[16.5,0,2]] ){
         translate(i)  cube([l,w,22], center=true);
      }

   }
}

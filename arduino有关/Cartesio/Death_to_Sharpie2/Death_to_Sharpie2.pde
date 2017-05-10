///////////////////////////////////////////////////////////////////////////////////////////////////////
// My Drawbot, "Death to Sharpie"
// Jpeg to gcode simplified (kinda sorta works version, v3.2 (beta))
//
// Scott Cooper, Dullbits.com, <scottslongemailaddress@gmail.com>
//
// Open creative GPL source commons with some BSD public GNU foundation stuff sprinkled in...
// If anything here is remotely useable, please give me a shout.
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Constants set by user, or maybe your sister.
      int     A3=0;
      int     vert=1;
      float   paper_size_x = 200+120*A3;   
      float   paper_size_y = 280;
      float   paper_x_offset;
      float   paper_y_offset;
      float   image_size_x = 0;
      float   image_size_y = 0;
final float   paper_top_to_origin = 0;  //mm

// Super fun things to tweak.  Not candy unicorn type fun, but still...
final int     squiggle_total = 340;  //400   // Total times to pick up the pen
final int     squiggle_length = 300; //600   // Too small will fry your servo
final int     half_radius = 3;       //3   // How grundgy
final int     adjustbrightness = 7;  //8   // How fast it moves from dark to light, over draw
final float   sharpie_dry_out = 0.0;   // Simulate the death of sharpie, zero for super sharpie
String        nameFile="14";
final String  pic_path = "pics\\"+nameFile+".jpg";

//Every good program should have a shit pile of badly named globals.
int    screen_offset = 4;
float  screen_scale = 1.0;
int    steps_per_inch = 25;
int    x_old = 0;
int    y_old = 0;
PImage img;
int    darkest_x = 100;
int    darkest_y = 100;
float  darkest_value;
int    squiggle_count;
int    x_offset = 0;
int    y_offset = 0;
float  drawing_scale;
float  drawing_scale_x;
float  drawing_scale_y;
int    drawing_min_x =  9999999;
int    drawing_max_x = -9999999;
int    drawing_min_y =  9999999;
int    drawing_max_y = -9999999;
int    center_x;
int    center_y;
boolean is_pen_down;
PrintWriter OUTPUT;       // instantiation of the JAVA PrintWriter object.
float  adj_x=0;
float  adj_y=0;
float  max_gcode_x=0;
float  max_gcode_y=0;
float  min_gcode_x=10000;
float  min_gcode_y=10000;
int    lines=0;
int    dim_screen=700;

///////////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  size(dim_screen*2, dim_screen, JAVA2D);
  noSmooth();
  //colorMode(HSB, 360, 100, 100, 100);
  background(255);  
  frameRate(120);
  
  OUTPUT = createWriter("GCODE\\"+nameFile+".GCODE");
  pen_up();
  setup_squiggles();
  img.loadPixels();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
    scale(screen_scale);
    random_darkness_walk();
  
    if (squiggle_count >= squiggle_total) {
        grid();
        dump_some_useless_stuff_and_close();
        println("Max Gcode X:"+max_gcode_x+ "  y:"+max_gcode_y); 
        println("Min Gcode X:"+min_gcode_x+ "  y:"+min_gcode_y);
        float d1=max_gcode_x-min_gcode_x;
        float d2=max_gcode_y-min_gcode_y;
        println("Delta Gcode  X:"+ d1 + " Y:"+ d2);
        if (vert==1)
          println("Ratio:" + (d2/d1));
        else
          println("Rapp:"+ (d1/d2));
        println("Total lines to draw:"+lines);
        noLoop();
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void setup_squiggles() {
  img = loadImage(sketchPath("") + pic_path);  // Load the image into the program  
  img.loadPixels();
  
  //resize the image for the screen  
  if (img.width > dim_screen || img.height > dim_screen){
   if (img.width > img.height)
     img.resize(dim_screen, img.height/img.width*dim_screen);
   else
     img.resize(img.width/img.height*dim_screen, dim_screen);
  }
   image(img,img.width,0);
  
  image_size_x = img.width;
  image_size_y = img.height;
  
  //scale drawing
  drawing_scale_x = image_size_x / img.width;
  drawing_scale_y = image_size_y / img.height;
  drawing_scale = min(drawing_scale_x, drawing_scale_y);
  
  //resize the image in the paper (vertical or horizontal and the proportion)
  float rapp_xy;
  if (image_size_x>image_size_y){
      rapp_xy=image_size_x/image_size_y;
      vert=0;
  }
  else{
      rapp_xy=image_size_y/image_size_x;
      A3=0;
      vert=1;
  }
  
  if (vert==1)
    if (rapp_xy > 1.4){
      paper_size_y=280;
      paper_size_x=200/rapp_xy*1.4;
      paper_x_offset=(200-paper_size_x)/2;
      paper_y_offset=0;
    }
    else {
      paper_size_x = 200;  
      paper_size_y= 280*rapp_xy/1.4;
      paper_x_offset=0;
      paper_y_offset=(280-paper_size_y)/2;
    }

  if(vert==0)
    if (A3==0){
      if (rapp_xy < 1.4) {
        paper_size_x = 280*rapp_xy/1.4;  
        paper_size_y= 200;
        paper_x_offset=(280-paper_size_x)/2;;
        paper_y_offset=0;
      }
      else{
        paper_size_x = 280;  
        paper_size_y = 200/rapp_xy*1.4;
        paper_x_offset=0;
        paper_y_offset=(200-paper_size_y)/2;
      }
    }   
   else { //A3==1
      if (rapp_xy < 1.17) {
        paper_size_x = 330*rapp_xy/1.17;  
        paper_size_y= 280;
        paper_x_offset=(330-paper_size_x)/2;;
        paper_y_offset=0;
      }
      else{
        paper_size_x = 330;  
        paper_size_y = 280/rapp_xy*1.17;
        paper_x_offset=0;
        paper_y_offset=(280-paper_size_y)/2;
      }
    }   
  
  
  adj_x=paper_size_x/image_size_x;
  adj_y=paper_size_y/image_size_y;
  
 
  
  println("Picture: " + pic_path);
  println("adjustbrightness: " + adjustbrightness);
  println("squiggle_total: " + squiggle_total);
  println("squiggle_length: " + squiggle_length);
  println("Paper size: " + nf(paper_size_x,0,2) + " by " + nf(paper_size_y,0,2)) ;
  println("Paper Offset: " + nf(paper_x_offset,0,2) + " by " + nf(paper_y_offset,0,2)) ;
  println("Max image size: " + nf(image_size_x,0,2) + " by " + nf(image_size_y,0,2));
  println("Calc image size " + nf(img.width * drawing_scale,0,2) + " by " + nf(img.height * drawing_scale,0,2));  
  println("adj factor:  " + nf(adj_x,0,2) + " by " + nf(adj_y,0,2)); 
  
  println("Drawing scale: " + drawing_scale);

  // Used only for gcode, not screen.
  x_offset = 0;  
  y_offset = 0;
  println("X offset: " + x_offset);  
  println("Y offset: " + y_offset);  

  println("Image dimensions: " + img.width + " by " + img.height+ "  ratio:"+rapp_xy);

  // Used only for screen, not gcode.
  //center_x = int(width  / 2 * (1 / screen_scale));
  //center_y = int(height / 2 * (1 / screen_scale) - (steps_per_inch * screen_offset));
  center_x = 0;
  center_y = 0;
  
 

}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void grid() {/*
  // This will give you a rough idea of the size of the printed image, in inches.
  // Some screen scales smaller than 1.0 will sometimes display every other line
  // It looks like a big logic bug, but it just can't display a one pixel line scaled down well.
  stroke(0);
  for (int xy = -30*steps_per_inch; xy <= 30*steps_per_inch; xy+=steps_per_inch) {
    line(xy + center_x, 0, xy + center_x, 200000);
    line(0, xy + center_y, 200000, xy + center_y);
  }

  stroke(0, 100, 100, 50);
  line(center_x, 0, center_x, 200000);
  line(0, center_y, 200000, center_y);
  */
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void dump_some_useless_stuff_and_close() {
  println ("Extreams of X: " + drawing_min_x + " thru " + drawing_max_x);
  println ("Extreams of Y: " + drawing_min_y + " thru " + drawing_max_y);
  OUTPUT.flush();
  OUTPUT.close();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////


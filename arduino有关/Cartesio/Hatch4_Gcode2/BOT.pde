///////////////////////////////////////////////////////////////////////////////////////////////////////
void pen_up() {
  String buf = "M05";
  is_pen_down = false;
  OUTPUT.println(buf);
  buf = "G4 P0.1";
  OUTPUT.println(buf);
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void pen_down() {
  String buf = "M03 S20";  // <--- change this value for your servo !!!
  is_pen_down = true;
  OUTPUT.println(buf);
  buf = "G4 P0.3";
  OUTPUT.println(buf);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
void move_abs(float x, float y) {
  String buf = "G1 X" + (x*adj_x+paper_x_offset) + " Y" + (paper_size_y-y*adj_y+paper_y_offset)+" F3000";  //<--- F is the speed of the arm. Decrease it if is too fast
  OUTPUT.println(buf);
  Glines++;
  gcodeCalc(x,y);
}



///////////////////////////////////////////////////////////////////////////////////////////////////////
void move_fast(float x, float y) {
  String buf = "G0 X" + (x*adj_x+paper_x_offset) + " Y" + (paper_size_y-y*adj_y+paper_y_offset);
  OUTPUT.println(buf);
  Glines++;
  gcodeCalc(x,y);
}



///////////////////////////////////////////////////////////////////////////////////////////////////////
void Gline(float x1, float y1, float x2, float y2) { 
  stroke(0);
  strokeWeight(1);
  
  if (dist(x1,y1,x2,y1) > 2 || cont) {

  line(x1,y1,x2,y2);

  lineCalc(x1,y1,x2,y2);
  
  pen_up();
  move_fast(x1,y1);
  pen_down();
  move_abs(x2,y2);
  liness++;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
void GlineCont(float x1, float y1, float x2, float y2) { 
  stroke(0);
  strokeWeight(1);

  line(x1,y1,x2,y2);
 
  lineCalc(x1,y1,x2,y2);

  move_abs(x2,y2);
  liness++;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void gcodeCalc(float x, float y){
  if (x*adj_x+paper_x_offset> max_gcode_x)
    max_gcode_x=x*adj_x+paper_x_offset;
  if (y*adj_y +paper_y_offset> max_gcode_y)
    max_gcode_y=y*adj_y+paper_y_offset;
    
  if (x*adj_x+paper_x_offset< min_gcode_x)
    min_gcode_x=x*adj_x+paper_x_offset;
  if (y*adj_y +paper_y_offset< min_gcode_y)
    min_gcode_y=y*adj_y+paper_y_offset;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void lineCalc(float x1, float y1, float x2, float y2){
   
 // lines dimension 
  if (x1< min_line_x)
    min_line_x=x1;
  if (x2< min_line_x)
    min_line_x=x2;
  if (x1> max_line_x)
    max_line_x=x1;
  if (x2> max_line_x)
    max_line_x=x2;
    
  if (y1< min_line_y)
    min_line_y=y1;
  if (y2< min_line_y)
    min_line_y=y2;
  if (y1> max_line_y)
    max_line_y=y1;
  if (y2> max_line_y)
    max_line_y=y2;
}

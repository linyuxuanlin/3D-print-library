///////////////////////////////////////////////////////////////////////////////////////////////////////
// No, it's not a fancy dancy class like the snot nosed kids are doing these days.
// Now get the hell off my lawn.
///////////////////////////////////////////////////////////////////////////////////////////////////////
void pen_up() {
  String buf = "M05";
    is_pen_down = false;
  OUTPUT.println(buf);
  buf = "M05";
  OUTPUT.println(buf);
  buf = "P04 0.1";
  OUTPUT.println(buf);
   buf = "F2000";
  OUTPUT.println(buf);
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void pen_down() {
  String buf = "M03 S20";
  is_pen_down = true;
  OUTPUT.println(buf);
  buf = "M03 S20";
  OUTPUT.println(buf);
  buf = "P04 0.15";
  OUTPUT.println(buf);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void move_abs(int x, int y) {
  String buf = "G1 X" + (x*adj_x+paper_x_offset) + " Y" + (paper_size_y-y*adj_y+paper_y_offset)+" F3000";
  lines++;
  if (x*adj_x+paper_x_offset> max_gcode_x)
    max_gcode_x=x*adj_x+paper_x_offset;
  if (y*adj_y +paper_y_offset> max_gcode_y)
    max_gcode_y=y*adj_y+paper_y_offset;
    
  if (x*adj_x+paper_x_offset< min_gcode_x)
    min_gcode_x=x*adj_x+paper_x_offset;
  if (y*adj_y +paper_y_offset< min_gcode_y)
    min_gcode_y=y*adj_y+paper_y_offset;
    
  
  if (x < drawing_min_x) { drawing_min_x = x; }
  if (x > drawing_max_x) { drawing_max_x = x; }
  if (y < drawing_min_y) { drawing_min_y = y; }
  if (y > drawing_max_y) { drawing_max_y = y; }
  
  if (is_pen_down) {
    stroke(0);
    line(x_old + center_x, y_old + center_y, x + center_x, y + center_y);
  }
  
  x_old = x;
  y_old = y;
  OUTPUT.println(buf);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////


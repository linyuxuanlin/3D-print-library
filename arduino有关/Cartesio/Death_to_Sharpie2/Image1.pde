///////////////////////////////////////////////////////////////////////////////////////////////////////
//  Mostly a find darkest within radius and move there, kind of thing.
///////////////////////////////////////////////////////////////////////////////////////////////////////
void random_darkness_walk() {
  int x, y;

  find_darkest();
  x = darkest_x;
  y = darkest_y;
  squiggle_count++;
  
  find_darkest_neighbor(x, y);
  move_abs(int(darkest_x*drawing_scale+x_offset), int(darkest_y*drawing_scale+y_offset));
  pen_down();
  
  for (int s = 0; s < squiggle_length; s++) {
    find_darkest_neighbor(x, y);
    lighten(adjustbrightness, darkest_x, darkest_y);
    move_abs(int(darkest_x*drawing_scale+x_offset), int(darkest_y*drawing_scale+y_offset));
    x = darkest_x;
    y = darkest_y;
  }
  pen_up();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void find_darkest_neighbor(int start_x, int start_y) {
  float darkest_neighbor = 256;
  int min_x, max_x, min_y, max_y;
  
  min_x = constrain(start_x - half_radius, half_radius, img.width  - half_radius);
  min_y = constrain(start_y - half_radius, half_radius, img.height - half_radius);
  max_x = constrain(start_x + half_radius, half_radius, img.width  - half_radius);
  max_y = constrain(start_y + half_radius, half_radius, img.height - half_radius);
  
  // One day I will test this to see if it does anything close to what I think it does.
  for (int x = min_x; x <= max_x; x++) {
    for (int y = min_y; y <= max_y; y++) {
      // Calculate the 1D location from a 2D grid
      int loc = x + y*img.width;
      float d = dist(start_x, start_y, x, y);
      if (d <= half_radius) {
        float r = red (img.pixels[loc]) + random(0, 0.01);  // random else you get ugly horizontal lines
        if (r < darkest_neighbor) {
          darkest_x = x;
          darkest_y = y;
          darkest_neighbor = r;
        }
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void find_darkest() {
  darkest_value = 256;
  for (int x = half_radius; x < img.width - half_radius; x++) {
    for (int y = half_radius; y < img.height - half_radius; y++ ) {
      // Calculate the 1D location from a 2D grid
      int loc = x + y*img.width;
      
      float r = red (img.pixels[loc]);
      if (r < darkest_value) {
        darkest_x = x;
        darkest_y = y;
        darkest_value = r;
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void lighten(int adjustbrightness, int start_x, int start_y) {
  int min_x, max_x, min_y, max_y;

  min_x = constrain(start_x - half_radius, half_radius, img.width  - half_radius);
  min_y = constrain(start_y - half_radius, half_radius, img.height - half_radius);
  max_x = constrain(start_x + half_radius, half_radius, img.width  - half_radius);
  max_y = constrain(start_y + half_radius, half_radius, img.height - half_radius);
  
  /*
  for (int x = min_x; x <= max_x; x++) {
    for (int y = min_y; y <= max_y; y++) {
      float d = dist(start_x, start_y, x, y);
      if (d <= half_radius) {
        // Calculate the 1D location from a 2D grid
        int loc = y*img.width + x;
        float r = red (img.pixels[loc]);
        r += adjustbrightness / d;
        r = constrain(r,0,255);
        color c = color(r);
        img.pixels[loc] = c;
      }
    }
  }
  */

  // Hey boys and girls its thedailywtf.com time, yeah.....
  lighten_one_pixel(adjustbrightness * 6, start_x, start_y);

  lighten_one_pixel(adjustbrightness * 2, start_x + 1, start_y    );
  lighten_one_pixel(adjustbrightness * 2, start_x - 1, start_y    );
  lighten_one_pixel(adjustbrightness * 2, start_x    , start_y + 1);
  lighten_one_pixel(adjustbrightness * 2, start_x    , start_y - 1);

  lighten_one_pixel(adjustbrightness * 1, start_x + 1, start_y + 1);
  lighten_one_pixel(adjustbrightness * 1, start_x - 1, start_y - 1);
  lighten_one_pixel(adjustbrightness * 1, start_x - 1, start_y + 1);
  lighten_one_pixel(adjustbrightness * 1, start_x + 1, start_y - 1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void lighten_one_pixel(int adjustbrightness, int x, int y) {
  int loc = (y)*img.width + x;
  float r = red (img.pixels[loc]);
  r += adjustbrightness;
  r = constrain(r,0,255);
  color c = color(r);
  img.pixels[loc] = c;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////


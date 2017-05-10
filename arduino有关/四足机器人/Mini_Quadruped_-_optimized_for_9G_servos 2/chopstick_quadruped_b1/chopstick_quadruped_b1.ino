/***************************************************/
/////////////////////////////////////////////////////
///                                               ///
///    Code for printed Mini 9G Quadruped         ///
///    http://www.thingiverse.com/thing:38159     ///
///    TheCase v.1 Dec2012                        ///
///                                               ///
///    derived from Chopstick Junior 1.0          ///
///    version 1.0.6                              ///
///    by Lutz Michaelis, November 2011           ///  
///    more about this robot and contact form:    ///
///    http://letsmakerobots.com/node/29708       ///
///    powered by                                 ///
///    http://www.roboter-selbstgebaut.com        ///
/////////////////////////////////////////////////////

#include <Servo.h>
// set the names of the servos
/*
frh = front right hip
 frl = front right leg
 flh = front left hip
 fll = front left leg
 rlh = rear left hip
 rll = rear left leg
 rrh = rear right hip
 rrl = rear right leg
 eye = sevor for sensor
 */
Servo frh;
Servo frl;
Servo flh;
Servo fll;
Servo rlh;
Servo rll;
Servo rrh;
Servo rrl;
Servo eye;

// set variables needed for some tasks

//set logical values for physical home position (cheap Chinese servos are cheap!)
int home_frh = 91;
int home_frl = 48;
int home_flh = 66;
int home_fll = 80;
int home_rlh = 93;
int home_rll = 62;
int home_rrh = 77;
int home_rrl = 90;

int b;
int x;
int w;
int up;
int up2;
int up3;
int down;
int down2;
int steps;
int rightsteps;
int leftsteps;
int back;
int pos;
int sensor = A0;
int distance = 0;

unsigned long echo = 0;
int ultraSoundPulse = 13;
int ultraSoundEcho = 3; // Ultrasound signal pin
unsigned long ultrasoundValue = 0;

const int buttonPin = 2;     
int buttonState = 0;

//////////////////////////////////////
void setup()
{
  pinMode(13, OUTPUT);  // LED pin
  pinMode(buttonPin, INPUT);   
  // assign servos to pins and center servos
  frh.attach(5);
  frh.write(home_frh);
  frl.attach(6);
  frl.write(home_frl);
  flh.attach(7);
  flh.write(home_flh);
  fll.attach(8);
  fll.write(home_fll);
  rlh.attach(9);
  rlh.write(home_rlh);
  rll.attach(10);
  rll.write(home_rll);
  rrh.attach(11);
  rrh.write(home_rrh);
  rrl.attach(12);
  rrl.write(home_rrl);
  //
  //eyes
  Serial.begin(9600);
  pinMode(ultraSoundPulse,OUTPUT);
  pinMode(ultraSoundEcho,INPUT);
}
//////////////////////////////////////
void idle() // this is the delay between the steps -> walking speed
{
  delay(100);  // if set to a bigger number (more delay between the steps -> slower walking) you will see the walking pattern more clearly
}
////////////////////////////////////// 
void test() /* just for debugging -> if need a delay between the subroutines 
 you can let the LED blink as an indicator that something is still running  */
{
  for(b = 0; b < 3; b++) // this let the LED blink 5 times 
  {
    digitalWrite(13, HIGH);   // turn the LED on
    delay(300);               // wait for .5 second
    digitalWrite(13, LOW);    // turn the LED off
    delay(300);
  }  
}
//////////////////////////////////////
void flatout()
{
  frh.write(home_frh);
  frl.write(home_frl);
  flh.write(home_flh);
  fll.write(home_fll);
  rlh.write(home_rlh);
  rll.write(home_rll);
  rrh.write(home_rrh);
  rrl.write(home_rrl);
}
void standup()
{
  up2 = 0;
  up3 = 0;
  frh.write(home_frh-20);
  flh.write(home_flh-10);
  rlh.write(home_rlh+30);
  rrh.write(home_rrh-20);
  for(up = 0; up < 80; up++)
  {
    frl.write(up+home_frl);
    up2 = up2 - 1;
    fll.write(up2+home_fll);
    delay(20);
  }

  for(up = 0; up < 90; up++)
  {
    rll.write(up+home_rll);
    up3 = up3 - 1;
    rrl.write(up3+home_rrl);
    delay(15);
  }
}
//////////////////////////////////////
void sleep()
{
  // hips
  frh.write(home_frh-20);
  flh.write(home_flh);
  rlh.write(home_rlh-20);
  rrh.write(home_rrh);
  // legs
  frl.write(home_frl-90);
  fll.write(home_fll+90);
  rll.write(home_rll-90);
  rrl.write(home_rrl+90);
}
//////////////////////////////////////
void stand()
{
  frh.write(home_frh-20);
  frl.write(home_frl+80);
  delay(20);
  flh.write(home_flh-10);
  fll.write(home_fll-70);
  delay(20);
  rlh.write(home_rlh-10);
  rll.write(home_rll+80);
  delay(20);
  rrh.write(home_rrh-20);
  rrl.write(home_rrl-70); 
  delay(20);
}
//////////////////////////////////////
void forward()
{
  // lift front right leg, move front right hip forward and rear right hip backward, lower front right leg
  rll.write(home_rll+50);  // lower the diagonal opposite leg a bit to keep the balance
  frl.write(home_frl+30);  //orig 140
  idle();
  frh.write(home_frh-45);
  rrh.write(home_rrh+60); // orig 90
  idle();
  frl.write(home_frl+80);  //orig 170
  rll.write(home_rll+60);  //orig 170  //put the diagonal opposite leg down to keep the balance
  // lift rear left leg, move rear left hip forward and front right hip backward, lower rear left leg 
  frl.write(home_frl+80);  //orig 140 //lower the diagonal opposite leg a bit to keep the balance
  rll.write(home_rll+50); 
  idle();
  rlh.write(home_rlh+30); //orig 120
  frh.write(home_frh+20);
  idle();
  rll.write(home_rll+60);  // orig 170
  fll.write(home_fll+80);  // put the diagonal opposite leg down to keep the balance
  // lift front left leg, move front left hip forward and rear left hip backward, lower front left leg
  rrl.write(home_rrl-20);  // orig 50  //lower the diagonal opposite leg a bit to keep the balance
  fll.write(home_fll-40);
  idle();
  flh.write(home_flh+60); //orig 110
  rlh.write(home_rlh-50);//orig 60
  idle();
  fll.write(home_fll-70);
  rrl.write(home_rrl-70);  // put the diagonal opposite leg down to keep the balance
  // lift rear right leg, move rear right hip forward and front left hip backward, lower rear right leg 
  fll.write(home_fll-40);  // lower the diagonal opposite leg a bit to keep the balance 
  rrl.write(home_rrl-40); 
  idle();
  rrh.write(home_rrh-20); //orig 30
  flh.write(home_flh); //orig 50
  idle();
  rrl.write(home_rrl-50); //orig 20
  fll.write(home_fll-70);  // orig 20 //put the diagonal opposite leg down to keep the balance
  idle();
}
/////////////////////////////////////
void rightturn()
{
  // lift front right leg, move front right hip forward and rear right hip backward, lower front right leg
  frl.write(home_frl+60);
  idle();
  frh.write(home_frh-60);
  rrh.write(home_rrh);
  idle();
  frl.write(home_frl+80);
  // lift rear left leg, move rear left hip forward and front right hip backward, lower rear left leg 
  rll.write(home_rll+60); 
  idle();
  rlh.write(home_rlh+40);
  frh.write(home_frh+10);
  idle();
  rll.write(home_rll+80);
  // lift front left leg, move front left hip forward and rear left hip backward, lower front left leg
  fll.write(home_fll-50);
  idle();
  flh.write(home_flh+40);
  rlh.write(home_rlh-40);
  idle();
  fll.write(home_fll-70);
  // lift rear right leg, move rear right hip forward and front left hip backward, lower rear right leg  
  rrl.write(home_rrl-30); 
  idle();
  rrh.write(home_rrh-20);
  flh.write(home_flh-40);
  idle();
  rrl.write(home_rrl-70);
  idle();
}
/////////////////////////////////////
void leftturn()
{
  // lift front right leg, move front right hip forward and rear right hip backward, lower front right leg
  frl.write(home_frl+60);
  idle();
  frh.write(home_frh-60);
  rrh.write(home_rrh+10);
  idle();
  frl.write(home_frl+80);
  // lift rear left leg, move rear left hip forward and front right hip backward, lower rear left leg 
  rll.write(home_rll+60); 
  idle();
  rlh.write(home_rlh);
  frh.write(home_frh+30);
  idle();
  rll.write(home_rll+80);
  // lift front left leg, move front left hip forward and rear left hip backward, lower front left leg
  fll.write(home_fll-30);
  idle();
  flh.write(home_flh);
  rlh.write(home_rlh-30);
  idle();
  fll.write(home_fll-70);
  // lift rear right leg, move rear right hip forward and front left hip backward, lower rear right leg  
  rrl.write(home_rrl-30); 
  idle();
  rrh.write(home_rrh-60);
  flh.write(home_flh-10);
  idle();
  rrl.write(home_rrl-70);
  idle();
}
/////////////////////////////////////
void backward()
{
  // lift front right leg, move front right hip backward and rear right hip forward, lower front right leg
  frl.write(home_frl+60);
  idle();
  frh.write(home_frh+10);
  rrh.write(home_rrh-40);
  idle();
  frl.write(home_frl+80);
  // lift rear left leg, move rear left hip backward and front right hip forward, lower rear left leg 
  rll.write(home_rll+40); 
  idle();
  rlh.write(home_rlh-30);
  frh.write(home_frh-45);
  idle();
  rll.write(home_rll+80);
  // lift front left leg, move front left hip backward and rear left hip forward, lower front left leg
  fll.write(home_fll-50);
  idle();
  flh.write(home_flh-20);
  rlh.write(home_rlh+30);
  idle();
  fll.write(home_fll-70);
  // lift rear right leg, move rear right hip backward and front left hip forward, lower rear right leg  
  rrl.write(home_rrl-30); 
  idle();
  rrh.write(home_rrh+20);
  flh.write(home_flh+20);
  idle();
  rrl.write(home_rrl-70);
  idle();
}
/////////////////////////////////////
void laydown() // lay down
{
  frh.write(home_frh-20);
  flh.write(home_flh-10); 
  for (down = 80; down > 0; down = down - 1){
    frl.write(home_frl+down);
    down2 = 100 - down;
    fll.write(home_fll+down2);
    delay(15);
  } 
  delay(1000);
  rlh.write(home_rlh-10);
  rrh.write(home_rrh-20);
  for (down = 80; down > 0; down = down - 1){
    rll.write(home_rll+down);
    down2 = 100 - down;
    rrl.write(home_rrl+down2);
    delay(15);
  }
}
/////////////////////////////////////
void gym() // ok, this is not very serious but I needed to cheer me up a bit ;-) just see...
{
  int y;
  frh.write(home_frh-20);
  rll.write(home_rll+40);
  delay(200);
  fll.write(home_fll-50);
  flh.write(home_flh+20);
  fll.write(home_fll-70);
  delay(20);
  frl.write(home_frl-30);
  delay(20);
  rlh.write(home_rlh+30);
  delay(20);
  rrh.write(home_rrh-20);
  rrl.write(home_rrl-70); 
  delay(20);   
}
/////////////////////////////////////
void wink()
{
  for (b = 0; b < 3; b++){
    for (w = -30; w < -70; w = w -1)
    {
      frl.write(home_frl+w);
      delay(10);
    }
    for (w = -70; w < -30; w++)
    {
      frl.write(home_frl+w);
      delay(10);
    }
    delay(200);
  }
}
/////////////////////////////////////
void sweep()
{  
  for(pos = 20; pos < 160; pos += 1)   // goes from 0 degrees to 180 degrees 
  {                                    // in steps of 1 degree 
    eye.write(pos);                    // tell servo to go to position in variable 'pos' 
    delay(10);                         // waits 15ms for the servo to reach the position 
    distance = analogRead(sensor);
    //Serial.print(distance);
    //Serial.print(" - Position ");
    //Serial.print(pos);
    //Serial.println();
  } 
  for(pos = 160; pos >= 20; pos -= 1)      // goes from 180 degrees to 0 degrees 
  {                                
    eye.write(pos);                    // tell servo to go to position in variable 'pos' 
    delay(10);                         // waits 15ms for the servo to reach the position 
    distance = analogRead(sensor);
    //Serial.print(distance);
    //Serial.print(" - Position ");
    //Serial.print(pos);  
    //Serial.println();
  }       
}

unsigned long ping(){
  // Switch signalpin to output
  digitalWrite(ultraSoundPulse, LOW); // Send low pulse
  delayMicroseconds(2); // Wait for 2 microseconds
  digitalWrite(ultraSoundPulse, HIGH); // Send high pulse
  delayMicroseconds(5); // Wait for 5 microseconds
  digitalWrite(ultraSoundPulse, LOW); // Holdoff
  // Switch signalpin to input
  digitalWrite(ultraSoundPulse, HIGH); // Turn on pullup resistor
  echo = pulseIn(ultraSoundEcho, HIGH); //Listen for echo
  ultrasoundValue = (echo / 58.138) * .39; //convert to CM then to inches
  return ultrasoundValue;
}
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
void loop()
{
  //distance = analogRead(sensor);
  buttonState = digitalRead(buttonPin);
  distance = ping();
  Serial.println(distance);
  
  if (distance > 5)  // oh, there is an obstacle in my path but no need to panic it's still not in the danger zone, just steer to the left to avoid a crash
   {
   test();
   while(back < 5){        // just a loop for 5 steps backwards since he run into an obstacle
   backward();
   back++;
   }
   test();
   while(leftsteps < 5){        // just a loop for 5 steps left turn since he run into an obstacle
   leftturn();
   leftsteps++;
   }
   if (back == 5 && leftsteps == 5)
   {
   if (distance > 5)  // oh, there is an obstacle in my path but no need to panic it's still not in the danger zone, just steer to the left to avoid a crash
   {   
   stand();
   delay(1000);
   gym();
   delay(1000);
   wink();
   delay(3000);
   laydown();
   delay(3000);
   standup();
   while(back < 10){        // just a loop for 5 steps backwards since he run into an obstacle
   backward();
   back++;
   }
   back = 0;
   leftsteps = 0;
   }
   test();
   }
   }
   else
   {
   forward(); 
   }
   


/* debug area 
  if  (buttonState == HIGH){
    flatout();
  //}else if (distance > 2){
    //backward();
   // flatout();
  }else{ 
    forward();
  }
*/
}


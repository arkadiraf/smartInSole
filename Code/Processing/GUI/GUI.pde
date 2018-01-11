import processing.opengl.*;
import saito.objloader.*;
import g4p_controls.*;
import processing.serial.*;

//Sliders definition

GCustomSlider sdrYaw, sdrPitch, sdrRoll, sdrOpac;
GLabel lblYaw, lblPitch, lblRoll, lblOpac;

// Base values

String[] IMU_parse;
float[] sensors_parse;
float roll  = 0.0F;
float pitch = 0.0F;
float yaw   = 0.0F;
int opac = 255;
color textc=#0577B0;
color bg = #EBEBEC; 
OBJModel rightShoe;

//Serial

Serial myPort;  // The serial port
int lf = 10;
String inString = "calibrating" ;

void setup(){    
  size(800, 600, OPENGL);
  rightShoe = new OBJModel(this);
  rightShoe.load("shoe.obj");
  rightShoe.scale(2);
  background(bg);
  //sdr( 350, 400 );  // Draw sliders
  
  // List all the available serial ports:
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[2], 115200);
  myPort.bufferUntil(lf); 
}

void draw() {
  drawFrame();
  //drawCircle(500, 200, 200, textc, opac);
  //drawCircleR(800, 200, 200, textc, opac);  
  //drawCircleHSB(200, 200, 200, opac);
  drawShoe(rightShoe, width/2, height/2, roll, pitch, yaw);
  }


void serialEvent(Serial myPort) {
  inString = myPort.readString();
  IMU_parse = split(inString,':');
  if(IMU_parse[0].equals("IMU")){
    println(IMU_parse[1]);
    sensors_parse = float(split(IMU_parse[1], ',')); 
    yaw = sensors_parse[1];
    pitch = sensors_parse[2];
    roll = sensors_parse[3];
  }
  else {
  println("NOT IMU");
  }
}


// Handle sliders envents: Yaw, Pitch, Roll, Opacity

void handleSliderEvents(GValueControl slider, GEvent event) {
   if (slider == sdrYaw) {yaw = slider.getValueF();}
   else if (slider == sdrPitch) {pitch = slider.getValueF();} 
   else if (slider == sdrRoll) {roll = slider.getValueF();}
   else if (slider == sdrOpac) {opac = slider.getValueI();}

}  

// Draw sliders bulk
// Inputs: Upper left corner X,Y location

void sdr(float xs,float ys) {
  sdrYaw = new GCustomSlider(this, xs, ys, 400, 40, "metallic");
  sdrYaw.setLimits(0.0f, -180.0f, 180.0f);
  sdrYaw.setShowValue(true);
  sdrYaw.setShowLimits(true);
  sdrYaw.setNbrTicks(360);
  lblYaw = new GLabel(this, xs-30, ys, 80, 40, "Yaw");
  lblYaw.setTextAlign(GAlign.LEFT, null);
  
  sdrPitch = new GCustomSlider(this, xs, ys+50, 400, 40, "metallic");
  sdrPitch.setLimits(0.0f, -180.0f, 180.0f);
  sdrPitch.setShowValue(true);
  sdrPitch.setShowLimits(true);
  sdrPitch.setNbrTicks(360);
  lblPitch = new GLabel(this, xs-30, ys+50, 80, 40, "Pitch");
  lblPitch.setTextAlign(GAlign.LEFT, null);
  
  sdrRoll = new GCustomSlider(this, xs, ys+100, 400, 40, "metallic");
  sdrRoll.setLimits(0.0f, -180.0f, 180.0f);
  sdrRoll.setShowValue(true);
  sdrRoll.setShowLimits(true);
  sdrRoll.setNbrTicks(360);
  lblRoll = new GLabel(this, xs-30, ys+100, 80, 40, "Roll");
  lblRoll.setTextAlign(GAlign.LEFT, null);   
  
  sdrOpac = new GCustomSlider(this, xs, ys+150, 400, 40, "metallic");
  sdrOpac.setLimits(255, 0, 255);
  sdrOpac.setShowValue(true);
  sdrOpac.setShowLimits(true);
  sdrOpac.setNbrTicks(360);
  lblOpac = new GLabel(this, xs-45, ys+150, 80, 40, "Opacity");
  lblOpac.setTextAlign(GAlign.LEFT, null);
}

// Draw circle with opacity cahnge
// Inputs: X,Y Center location, Radius, fill color, Opacity

void drawCircle( int xc, int yc, int r, color fill, int opacity) {
   fill(fill, opacity);
   stroke(textc, 255);
   ellipse(xc, yc, r, r);
   fill(0);
   textAlign(CENTER, CENTER);
   textSize(r/4);
   text(opacity*100/255 + "%", xc, yc-r/25);   
} 

// Draw circle HSB scale
// Inputs: X,Y Center location, Radius, color 

void drawCircleHSB( int xc, int yc, int r, int opacity) {
   colorMode(HSB, 800, 100, 100);
   fill(255-opacity, 100, 100);
   colorMode(RGB, 255, 255, 255);
   stroke(0, 255);   
   ellipse(xc, yc, r, r);
   fill(255);
   textAlign(CENTER, CENTER);
   textSize(r/4);
   text(opacity*100/255 + "%", xc, yc-r/25);   
}  

// Draw circle with opacity cahnge
// Inputs: X,Y Center location, Radius, fill color, Opacity

void drawCircleR( int xc, int yc, int r, color fill, int opacity) {
   fill(fill, 255);
   stroke(0, 255);
   ellipse(xc, yc, r-(255-opacity)*100/255, r-(255-opacity)*100/255);
   fill(0);
   textAlign(CENTER, CENTER);
   textSize(r/6);
   text(opacity*100/255 + "%", xc, yc-r/25);   
} 

void drawFrame(){ 
  background(bg);
  String headline = "With smartINSOLE, ***very cool slogan***";
  stroke(textc);
  strokeWeight(2);
  noFill();
  rectMode(CENTER);
  rect(width/2,height/2,width-20,height-20, 30); // Drawing the rectangle
  textAlign(LEFT, TOP);
  textSize(50);
  fill(textc);
  text("smartINSOLE", 25, 15); 
  fill(0, 50);
  text("smartINSOLE", 29, 19);
  fill(0, 120);
  rectMode(CORNERS);
  textAlign(LEFT, TOP);
  textSize(20);
  textLeading(22);
  text(headline, 350, 24, 790, 75);
}

void drawShoe(OBJModel model, float xc, float yc, float rolls, float pitchs, float yaws) {
    pushMatrix();
    pointLight(200, 200, 200,  xc+200, yc+200,  200);
    pointLight(200, 200, 255, xc-200, yc+200,  200);
    pointLight(255, 255, 255,    xc,   yc, -200);
    rectMode(CENTER);
    translate(xc, yc);
    float c1 = cos(radians(rolls));
    float s1 = sin(radians(rolls));
    float c2 = cos(radians(pitchs));
    float s2 = sin(radians(pitchs));
    float c3 = cos(radians(yaws));
    float s3 = sin(radians(yaws));
/*    
    applyMatrix(c1*c2, c1*s2*s3-s1*c3, c1*s2*c3+s1*s3, 0,
                s1*c2, s1*s2*s3+c1*c3, s1*s2*c3-c1*s3, 0,
                -s2  , c2*s3         , c2*c3         , 0,
                0    , 0             , 0             , 1);
*/
          
    applyMatrix( c2*c3, s1*s3+c1*c3*s2, c3*s1*s2-c1*s3, 0,
               -s2, c1*c2, c2*s1, 0,
               c2*s3, c1*s2*s3-c3*s1, c1*c3+s1*s2*s3, 0,
               0, 0, 0, 1);               

    pushMatrix();
    noStroke();
    model.draw();
    popMatrix();
    popMatrix();
}
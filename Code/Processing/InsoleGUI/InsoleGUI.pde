import processing.opengl.*;
import saito.objloader.*;
import g4p_controls.*;
import processing.serial.*;

//Sliders definition

GCustomSlider sdrYaw, sdrPitch, sdrRoll, sdrOpac;
GLabel lblYaw, lblPitch, lblRoll, lblOpac;
GButton btnResetr, btnResetl;

// Base values

String[] IMU_parse;
float[] sensors1_parse;
float[] sensors2_parse;
float roll2  = 0.0F;
float pitch2 = 0.0F;
float yaw2   = 0.0F;
float roll1  = 0.0F;
float pitch1 = 0.0F;
float yaw1   = 0.0F;
int opac = 255;
color textc=#0577B0;
color bg = #EBEBEC; 
OBJModel rightSole, leftSole;
PImage logo, rightfoot, leftfoot;

float r_pressure_4  = 0.0F;
float r_pressure_5  = 0.0F;
float r_pressure_6  = 0.0F;
float r_pressure_7  = 0.0F;
float l_pressure_4  = 0.0F;
float l_pressure_5  = 0.0F;
float l_pressure_6  = 0.0F;
float l_pressure_7  = 0.0F;

//Serial

Serial myPort;  // The serial port
int lf = 10;
String inString = "calibrating" ;


void setup(){    
  size(1200, 600, OPENGL);
  rightSole = new OBJModel(this);
  rightSole.load("rightsole.obj");
  rightSole.scale(1.3);
  leftSole = new OBJModel(this);
  leftSole.load("leftsole.obj");
  leftSole.scale(1.3);  
  
  background(bg);
  //sdr( 350, 400 );  // Draw sliders
  logo = loadImage("logo.jpg");
  rightfoot = loadImage("rightfoot.jpg");
  leftfoot = loadImage("leftfoot.jpg");
  drawResetr(width-170, 30, 150, 30);
  drawResetl(width-330, 30, 150, 30);
  
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
  drawLeftFoot(17, 160, 164, 392);
  drawRightFoot(1020, 160, 164, 392);
  drawShoe(rightSole, width*0.65, height/2+50, roll2, pitch2, yaw2);
  drawShoe(leftSole, width*0.35, height/2+50, roll1, pitch1, yaw1);
  }

void drawResetr(int x, int y, int w, int h) {
  btnResetr = new GButton(this, x, y, w, h);
  btnResetr.setText("Reset right Orientation");
  btnResetr.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  //btnVisible.addEventHandler(this, "btnResetClick");   
}

void drawResetl(int x, int y, int w, int h) {
  btnResetl = new GButton(this, x, y, w, h);
  btnResetl.setText("Reset Left Orientation");
  btnResetl.setLocalColorScheme(GCScheme.BLUE_SCHEME);
  //btnVisible.addEventHandler(this, "btnResetClick");   
}

void serialEvent(Serial myPort) {
  inString = myPort.readString();
  IMU_parse = split(inString,':');
  println(IMU_parse[1]);
  if(IMU_parse[0].equals("IMU2")){  //right leg
    //println(IMU2_parse[1]);
    sensors2_parse = float(split(IMU_parse[1], ',')); 
    yaw2 = -sensors2_parse[1];
    pitch2 = sensors2_parse[2];
    roll2 = -sensors2_parse[3];
    r_pressure_4 = sensors2_parse[4];
    r_pressure_5 = sensors2_parse[5];
    r_pressure_6 = sensors2_parse[6];
    r_pressure_7 = sensors2_parse[7];
    
  }
  else if(IMU_parse[0].equals("IMU1")){
    println(IMU_parse[0]);
    sensors1_parse = float(split(IMU_parse[1], ',')); 
    yaw1 = -sensors1_parse[1];
    pitch1 = sensors1_parse[2];
    roll1 = -sensors1_parse[3];
    l_pressure_4 = sensors1_parse[4];
    l_pressure_5 = sensors1_parse[5];
    l_pressure_6 = sensors1_parse[6];
    l_pressure_7 = sensors1_parse[7];
  }
}


// Handle sliders envents: Yaw, Pitch, Roll, Opacity

void handleSliderEvents(GValueControl slider, GEvent event) {
   if (slider == sdrYaw) {yaw2 = slider.getValueF();}
   else if (slider == sdrPitch) {pitch2 = slider.getValueF();} 
   else if (slider == sdrRoll) {roll2 = slider.getValueF();}
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

void drawCircle( int xc, int yc, int r, color fill, float force) {
   int f;
   if(force<101) {
     fill(fill, 0);
     f = 0;
   }
   else if(force>10000){
     fill(fill, 255);
     f = 100;
   }
   else{
     fill(fill, force*255/10000);
     f = int(force*100/10000);
   }
   //stroke(textc, 255);
   noStroke();
   ellipse(xc, yc, r, r);
   fill(0);
   textAlign(CENTER, CENTER);
   textSize(r/2);
   text(f, xc, yc-r/25);   
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
   textSize(r/2);
   text(opacity*100/255, xc, yc-r/25);   
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
  String headline = "With smartWALK, ***very cool slogan***";
  stroke(textc);
  strokeWeight(2);
  noFill();
  rectMode(CENTER);
  rect(width/2,height/2,width-20,height-20, 30); // Drawing the rectangle
  image(logo, 17, 17, 80, 80);
  textAlign(LEFT, TOP);
  textSize(80);
  fill(textc);
  text("smartWALK", 115, 15); 
  fill(0, 50);
  text("smartWALK", 119, 19);
  
  //Slogan text
  //fill(0, 120);
  //rectMode(CORNERS);
  //textAlign(LEFT, TOP);
  //textSize(20);
  //textLeading(22);
  //text(headline, 350, 24, 790, 75);
   
}

void drawLeftFoot(int w, int h, int sw, int sh){
  image(leftfoot, w, h, sw, sh);
  drawCircle(w+52, h+115, 45, #FF0000, l_pressure_6);
  drawCircle(w+110, h+140, 45, #FF0000, l_pressure_4);
  drawCircle(w+100, h+225, 45, #FF0000, l_pressure_7);
  drawCircle(w+75, h+333, 45, #FF0000, l_pressure_5);  
}

void drawRightFoot(int w, int h, int sw, int sh){
  image(rightfoot, w, h, sw, sh);
  drawCircle(w+52, h+140, 45, #FF0000, r_pressure_6);
  drawCircle(w+110, h+115, 45, #FF0000, r_pressure_4);
  drawCircle(w+63, h+225, 45, #FF0000, r_pressure_7);
  drawCircle(w+90, h+333, 45, #FF0000, r_pressure_5);
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

void handleButtonEvents(GButton button, GEvent event) {
  if (button == btnResetr && event == GEvent.CLICKED) {
    println("resetr");
  }// if
  else if (button == btnResetl && event == GEvent.CLICKED) {
    println("resetl");
  }// if
}
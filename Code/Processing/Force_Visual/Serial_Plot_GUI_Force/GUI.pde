//////////////////////////
// GUI global variables //
//////////////////////////

// backround color
color win_bg_color=color(127, 127, 127);

// button colors:
color b_reset_color=color(255, 255, 125);
color b_open_color=color(255, 255, 125);

color b_start_color_on=color(0, 255, 0);
color b_start_color_off=color(255, 0, 0);
//color b_serial_color_on=color(0, 255, 0);
//color b_serial_color_off=color(255, 0, 0);

// fonts
int gui_font_size = 16; // not implemented for all text sizes
float gui_font_scalar = 1;

///////////////
// Setup GUI //
///////////////
void setup_GUI() {
  // interface parameters
  gui_font_scalar = 0.25+min((float)height/(float)displayHeight, (float)width/(float)displayWidth);
  button_height=50;
  button_width=int(width*.15); // <=0.2

  slide_height=50;
  slide_width=width/3;

  chart_width=width;
  chart_height=(height-button_height-slide_height)/number_of_charts;

  graph_off_x=50;
  graph_off_w=150;
  graph_off_y=0.05;
  ////////////////
  //Init objects//
  ////////////////
  // init cp5 main object
  cp5 = new ControlP5(this);

  // add drop down
  serialPortsList_1 = cp5.addScrollableList("serial_data")
    .setPosition(0, 0)
    .setSize(button_width, button_height*2)
    .setBarHeight(button_height/2)
    .setItemHeight(button_height/2)
    .addItems(Serial.list())
    .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
    .setFont(createFont("arial", 14*gui_font_scalar))
    ; 

  //serialPortsList_2 = cp5.addScrollableList("serial_TTL")
  //  .setPosition(button_width, 0)
  //  .setSize(button_width, button_height*2)
  //  .setBarHeight(button_height/2)
  //  .setItemHeight(button_height/2)
  //  .addItems(Serial.list())
  //  .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
  //  .setFont(createFont("arial", 14*gui_font_scalar))
  //  ; 

  ///////////////////////
  // init chart object //
  ///////////////////////
  chart_array = new Chart_Frame[number_of_charts];

  for (int ii=0; ii<chart_array.length; ii++) {
    chart_array[ii]=new Chart_Frame(0, button_height+ii*chart_height, chart_width, chart_height, ii, glob_datapoints, data_min_range[ii], data_max_range[ii], graph_off_x, graph_off_y, graph_off_w);
  }

  /////////////
  // Sliders //
  /////////////
  cp5.addSlider("slider_zoom")
    .setBroadcast(false)
    .setPosition(0, height-slide_height+slide_height/4)
    .setSize(slide_width, slide_height/2)
    .setRange(glob_datapoints/10, glob_datapoints)
    .setValue(glob_datapoints)
    .setSliderMode(Slider.FLEXIBLE)
    .setFont(createFont("arial", 20*gui_font_scalar))
    .setColorBackground(color(0, 125, 125))
    .setColorCaptionLabel(color(0)) 
    .setColorValueLabel(color(0))
    .setCaptionLabel("Zoom")
    .setBroadcast(true)
    ;
  cp5.getController("slider_zoom").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(0);

  cp5.addSlider("slider_timeline")
    .setBroadcast(false)
    .setPosition(width-slide_width, height-slide_height+slide_height/4)
    .setSize(slide_width, slide_height/2)
    .setRange(0.0, 1.0)
    .setValue(0)
    .setSliderMode(Slider.FLEXIBLE)
    .setFont(createFont("arial", 20*gui_font_scalar))
    .setColorBackground(color(0, 125, 125))
    .setColorCaptionLabel(color(0)) 
    .setColorValueLabel(color(0))
    .setCaptionLabel("TimeLine")
    .setBroadcast(true)
    ;  

  cp5.getController("slider_timeline").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(0);

  //////////////////
  // add buttons: //
  //////////////////
  cp5.addButton("b_start")
    .setBroadcast(false)
    .setValue(0)
    .setPosition(width/2-button_width/2, 0)
    .setSize(button_width, button_height)
    .setFont(createFont("arial", 20*gui_font_scalar))
    .setColorBackground(b_start_color_on)
    .setColorLabel(color(0)) 
    .setLabel("Start Record")
    .setBroadcast(true)
    ;

  //cp5.addButton("b_serial")
  //  .setBroadcast(false)
  //  .setValue(0)
  //  .setPosition(button_width*2, 0)
  //  .setSize(button_width/2, button_height)
  //  .setFont(createFont("arial", 20*gui_font_scalar))
  //  .setColorBackground(b_serial_color_off)
  //  .setColorLabel(color(0)) 
  //  .setLabel("Connect")
  //  .setBroadcast(true)
  //  ;  

  cp5.addButton("b_open")
    .setBroadcast(false)
    .setValue(0)
    .setPosition(width-button_width, 0)
    .setSize(button_width, button_height)
    .setFont(createFont("arial", 20*gui_font_scalar))
    .setColorBackground(b_open_color)
    .setColorLabel(color(0)) 
    .setLabel("Open")
    .setBroadcast(true)
    ;  

  cp5.addButton("b_reset")
    .setBroadcast(false)
    .setValue(0)
    .setPosition(width/2-button_width/2, height-slide_height)
    .setSize(button_width, slide_height)
    .setFont(createFont("arial", 20*gui_font_scalar))
    .setColorBackground(b_reset_color)
    .setColorLabel(color(0)) 
    .setLabel("Reset")
    .setBroadcast(true)
    ;  

  //////////////
  // add text //
  //////////////
  // File lable
  file_label = cp5.addTextlabel("file_label")
    .setText("File: data stream")
    .setPosition(width/2+button_width/2+5, 0)
    .setColorValue(0)
    .setFont(createFont("arial", 24*gui_font_scalar))
    ;

  //serial port label // look for backround setting
  serial_port_label = cp5.addTextlabel("serial_port_label")
    //.setText("Select Serial Port")
    .setText(" Select Serial Port ")
    .setPosition(button_width, 0)
    .setColorValue(0)
    .setFont(createFont("arial", 16*gui_font_scalar))
    ;
}

//////////////
// draw GUI //
//////////////
void draw_GUI() {
  for (int i=0; i<chart_array.length; i++) {
    chart_array[i].display();
  }
}

////////////////
// cp5 events //
////////////////

///////////////////
// button events //
///////////////////
public void b_start(int theValue) {
  b_start_state=!b_start_state;
  if (b_start_state) {
    cp5.getController("b_start").setColorBackground(b_start_color_off);
  } else {
    cp5.getController("b_start").setColorBackground(b_start_color_on);
  }
  // change text
  if (b_start_state) {
    // reset the chart's datapoints()
    LIVE_MODE=true; // set live mode
    for (int jj=0; jj< chart_array.length; jj++) {
      chart_array[jj].clear_chart_data();
    }
    //update the graphs()
    slider_zoom(int(cp5.getController("slider_zoom").getValue()));
    Start_Record();
    cp5.getController("b_start").setLabel("Stop Record");
  } else {
    Stop_Record();
    cp5.getController("b_start").setLabel("Start Record");
  }
  if (DEBUG_MODE) {
    println("b_start", b_start_state, theValue);
  }
}

//public void b_serial() {
//  cp5.getController("b_serial").setColorBackground(b_serial_color_on);
//  setup_Serial();
//}


public void b_reset() {
  for (int ii=0; ii<chart_array.length; ii++) {
    cp5.getController("slider_scale"+ii).setValue(0);
    cp5.getController("slider_offset"+ii).setValue(0);
  }
}

public void b_open() {
   if (b_start_state) b_start(0);
  selectInput("Select a file to process:", "input_file_selected");
}

///////////////////
// slider events //
///////////////////
//zoom slider
public void slider_zoom(int theValue) {
  if (DEBUG_MODE) {
    println("slider_zoom "+theValue);
  }
  float[] temparray= new float[theValue];
  for (int jj=0; jj< chart_array.length; jj++) {
    int j=chart_array[jj].chart_data.length;
    for (int i = temparray.length; i > 0; i--) {
      temparray[i-1]=chart_array[jj].chart_data[j-1];
      j--;
    }
    chart_array[jj].myChart.setData("incoming", temparray);
  }
}

// timeline slider
public void slider_timeline() {
  // if we are in !live()
  if (LIVE_MODE == false && input_file_status == true) {
    // than reload the file with new settings()
    load_file_data();
  }
}

//////////////////////
// drop down event: //
//////////////////////
// Serial dropdown event
void serial_data(int n) {
  /* request the selected item based on index n */
  serial_port_open(n, 0);// port num - the serial port to define ,  port_def the defined serial port
  // check if both ports defined, than update button through serial setup function:
  // if ((myPorts[0]!=null)&&(myPorts[1]!=null)) cp5.getController("b_serial").setColorBackground(b_serial_color_on);
}

// not used currently, requires some fixes to work with 1 or 2 serial ports in parallele
//// Serial dropdown event
//void serial_TTL(int n) {
//  /* request the selected item based on index n */
//  serial_port_open(n, 1);// port num - the serial port to define ,  port_def the defined serial port
//  // check if both ports defined, than update button through serial setup function:
//  if ((myPorts[0]!=null)&&(myPorts[1]!=null))  cp5.getController("b_serial").setColorBackground(b_serial_color_on);
//}


////////////////
// resize gui //
////////////////
void resize_GUI() {
  // interface parameters
  button_width=int(width*.15); // <=0.2
  slide_width=width/3;
  chart_width=width;
  chart_height=(height-button_height-slide_height)/number_of_charts;

  file_label.setFont(createFont("arial", 24*gui_font_scalar));

  //////////////////
  //resize objects//
  //////////////////
  // resize drop down
  serialPortsList_1.setPosition(0, 0);
  serialPortsList_1.setSize(button_width, button_height*2);
  serialPortsList_1.setBarHeight(button_height/2);
  serialPortsList_1.setItemHeight(button_height/2);
  serialPortsList_1.setFont(createFont("arial", 14*gui_font_scalar));

  //serialPortsList_2.setPosition(button_width, 0);
  //serialPortsList_2.setSize(button_width, button_height*2);
  //serialPortsList_2.setBarHeight(button_height/2);
  //serialPortsList_2.setItemHeight(button_height/2);
  //serialPortsList_2.setFont(createFont("arial", 14*gui_font_scalar));


  /////////////////////////
  // resize chart object //
  /////////////////////////
  //chart_array[ii]=new Chart_Frame(0, button_height+ii*chart_height, chart_width, chart_height, ii, glob_datapoints, data_min_range[ii], data_max_range[ii], graph_off_x, graph_off_y);
  for (int ii=0; ii<chart_array.length; ii++) {
    chart_array[ii].Chart_Resize(0, button_height+ii*chart_height, chart_width, chart_height, ii);
  }

  ////////////////////
  // resize Sliders //
  ////////////////////
  // resize slider zoom
  cp5.getController("slider_zoom").setPosition(0, height-slide_height+slide_height/4);
  cp5.getController("slider_zoom").setSize(slide_width, slide_height/2);
  cp5.getController("slider_zoom").setFont(createFont("arial", 20*gui_font_scalar));
  cp5.getController("slider_zoom").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(0);

  // resize slider timeline
  cp5.getController("slider_timeline").setPosition(width-slide_width, height-slide_height+slide_height/4);
  cp5.getController("slider_timeline").setSize(slide_width, slide_height/2); 
  cp5.getController("slider_timeline").setFont(createFont("arial", 20*gui_font_scalar));
  cp5.getController("slider_timeline").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(0);

  /////////////////////
  // resize buttons: //
  /////////////////////
  cp5.getController("b_start").setPosition(width/2-button_width/2, 0);
  cp5.getController("b_start").setSize(button_width, button_height);
  cp5.getController("b_start").setFont(createFont("arial", 20*gui_font_scalar));
  //cp5.getController("b_serial").setPosition(button_width*2, 0);
  //cp5.getController("b_serial").setSize(button_width/2, button_height);
  //cp5.getController("b_serial").setFont(createFont("arial", 20*gui_font_scalar));
  cp5.getController("b_open").setPosition(width-button_width, 0);
  cp5.getController("b_open").setSize(button_width, button_height);
  cp5.getController("b_open").setFont(createFont("arial", 20*gui_font_scalar));
  cp5.getController("b_reset").setPosition(width/2-button_width/2, height-slide_height);
  cp5.getController("b_reset").setSize(button_width, slide_height);
  cp5.getController("b_reset").setFont(createFont("arial", 20*gui_font_scalar));
  /////////////////
  // resize text //
  /////////////////

  gui_font_scalar = 0.25+min((float)height/(float)displayHeight, (float)width/(float)displayWidth);
  cp5.getController("file_label").setPosition(width/2+button_width/2+5, 0);
  cp5.getController("serial_port_label").setPosition(button_width, 0);
}
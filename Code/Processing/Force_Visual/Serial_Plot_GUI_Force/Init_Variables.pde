// Init variables
void Init_Variables() {
  // select number of charts:
  number_of_charts=5; // max 10
  data_points_update=new float[number_of_charts];
  // serial objects
  myPorts = new Serial[1];  // Create a list of objects from Serial class
  serial_baudrate=57600;
  myPortsNames= new String[2];
  
  //init string data
  chart_lable_string=new String[number_of_charts];

  // init chart data range
  data_min_range = new float[number_of_charts];
  data_max_range = new float[number_of_charts];
  for (int ii=0; ii<number_of_charts; ii++) {
    data_min_range[ii]=0;
    data_max_range[ii]=11;
    chart_lable_string[ii]=("Graph_"+ii);
  }
  // overide
  data_min_range[0]=0;
  data_max_range[0]=1100;
}

// Initialization of IMU GUI variables
void Init_IMU_Variables() {
  // select number of charts:
  number_of_charts=3;
  data_points_update=new float[number_of_charts];
  
  // serial objects
  myPorts = new Serial[1];  // Create a list of objects from Serial class
  serial_baudrate=57600;
  myPortsNames= new String[] {"",""};
  
  //init string data
  chart_lable_string=new String[number_of_charts];

  // init chart data range
  data_min_range = new float[number_of_charts];
  data_max_range = new float[number_of_charts];
  
  //data_min_range[0]=0;
  //data_max_range[0]=1000;
  ////chart_lable_string[0]=("Pulse Oximeter");
  //chart_lable_string[0]=("Time[sub seconds]");

  int set_range=90;
  data_min_range[0]=0;
  data_max_range[0]=360;
  chart_lable_string[0]=("YAW");

  data_min_range[1]=-45;
  data_max_range[1]=45;
  chart_lable_string[1]=("Pitch");

  data_min_range[2]=-45;
  data_max_range[2]=45;
  chart_lable_string[2]=("Roll");
}

// Initialization of IMU GUI variables
void Init_Force_Variables() {
  // select number of charts:
  number_of_charts=5;
  data_points_update=new float[number_of_charts];
  
  // serial objects
  myPorts = new Serial[2];  // Create a list of objects from Serial class
  serial_baudrate=57600;
  myPortsNames= new String[] {"",""};
  
  //init string data
  chart_lable_string=new String[number_of_charts];

  // init chart data range
  data_min_range = new float[number_of_charts];
  data_max_range = new float[number_of_charts];
  
  data_min_range[0]=300;
  data_max_range[0]=600;
  //chart_lable_string[0]=("Pulse Oximeter");
  chart_lable_string[0]=("Band");

  int set_range=1000;
  data_min_range[1]=0;
  data_max_range[1]=set_range;
  chart_lable_string[1]=("Force1");

  data_min_range[2]=0;
  data_max_range[2]=set_range;
  chart_lable_string[2]=("Force2");

  data_min_range[3]=0;
  data_max_range[3]=set_range;
  chart_lable_string[3]=("Force3");
  
  data_min_range[4]=0;
  data_max_range[4]=set_range;
  chart_lable_string[4]=("Force4");
}



// Initialization of Mouse GUI variables
void Init_Mouse_Demo_Variables() {
  // select number of charts:
  number_of_charts=4;
  data_points_update=new float[number_of_charts];
  
  // serial objects
  myPorts = new Serial[2];  // Create a list of objects from Serial class
  serial_baudrate=115200;
  myPortsNames= new String[] {"",""};

  //init string data
  chart_lable_string=new String[number_of_charts];

  // init chart data range
  data_min_range = new float[number_of_charts];
  data_max_range = new float[number_of_charts];

  data_min_range[0]=0;
  data_max_range[0]=height;
  chart_lable_string[0]=("mouseY");

  data_min_range[1]=0;
  data_max_range[1]=width;
  chart_lable_string[1]=("mouseX");

  data_min_range[2]=-width;
  data_max_range[2]=width;
  chart_lable_string[2]=("mouseY-mouseX");

  data_min_range[3]=0;
  data_max_range[3]=(height+width)/2;
  chart_lable_string[3]=("(mouseY+mouseX)/2");
}
// Chart class object
class Chart_Frame {

  // declare variables 

  // Chart data:
  int data_points;
  float[] chart_data;

  // chart data range
  float chart_min_range;
  float chart_max_range;

  // chart display range dynamicaly changed by slider
  float chart_disp_min_range;
  float chart_disp_max_range;

  // chart_Frame id
  int id;

  // chart_Frame position
  float chart_x, chart_y, chart_w, chart_h;

  // graph parameter
  float graph_x, graph_y, graph_w, graph_h;
  float graph_offset_x, graph_offset_y;
  float graph_offset_w;

  // grid lines:
  // number vertical lines
  int num_hor_grid=5;
  int num_ver_grid=20;

  // declare cp5 chart object
  Chart myChart;

  // object constructor
  Chart_Frame(float _chart_x, float _chart_y, float _chart_w, float _chart_h, int _id, int _data_points, float _chart_min_range, float _chart_max_range, float _graph_offset_x, float _graph_offset_y, float _graph_offset_w) {
    // object parameters
    id=_id;
    chart_x=_chart_x;
    chart_y=_chart_y;
    chart_w=_chart_w;
    chart_h=_chart_h;
    graph_offset_x=_graph_offset_x;
    graph_offset_y=_graph_offset_y;
    graph_offset_w=_graph_offset_w; // sliders space - 75, same as graph_offset_x

    // set graph coordinates
    graph_x=graph_offset_x;
    graph_y=chart_h*graph_offset_y;
    graph_w=chart_w-graph_offset_x-graph_offset_w;
    graph_h=chart_h*(1-3*graph_offset_y);
    //graph_h=chart_h*0.95;
    // data points
    data_points=_data_points;

    // chart data range
    chart_min_range=_chart_min_range;
    chart_max_range=_chart_max_range;

    // chart display range:
    chart_disp_min_range=chart_min_range;
    chart_disp_max_range=chart_max_range;

    // Chart data:
    chart_data=new float[data_points];

    ///////////////////////////////////
    // init sliders scale and offset //
    ///////////////////////////////////
    cp5.addSlider("slider_scale"+id)  
      .setBroadcast(false)
      .setRange(-1.0, 1.0)
      .setValue(0)
      .setSliderMode(Slider.FLEXIBLE)
      .setColorBackground(color(0, 125, 125))
      .setLabelVisible(false) // vertical sliders 
      .setCaptionLabel("") // vertical sliders 
      //.setFont(createFont("arial", 14*gui_font_scalar))
      //.setColorBackground(color(0, 125, 125))
      //.setColorCaptionLabel(color(0)) 
      //.setColorValueLabel(color(0))
      //.setCaptionLabel("Scale")
      .setBroadcast(true);
    cp5.addSlider("slider_offset"+id).setBroadcast(false)
      .setRange(data_min_range[id], data_max_range[id])
      .setValue(0)
      .setSliderMode(Slider.FLEXIBLE)
      .setColorBackground(color(0, 125, 125))
      .setLabelVisible(false) // vertical sliders 
      .setCaptionLabel("") // vertical sliders
      //.setFont(createFont("arial", 14*gui_font_scalar))
      //.setColorBackground(color(0, 125, 125))
      //.setColorCaptionLabel(color(0)) 
      //.setColorValueLabel(color(0))
      //.setCaptionLabel("Offset")
      .setBroadcast(true);
    update_chart_sliders();

    ///////////////////////////
    // init cp5 chart object //
    ///////////////////////////
    myChart = cp5.addChart("dataflow"+id)
      .setPosition(chart_x+graph_x, chart_y+graph_y)
      .setSize(int(graph_w), int(graph_h))
      .setRange(chart_min_range, chart_max_range)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(1.5);

    myChart.getColor().setBackground(color(255, 1));  
    myChart.addDataSet("incoming");
    myChart.setColors("incoming", color(255, 0, 0));
    myChart.setData("incoming", new float[data_points]);

    // example additional charts
    //myChart.addDataSet("layer_1");
    //myChart.setColors("layer_1", color(0, 255, 0));
    //myChart.setData("layer_1", new float[data_points]);
    //myChart.addDataSet("layer_2");
    //myChart.setColors("layer_2", color(0, 0, 255));
    //myChart.setData("layer_2", new float[data_points]);
  }

  Chart_Frame() {
    //this(0, 0, 100, 100);
  }

  // reset the chart's datapoints()
  void clear_chart_data() {
    // reset the chart's datapoints()
    for (int i = 0; i <chart_data.length; i++) {
      chart_data[i]=0;
    }
  }

  // Resize charts
  void Chart_Resize(float _chart_x, float _chart_y, float _chart_w, float _chart_h, int _id) {
    // chart id
    int id=_id;
    // update variables
    chart_x=_chart_x;
    chart_y=_chart_y;
    chart_w=_chart_w;
    chart_h=_chart_h;

    // set graph coordinates
    graph_x=graph_offset_x;
    graph_y=chart_h*graph_offset_y;
    graph_w=chart_w-graph_offset_x-graph_offset_w;
    graph_h=chart_h*(1-3*graph_offset_y); 

    // resize cp5 chart object
    myChart.setPosition(chart_x+graph_x, chart_y+graph_y);
    myChart.setSize(int(graph_w), int(graph_h));
    myChart.setRange(chart_min_range, chart_max_range);

    // we use the init function to resize (it will overwrite the reference of existing controllers)
    update_chart_sliders();
  }

  void update_chart_sliders() {
    int temp_slider_gap=5;
    int temp_slider_h=15;

    //int temp_slider_w=int(graph_offset_w)-temp_slider_gap*2; // horizontal sliders option
    //int temp_slider_y_gap=temp_slider_h+25; // horizontal sliders option

    int temp_slider_x_gap=temp_slider_h+50; // vertical sliders option
    int temp_slider_translate_gap = 30; // vertical sliders option - horizontal gap between graph and sliders

    cp5.getController("slider_scale"+id).setBroadcast(false);
    cp5.getController("slider_scale"+id).setPosition(chart_x+graph_x+graph_w+temp_slider_gap+temp_slider_translate_gap, chart_y+graph_y);
    cp5.getController("slider_scale"+id).setSize(temp_slider_h, int(graph_h));
    // horizontal
    //cp5.getController("slider_scale"+id).setPosition(chart_x+graph_x+graph_w+temp_slider_gap, chart_y+graph_y+graph_h-temp_slider_h);
    //cp5.getController("slider_scale"+id).setSize(temp_slider_w, temp_slider_h)
    cp5.getController("slider_scale"+id).getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
    cp5.getController("slider_scale"+id).getValueLabel().align(ControlP5.RIGHT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
    cp5.getController("slider_scale"+id).setBroadcast(true);


    cp5.getController("slider_offset"+id).setBroadcast(false);
    // vertical
    cp5.getController("slider_offset"+id).setPosition(chart_x+graph_x+graph_w+temp_slider_gap+temp_slider_x_gap+temp_slider_translate_gap, chart_y+graph_y);
    cp5.getController("slider_offset"+id).setSize(temp_slider_h, int(graph_h));
    // horizontal
    //cp5.getController("slider_offset"+id).setPosition(chart_x+graph_x+graph_w+temp_slider_gap, chart_y+graph_y+graph_h-temp_slider_h-temp_slider_y_gap);
    //cp5.getController("slider_offset"+id).setSize(temp_slider_w, temp_slider_h);  
    cp5.getController("slider_offset"+id).getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
    cp5.getController("slider_offset"+id).getValueLabel().align(ControlP5.RIGHT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
    cp5.getController("slider_offset"+id).setBroadcast(true);
  }

  // display GUI
  void display() {
    // translate rotate pushMatrix()
    pushMatrix();
    translate(chart_x, chart_y);
    stroke(0);
    fill(color(255, 255, 255, 200)); // set opacity
    rect(0, 0, chart_w, chart_h);
    plot_graph();
    popMatrix();

    // verical sliders text
    display_slider_text();
  }

  void display_slider_text() {
    pushStyle();
    textSize(14*gui_font_scalar);

    pushMatrix(); 
    rotate(HALF_PI);

    textAlign(CENTER);
    text("Scale", cp5.getController("slider_scale"+id).getPosition()[1], -cp5.getController("slider_scale"+id).getPosition()[0], cp5.getController("slider_scale"+id).getHeight(), 40);
    //we get the slider value position in in it's range
    float scale_value_position = norm(cp5.getController("slider_scale"+id).getValue(), cp5.getController("slider_scale"+id).getMin(), cp5.getController("slider_scale"+id).getMax());
    text(nf(cp5.getController("slider_scale"+id).getValue(), 1, 2), cp5.getController("slider_scale"+id).getPosition()[1]+(-1*scale_value_position)*cp5.getController("slider_scale"+id).getHeight()+cp5.getController("slider_scale"+id).getHeight()*0.5, -cp5.getController("slider_scale"+id).getPosition()[0]-cp5.getController("slider_scale"+id).getWidth()*2.5, cp5.getController("slider_scale"+id).getHeight(), 40);

    text("Offset", cp5.getController("slider_offset"+id).getPosition()[1], -cp5.getController("slider_offset"+id).getPosition()[0], cp5.getController("slider_scale"+id).getHeight(), 40);
    //we get the slider value position in in it's range
    float offset_value_position = norm(cp5.getController("slider_offset"+id).getValue(), cp5.getController("slider_offset"+id).getMin(), cp5.getController("slider_offset"+id).getMax());
    text(nf(cp5.getController("slider_offset"+id).getValue(), 2, 2), cp5.getController("slider_offset"+id).getPosition()[1]+(-1*offset_value_position)*cp5.getController("slider_offset"+id).getHeight()+cp5.getController("slider_scale"+id).getHeight()*0.5, -cp5.getController("slider_offset"+id).getPosition()[0]-cp5.getController("slider_offset"+id).getWidth()*2.5, cp5.getController("slider_offset"+id).getHeight(), 40);


    popMatrix();
    popStyle();
  }

  // plot graph
  void plot_graph() {
    pushMatrix();
    translate(graph_x, graph_y);
    stroke(0);
    //fill(255,0); // set opacity
    //fill(color(255,255,255,100)); // set opacity
    fill(color(255, 255, 0, 100)); // set opacity
    rect(0, 0, graph_w, graph_h);
    // optional add grid to graph
    plot_grid();
    // optional add graph labels
    add_label();
    popMatrix();
  }
  ///////////////
  // plot grid //
  ///////////////
  void plot_grid() {
    float space_hor_grid=graph_h/num_hor_grid;
    float space_ver_grid=graph_w/num_ver_grid;
    stroke(125, 75);
    strokeWeight(0.5);
    for (int ii=0; ii<=num_hor_grid; ii++) {
      line(0, space_hor_grid*ii, graph_w, space_hor_grid*ii);
    }
    for (int ii=0; ii<=num_ver_grid; ii++) {
      line(space_ver_grid*ii, 0, space_ver_grid*ii, graph_h);
    }
    stroke(255, 0, 0);
    // temp lines
    //line(0, space_hor_grid+110, graph_w, space_hor_grid+110);
    //line(0, space_hor_grid+30, graph_w, space_hor_grid+30);
    stroke(125, 75);
    
    // add text grid 
    int text_size=12;
    textSize(text_size*gui_font_scalar);
    // data range spacing
    //int num_points=slider_zoom.getValueI();
    int num_points=int(cp5.getController("slider_zoom").getValue());
    float range_spacing_disp=(chart_disp_max_range-chart_disp_min_range)/num_hor_grid;
    fill(0);
    // horizontal grid text
    for (int ii=0; ii<=num_hor_grid; ii++) {
      float tempnum=(num_hor_grid-ii)*range_spacing_disp+chart_disp_min_range;
      //int tempnum=int((num_hor_grid-ii)*range_spacing_disp+chart_disp_min_range);
      text(nf(tempnum,0,1), -text_size*3.5, space_hor_grid*ii+text_size/3);
      //text(nf(tempnum, 0), -text_size*3.5, space_hor_grid*ii+text_size/2);
    }
    // vertical grid text
    for (int ii=1; ii<=num_ver_grid; ii++) {
      int tempnum=(num_ver_grid-ii)*num_points/num_ver_grid;
      text(nf(tempnum), space_ver_grid*ii-text_size/2, graph_h+text_size);
    }
  }

  void add_label() {
    int text_size=24;
    pushStyle();
    textSize(text_size*gui_font_scalar);
    fill(0);
    text(chart_lable_string[id], 5+1, graph_y+text_size/2+1);
    fill(255);
    text(chart_lable_string[id], 5-1, graph_y+text_size/2-1);
    fill(100);
    text(chart_lable_string[id], 5, graph_y+text_size/2);
    popStyle();
  }

  /////////////////////////
  // slider event update //
  /////////////////////////
  void update_slider_event(int _id) {
    int temp_id=_id;
    float scale=pow(10, cp5.getController("slider_scale"+temp_id).getValue());
    float offset=cp5.getController("slider_offset"+temp_id).getValue();
    chart_array[temp_id].chart_disp_min_range=chart_array[temp_id].chart_min_range/scale+offset;
    chart_array[temp_id].chart_disp_max_range=chart_array[temp_id].chart_max_range/scale+offset;
    chart_array[temp_id].myChart.setRange(chart_array[temp_id].chart_disp_min_range, chart_array[temp_id].chart_disp_max_range );
  }
} // end class Chart_Frame

//////////////////////////////////////////////////
// slider events see if there is another method //
//////////////////////////////////////////////////
// event functions for the controlp5 slider_0
public void slider_offset0(float theValue) {
  int temp_id=0;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_offset_0 "+theValue);
  }
}

public void slider_scale0(float theValue) {
  int temp_id=0;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_scale_0 "+theValue);
  }
}

// event functions for the controlp5 slider_0
public void slider_offset1(float theValue) {
  int temp_id=1;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_offset_1 "+theValue);
  }
}

public void slider_scale1(float theValue) {
  int temp_id=1;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_scale_1 "+theValue);
  }
}

// event functions for the controlp5 slider_2
public void slider_offset2(float theValue) {
  int temp_id=2;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_offset_2 "+theValue);
  }
}

public void slider_scale2(float theValue) {
  int temp_id=2;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_scale_2 "+theValue);
  }
}

// event functions for the controlp5 slider_3
public void slider_offset3(float theValue) {
  int temp_id=3;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_offset_3 "+theValue);
  }
}

public void slider_scale3(float theValue) {
  int temp_id=3;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_scale_3 "+theValue);
  }
}

// event functions for the controlp5 slider_4
public void slider_offset4(float theValue) {
  int temp_id=4;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_offset_4 "+theValue);
  }
}

public void slider_scale4(float theValue) {
  int temp_id=4;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_scale_4 "+theValue);
  }
}

// event functions for the controlp5 slider_5
public void slider_offset5(float theValue) {
  int temp_id=5;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_offset_5 "+theValue);
  }
}

public void slider_scale5(float theValue) {
  int temp_id=5;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_scale_5 "+theValue);
  }
}

// event functions for the controlp5 slider_6
public void slider_offset6(float theValue) {
  int temp_id=6;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_offset_6 "+theValue);
  }
}

public void slider_scale6(float theValue) {
  int temp_id=6;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_scale_6 "+theValue);
  }
}

// event functions for the controlp5 slider_7
public void slider_offset7(float theValue) {
  int temp_id=7;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_offset_7 "+theValue);
  }
}

public void slider_scale7(float theValue) {
  int temp_id=7;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_scale_7 "+theValue);
  }
}

// event functions for the controlp5 slider_8
public void slider_offset8(float theValue) {
  int temp_id=8;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_offset_8 "+theValue);
  }
}

public void slider_scale8(float theValue) {
  int temp_id=8;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_scale_8 "+theValue);
  }
}

// event functions for the controlp5 slider_9
public void slider_offset9(float theValue) {
  int temp_id=9;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_offset_9 "+theValue);
  }
}

public void slider_scale9(float theValue) {
  int temp_id=9;
  chart_array[temp_id].update_slider_event(temp_id);
  if (DEBUG_MODE) {
    println("slider_scale_9 "+theValue);
  }
}
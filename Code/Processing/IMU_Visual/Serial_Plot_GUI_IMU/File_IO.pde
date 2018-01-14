////////////////////////////////
//  Writing to output
////////////////////////////////

// Start rcording
void Start_Record() {
  output_folder = new File(sketchPath("Output\\"+generate_output_filename()));
  //we select the output file
  selectOutput("Select output file:", "output_file_selected", output_folder);
}


// Stop recording
void Stop_Record() {
  if (output_file_status) {
    // flash file and close
    try { // to implement in case closing failed don`t chenge button status
      writer.flush(); // Writes the remaining data to the file
      writer.close(); // Finishes the file
      output_file_status=false;
      // update gui string with file name
      file_label.setText("File Recorded: "+output_file_name);
    }
    catch(IOException ioe) { 
      ioe.printStackTrace();
    }
  } else {
    println("No output file selected");
  }
}


// Callback method for selecting an output file
void output_file_selected(File _selection) {
  if (_selection == null) {
    println("Window was closed or the user hit cancel.");
    b_start(0);
  } else {
    output_file = _selection;
    output_file_name = output_file.getName();
    output_file_path = output_file.getAbsolutePath();
    output_file_status=true;
    // create bufferwriter
    try {
      writer = new BufferedWriter(new FileWriter(output_file_path, true));
    } 
    catch(IOException ioe) {
      ioe.printStackTrace();
    }
    println("User selected " + output_file_path);
    // update gui string with file name
    file_label.setText("File Recording: "+output_file_name);
  }
}


// Function for recording Strings into the output file
void record_line(String _line_to_record) {
  if (output_file_status==true) {
    if (b_start_state==true) {
      try {
        //write new line and flush to file
        writer.write(_line_to_record);
        writer.newLine();
        writer.flush(); // Writes the remaining data to the file
      }
      catch(Exception ex) {
        System.out.println("Error in closing the BufferedWriter"+ex);
      }
    }
  }
}


// Generate a suggested file name for the output based on local time;
String generate_output_filename() {
  String temp_name = (hour()+"_"+minute()+"_"+second());
  return(temp_name+".txt");
}

////////////////////////////////
//  Reading from input
////////////////////////////////


// Callback method for selecting an input file
void input_file_selected(File _selection) {
  if (_selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    input_file = _selection;
    input_file_name = input_file.getName();
    input_file_path = input_file.getAbsolutePath();
    input_file_status=true;
    println("User selected " + input_file_path);
    // update gui string with file name
    file_label.setText("File Selected: "+input_file_name);

    // set live mode to false
    LIVE_MODE = false;

    // get number of lines in file()
    line_count = 0;
    try {
      line_count = Files.lines(input_file.toPath()).count(); // this can be improved
    }
    catch (Exception e) {
      println(e);
    }

    // we compute our maximal zoom buffer we might need by subtracting the min zoom range from the max
    // as in, we know that at minimum we should show 100 datapoints... so we can have maximum zoom buffer of 1000 datapoint space minus 100 filled data
    max_zoom_buffer = int(cp5.getController("slider_zoom").getMax()-cp5.getController("slider_zoom").getMin());

    load_file_data();
  }
}


void load_file_data() {

  float timeline_from_controller = cp5.getController("slider_timeline").getValue();

  // compute line position in file - as in, multiply the slider postion by the number of lines in the file
  long line_position_in_file = floor(line_count*timeline_from_controller);
  long start_buffer = line_position_in_file-max_zoom_buffer;
  long end_buffer = line_position_in_file+int(cp5.getController("slider_zoom").getMin());
  long start_read = start_buffer;
  long end_read = end_buffer;
  int array_index_temp = 0;


  if (start_buffer<0) {
    start_read = 0;
    array_index_temp = int(abs(start_buffer));
  }

  if (end_buffer>line_count) {
    end_read = line_count;
  } 

  //we reset the file reading buffer
  input_string_buffer = new String[0];

  // read file using control values()
  read_line_by_number(input_file_path, start_read, end_read-start_read);

  // reset the chart's datapoints()
  for (int jj=0; jj< chart_array.length; jj++) {
    chart_array[jj].clear_chart_data();
  }

  // update data array with read data file
  for (int i=0; i<input_string_buffer.length; i++) {
    String[] delimited_input_string = input_string_buffer[i].split(":");
    if (delimited_input_string[0].equals("REC")) {
      String[] delimited_value_string = delimited_input_string[1].split("\t");
      for (int jj=0; jj< chart_array.length; jj++) {
        // data
        chart_array[jj].chart_data[array_index_temp]=float(delimited_value_string[jj+1]);
      }
      array_index_temp++;
    }
  }

  if (DEBUG_MODE) {
    println("line_position_in_file: "+line_position_in_file);
    println("line_count:"+line_count);
    println("array_index_temp:"+array_index_temp);
    println("start_buffer"+start_buffer);
    println("end_buffer"+end_buffer);
    println("start_read"+start_read);
    println("end_read"+end_read);
    println("input_string_buffer.length"+input_string_buffer.length);
  }

  //  get the current gui control values()
  float zoom_from_controller = cp5.getController("slider_zoom").getValue();
  //update the graphs()
  slider_zoom(int(zoom_from_controller));
}

// Read multiple lines from the input
void read_line_by_number(String _file_string_path, long _start_index, long _count_index) {
  if (input_file_status) {
    input_string_buffer = new String[0];
    long line_counter=1;
    try {
      reader = new BufferedReader(new FileReader(_file_string_path));
      String line;
      while ((line = reader.readLine()) != null) {
        if (line_counter>=_start_index&&line_counter<_count_index+_start_index) {
          input_string_buffer = append(input_string_buffer, line);
        }
        line_counter++;
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
    } 
    finally {
      try {
        reader.close();
      } 
      catch (IOException e) {
        e.printStackTrace();
      }
    }
  } else {
    println("No input file selected");
  }
}
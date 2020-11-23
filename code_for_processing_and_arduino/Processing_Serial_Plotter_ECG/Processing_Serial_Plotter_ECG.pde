// import require libraries

String FileName = "arduino_output.csv";

import grafica.*;
import processing.serial.*;

float t=0;
// create plot instance
GPlot plot;
GPointsArray points1;
//OY 8/9/2018
int NCHANNELS = 1;
int vals[];
GPointsArray[] allPoints;

boolean[] plotEnable = {true, false, false, false, false, false, false, false};
GLayer[] allLayers;
String[] allLayerLabels;

int[] allColors;

String valString;
float time_sec;


long val;
boolean readVal = false;
boolean acquireData = true;

// initialise global variables
long i = 0; // variable that changes for polong calculation
int points = 450; // number of points to display at a time
long totalPoints = 50000; // number of points on x axis
float noise = 0.1; // added noise
float period = 0.35;
long previousMillis = 0;
long duration = 20;

long GMinPolong = 10000000;
long GMaxPolong = -10000000;
// Serial
Serial myPort; // Create object from Serial class

PrintWriter output;

boolean isNum(String strNum) {
  boolean ret = true;
  try {

    Double.parseDouble(strNum);
  }
  catch (NumberFormatException e) {
    ret = false;
  }
  return ret;
}


void setup() {
  // set size of the window
  //size (900, 450);


  size(1000, 600);
  String portName;
  output = createWriter(FileName);
  // set up serial connection
  portName = Serial.list()[0];
  myPort = new Serial(this, portName, 500000);
  myPort.bufferUntil(10);



  // initialise graph points object
  allPoints = new GPointsArray[NCHANNELS];
  points1 = new GPointsArray();
  allLayers = new GLayer[NCHANNELS];
  allLayerLabels = new String[NCHANNELS];

  vals = new int[NCHANNELS];
  for (int j=0; j<NCHANNELS; j++) {
    allPoints[j] = new GPointsArray(points);
    allLayerLabels[j]=str(j);
  }

  // calculate initial display points
  for (i = 0; i < points; i++) {
    points1.add(i, 0);
    /*
    for (int j=0; j<NCHANNELS; j++) {
      allPoints[j].add(i, 0);
      points1.add(i,0);
    }
    */
  }

  // Create the plot
  plot = new GPlot(this);
  plot.setPos(25, 25); // set the position of to left corner of plot
  plot.setDim(800, 450); // set plot size
  //OY 8/3/2018
  plot.setPointSize(3);

  // Set the plot limits (this will fix them)
  //plot.setXLim(0, totalPoints); // set x limits
  plot.setXLim(0, 750); // set x limits
  //plot.setYLim(-32768, 32768); // set y limit
  //plot.setYLim(0, 17000000); // set y limit
  plot.setYLim(-8388608, 8388608);
  //plot.setYLim(7000,8000);

  // Set the plot title and the axis labels
  plot.setTitleText("Oguz's Arduino Plotter"); // set plot title
  plot.getXAxis().setAxisLabelText("samples"); // set x axis label
  plot.getYAxis().setAxisLabelText("ADC Value"); // set y axis label

  // Add the two set of points to the plot
  //plot.setPoints(points1);
  //OY 8/9/2018
  for (int j=0; j<NCHANNELS; j++) {
    //allLayers[j].addPoints(allPoints[j]);
    //plot.addLayer(str(j), allPoints[j]);
    plot.setPoints(points1);
    //plot.setPoints(allPoints[j]);
  }


  //plot.activateZooming();
  //plot.activatePanning();

  plot.activatePanning();
  plot.activateZooming(1.1, CENTER, CENTER);
  /*
  allColors[0] = color(255,0,0);
   allColors[1] = color(0,255,0);
   allColors[2] = color(0,0,255);
   allColors[3] = color(255,255,0);
   allColors[4] = color(0,255,255);
   allColors[5] = color(125,125,125);
   allColors[6] = color(0,100,100);
   allColors[7] = color(0,0,0);
   */
  //plot.preventWheelDefault();
}

void draw() {
  // set window background

  background(150);

  // draw the plot
  plot.beginDraw();
  plot.drawBackground();
  plot.drawBox();
  plot.drawXAxis();
  plot.drawYAxis();
  plot.drawTopAxis();
  plot.drawRightAxis();
  plot.drawTitle();
  plot.getMainLayer().drawPoints();
  plot.drawLines();

  //OY 8/5/2018
  if (acquireData) {
    //plot.setPoints(points1);
    //OY 8/9/2018
    /*
    for (int j=0; j<NCHANNELS; j++) {
      //plot.setPoints(allPoints[j]);
      if (plotEnable[j]) {
        plot.getLayer(str(j)).setPoints(allPoints[j]);
      }
    }
    */
    plot.setPoints(points1);


    //plot.getLayer("0").setLineColor(color(0, 0, 0));
    //plot.getLayer("1").setLineColor(color(255, 0, 0));
    //plot.getLayer("2").setLineColor(color(0, 0, 255));
    //plot.getLayer("3").setLineColor(color(255, 255, 0));
    //plot.getLayer("4").setLineColor(color(0, 255, 255));
    //plot.getLayer("5").setLineColor(color(125, 125, 125));
    //plot.getLayer("6").setLineColor(color(0, 100, 100));
    //plot.getLayer("7").setLineColor(color(0, 255, 0));



    if (i>750) {

      //plot.align(i, vals[0], 750, 300);
      plot.align(i, val, 750.0, 300.0);
      //plot.align(time_sec, val, 750, 150);
    }
  }
  plot.endDraw();




  //long val = myPort.read()*256 + myPort.read(); // read it and store it in val

  /*
  if (readVal == true && acquireData == true ) {
   println(val);
   // Add the polong at the end of the array
   i++;
   // float[] lims = plot.calculatePointsYLim(plot.getPoints());
   // plot.setYLim(lims[0], lims[1]);
   
   
   plot.addPoint(i, val);
   
   //OY 8/5/2018
   //plot.centerAndZoom(4,i,val);
   //plot.center(i,val);
   if (i>750) {
   
   plot.align(i, val, 750, 150);
   }
   readVal = false;
   }
   */
}

void keyPressed() {

  String keyStr = "";
  keyStr+=key;

  if (key == ' ') {  //toggle read
    acquireData = !acquireData;
  }

  if (key == 'x') {
    output.flush();
    output.close();
    exit();
  }
  if (isNum(keyStr)) {
    if (int(keyStr)<8) {
      plotEnable[int(keyStr)] = !plotEnable[int(keyStr)];
    }
  }
}


void serialEvent(Serial myPort) {
  String valString = myPort.readString();
  print(".");
  if (valString != null && acquireData) {
    valString= trim(valString);
    //println(valString);
    try {
      String[] res = split(valString,",");
      int time_usec = int(res[0]);
      time_sec = time_usec/1000000.0;
      //val = int(valString);
      val = int(res[1]);
      readVal = true;
      i++;
     // points1.add(i, val);
     points1.add(time_sec,val);

    
      //println(val);
      print(time_sec);print(",");println(val);
     // output.println(i + "," + val);
     output.println(time_sec + "," + val);
    }
    catch(Exception e) {
      println("err");
      val = -1;
    }
  }
}
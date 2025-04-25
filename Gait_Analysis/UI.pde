///* ---------------------------------------------------------------------------------------------------------
//BME/CS 479 Spring 2025 - Lab 3
//Prof. Hananeh Esmailbeigi

//Project: Gait Analysis
//Description: This project analyzes and profiles your gait using FSRs

//Authors: Kegan Jones, Rohan Kakarlapudi, Sufyan Siddiqui, Cindy Nakhammouane

//Date: April 4, 2025

//Acknowledgements:
//- Suggestions and debugging guidance provided by ChatGPT (OpenAI)

//References: 
//- https://processing.org/reference/libraries/serial/index.html
//- https://www.gicentre.net/utils
//-----------------------------------------------------------------------------------------------------------*/

PImage background_img;
PImage status_img;
int r = 12;  // number of rows in input array
int c = 6;  // number of columns in input array
int t = 60; // Reduce size so it fits half the screen
int rows = (r-1)*t;  // height of the heat map
int cols = (c-1)*t;  // width of the heat map
float mf = 0;
float lf = 0;
float mm = 0;
float heel = 0;
float strideLength = 0;
float stepLength = 0;
float mfp = 0;
int cadence = 0;
int stepCount = 0;
String gaitProfile = "";
String status = "Standing Still";
String gaitAlert = "";
String action = "";
String period = "";
boolean inMotion = false;
int heatmapX = 75; // X position for the heatmap
int heatmapY = 110; // Y position for the heatmap

float[][] array = new float[r][c];  // input array
float[][] interp_array = new float[rows][cols]; // interpolated array

void settings() {
    size(1458, 900); // Set UI size

}

void setup() {
    activity_time_start = millis();

  //Serial set up
  String portName = Serial.list()[0]; 
  //be sure to select the correct port that you have in your laptop 
  println(Serial.list());
  println(portName);
  
  myPort = new Serial(this, portName, 115200);
  myPort.bufferUntil('\n');
  
  noStroke();
  generateDefaultData();//fills empty space with blue/empty color
  //array[2][2] = 9;//MF
  //array[4][1] = 2;//MM
  //array[3][3] = 7;//LF
  //array[9][2] = 10;//HEEL
  //printArrayValues();
  //bilinearInterpolation();
  
  setupMFGraph(); 
  setupLFGraph();
  setupMMGraph();
  setupHEELGraph();
  
  //addPointToMFGraph(0, 0);
  //addPointToMFGraph(1000, 1);
  //addPointToLFGraph(0, 0);
  //addPointToLFGraph(1000, 1);
  //addPointToMMGraph(0, 0);
  //addPointToMMGraph(1000, 1);
  //addPointToHEELGraph(0, 0);
  //addPointToHEELGraph(1000, 1);
  
  println("Hello from setup");
  surface.setTitle("Gait Analysis");
}

void draw() {
  background(240); // Light gray background for UI clarity
    bilinearInterpolation();

  applyColor();
    //printArrayValues();

  background_img = loadImage("bg2.png");
  background_img.resize(1458, 900);
  image(background_img,0,0); 

  updateStatusImage();
  
  translate(750, -245);
  drawMFGraph();
  translate(0, 145);
  drawLFGraph();
  translate(0, 155);
  drawMMGraph();
  translate(0, 155);
  drawHEELGraph();
  translate(-750, -210);
  drawInfo();
}

void generateDefaultData() {
  for (int i = 0; i < r; i++) {
    for (int j = 0; j < c; j++) {
      array[i][j] = 0; 
    }
  }
}

void printArrayValues() {
  println("Array Values:");
  for (int i = 0; i < r; i++) {
    for (int j = 0; j < c; j++) {
      print(nf(array[i][j], 1, 2) + "\t");
    }
    println();
  }
}

//
void updateStatusImage(){
  if(status.indexOf("Motion") != -1){
    status_img = loadImage("inMotion.png");
  }
  else{
    status_img = loadImage("standingStill.png");
  }
  status_img.resize(200, 200);
  image(status_img, 430, 330); 
}

//TODO change thresholds
void updateMFP(){
  
    if (mfp == 0){//0
    gaitProfile = "Walking on the heel";
  }

  else if (mfp > 50 ){
    if ((mm * 1000 * 5 / 230) > 5  && (lf * 1000 * 5 / 230) > 5){
       gaitProfile = "Normal Gait";
    }
     
    else if (mm * 1000 * 5 / 230 > 8 && lf * 1000 * 5 / 230 < 2){//if mm is 100 and lf is 0
      gaitProfile = "In-toeing";
    }
    else if (mf * 1000 * 5 / 230 > 8 && mm * 1000 * 5 / 230 < 2 && lf * 1000 * 5 / 230 < 2){
          gaitProfile = "Tiptoeing"; //99

    }
    
    
    else if (mm * 1000 * 5 / 230 < 2 || lf * 1000 * 5 / 230 > 7){//if lf is 100 and mm is 0
      gaitProfile = "Out-toeing";
    }
    else if(mfp > 80){
      gaitProfile = "Tiptoeing"; //99
    }   
  }
    else{// 50 50
      gaitProfile = "Normal Gait";
    }
  }



void drawInfo(){
  
   PFont num_font = createFont("Helvetica", 22); 
   push(); 
   textAlign(LEFT);
   textFont(num_font);
   fill(0,0,0);
   int min = ((millis() - activity_time_start) / 1000)/60;
   int secs = ((millis() - activity_time_start) / 1000) - min * 60;
   text( min + "m " + secs + "s", 485, 160);
   text(status, 455, 280);
   push();
   num_font = createFont("Helvetica", 10);
   textFont(num_font);
   text(period, 450, 295);
   pop();
   text(gaitAlert, 450, 640);
   text(action, 410, 680, 250, 400);
   text("\n\n" + gaitProfile, 150, 800);
   text(stepLength + "\n\n" + strideLength, 860, 800);
   text(cadence + "\n\n" + stepCount, 1235, 800);
   pop();

}


void bilinearInterpolation() {  
  for (int i=0; i<r; i++) {
    for (int j=0; j<c; j++) {
      int x = j*t - 1;
      int y = i*t - 1;
      if (x<0) x=0;
      if (y<0) y=0;
      interp_array[y][x] = array[i][j];
    }
  }

  float spreadFactor = 1.0;
  for (int y=0; y<rows; y++) {
    int dy1 = floor(y/(t*1.0 * spreadFactor));
    int dy2 = ceil(y/(t*1.0 * spreadFactor)); 
    int y1 = dy1*t - 1;
    int y2 = dy2*t - 1;
    if (y1<0) y1 = 0;
    if (y2<0) y2 = 0;
    
    for (int x=0; x<cols; x++) {
      int dx1 = floor(x/(t*1.0* spreadFactor));
      int dx2 = ceil(x/(t*1.0*spreadFactor));
      int x1 = dx1*t - 1;
      int x2 = dx2*t - 1;
      if (x1<0) x1 = 0;
      if (x2<0) x2 = 0;
      float q11 = array[dy1][dx1];
      float q12 = array[dy2][dx1];
      float q21 = array[dy1][dx2];
      float q22 = array[dy2][dx2];

      float t1 = (x-x1);
      float t2 = (x2-x);
      float t3 = (y-y1);
      float t4 = (y2-y);
      float t5 = (x2-x1);
      float t6 = (y2-y1);

      if (y1==y2) {
        interp_array[y][x] = q11*t2/t5 + q21*t1/t5;
      } else if (x1==x2) {
        interp_array[y][x] = q11*t4/t6 + q12*t3/t6;
      } else {
        float diff = t5*t6;
        interp_array[y][x] = (q11*t2*t4 + q21*t1*t4 + q12*t2*t3 + q22*t1*t3)/diff;
      }
    }
  }
}

void applyColor() {
  //color c0 = color(239, 242, 255); // White
  color c0 = color(255, 255, 255); // White
  color c1 = color(0,30,255); // Blue
  color c2 = color(112, 241, 255); // Light Blue
  color c3 = color(0, 255, 0); // Green
  color c4 = color(255, 255, 0); // Yellow
  color c5 = color(255, 165, 0); // Orange
  color c6 = color(255, 0, 0); // Red


  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      float value = interp_array[i][j];
      color c;
      float fraction;

      if (value < 1) {
        fraction = pow(constrain((value - 0) / 1.0, 0, 1), 3.0);
        c = lerpColor(c0, c1, fraction);
      } else if (value >= 1 && value < 2) {
        fraction = (value - 1) / 1.0;
        c = lerpColor(c1, c2, fraction);
      } else if (value >= 2 && value < 3) {
        fraction = (value - 2) / 1.0;
        c = lerpColor(c2, c3, fraction);
      } else if (value >= 3 && value < 4) {
        fraction = (value - 3) / 1.0;
        c = lerpColor(c3, c4, fraction);
      } else if (value >= 4 && value < 5) {
        fraction = (value - 4) / 1.0;
        c = lerpColor(c4, c5, fraction);
      } else if (value >= 5 && value < 7) {
        fraction = (value - 5) / 2.0; 
        c = lerpColor(c5, c6, fraction);
      } else {
        c = c6;
      }

      stroke(c);
      point(heatmapX + j, heatmapY + i);
    }
  }
}

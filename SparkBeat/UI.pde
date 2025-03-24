/* ---------------------------------------------------------------------------------------------------------
BME/CS 479 Spring 2025 - Lab 1
Prof. Hananeh Esmailbeigi

Project: SparkBeat - Smart Heartrate and Blood Oxygenation Wristband
Description: This project uses the Sparkfun Pulse Oximeter and Heart Rate Monitor (MAX30101 & MAX32664) 
            and FIREBEETLE BOARD-32P BLE 4.1, which together allows us to measure heart rates and blood oxygen saturation (SpO2), 
            providing insights into the wearer's cardiovascular health. Data is transmitted via BLE for real-time monitoring.

Authors: Rohan Kakarlapudi, Sufyan Siddiqui, Cindy Nakhammouane

Date: February 25, 2025

Acknowledgements:
- Suggestions and debugging guidance provided by ChatGPT (OpenAI)

References: 
- https://processing.org/reference/libraries/serial/index.html
- https://www.gicentre.net/utils
-----------------------------------------------------------------------------------------------------------*/


PImage background_img;
PImage curr_bpm_img; 
double curr_bpm = 0;
int oxygen_level = 0;
int confidence = 0;
int avg_bpm = 0; 
int total_bpm = 0;
int bpm_count = 0;
int resting_bpm = 0; 
int age = 20; 
int max_heart_rate = 220 - age;
double zone_percentage = (curr_bpm / max_heart_rate) * 100;
int prev_secs = 0;
int red_secs = 0;
int yellow_secs = 0;
int green_secs = 0;
int blue_secs = 0;
int gray_secs = 0;
int curr_time = ((millis() - activity_time_start) / 1000) - prev_secs;


// Initializes graphs for interface setup
void setup(){
  String portName = Serial.list()[0]; 
  //be sure to select the correct port that you have in your laptop 
  println(Serial.list());
  println(portName);
  
  myPort = new Serial(this, portName, 115200);
  myPort.bufferUntil('\n');
 
  setupGraph();  
  
  println("Hello from setup");
  surface.setTitle("SparkBeat");
  size(768, 1025); 
}


//Updates UI
void draw(){
  background(220);
  background_img = loadImage("bg.png"); 
  curr_bpm_img = loadImage("curr_bpm_circle.png");
  imageMode(CENTER); 
  background_img.resize(768, 1025); 
  image(background_img,.5*width,.5*height); 
  
  fitness_mode();
  translate(30, 230);
  drawGraph();
}


void drawTitle() {  
  fill(0); 
  textSize(60);
  PFont font = createFont("Helvetica", 60, true); 
  textFont(font); 
  String titleText = "Processing Lecture" ;
  float titleWidth = textWidth(titleText); 
  float titleX = (width - titleWidth) / 2;
  float titleY = height / 8;
  text(titleText, titleX, titleY);          
}


//User's fitness data should update in realtime, zone times are recorded, avg bpm is updates, oxygen levels updated
void fitness_mode(){
  zone_percentage = ((float)curr_bpm / (float)max_heart_rate) * 100; // updates current percentage
  draw_curr_bpm_circle();
  update_analytics();
}


// Updates stress status, activity time, oxygen level %, avg bpm, and resting bpm
void update_analytics(){

   //Draws stress status
   push(); 
   PFont stress_font = createFont("Helvetica", 22);
   textFont(stress_font);
   fill(0,0,0);
   if(zone_percentage < 90){
     text("NOT STRESSED", 515, 175);
   }
   else{
     text("STRESSED", 515, 175);     
   }
   pop();

   PFont num_font = createFont("Helvetica", 35); 
   //Draws activity time
   push(); 
   textAlign(RIGHT);
   textFont(num_font);
   if (activity_time_start == 0){
     text("0s", 510, 275);     
   }
   else{
     text((millis() - activity_time_start) / 1000 + "s", 510, 275);
   }
   pop();
   
   //Draws resting bpm
   push(); 
   textAlign(RIGHT);
   textFont(num_font);
   fill(0,0,0);
   text(resting_bpm, 655, 430);
   pop();
   
   
   //Draws oxygen level
   push(); 
   textAlign(RIGHT);
   textFont(num_font);
   text(oxygen_level + "%", 660, 275);
   pop();
   
   //Draws avg bpm
   push(); 
   textAlign(RIGHT);
   textFont(num_font);
   fill(0,0,0);
   text(avg_bpm, 495, 430);
   pop();
   
   PFont secs_font = createFont("Helvetica", 10);
   
   //Draws confidence level secs
   push(); 
   textFont(secs_font);
   text(confidence, 610, 312);
   pop();
   
   //Draws red secs
   push(); 
   textAlign(RIGHT);
   textFont(secs_font);
   fill(0,0,0);
   text(red_secs + " secs", 198, 538);
   pop();
   
   //Draws yellow secs
   push(); 
   textAlign(RIGHT);
   textFont(secs_font);
   fill(0,0,0);
   text(yellow_secs + " secs", 298, 538);
   pop();
   
   //Draws green secs
   push(); 
   textAlign(RIGHT);
   textFont(secs_font);
   fill(0,0,0);
   text(green_secs + " secs", 420, 538);
   pop();
   
   //Draws blue secs
   push(); 
   textAlign(RIGHT);
   textFont(secs_font);
   fill(0,0,0);
   text(blue_secs + " secs", 530, 538);
   pop();
   
   //Draws gray secs
   push(); 
   textAlign(RIGHT);
   textFont(secs_font);
   fill(0,0,0);
   text(gray_secs + " secs", 650, 538);
   pop();
}

// Updates the current bpm circle
void draw_curr_bpm_circle(){   
  curr_time = ((millis() - activity_time_start) / 1000) - prev_secs;
  
  if (activity_time_start == 0){
    curr_time = 0;
  }
  
  //Draws bpm circle according to curr bpm zone
  if (zone_percentage >= 90){// red zone
    red_secs += curr_time;
    push(); 
    noStroke();
    fill(255,195,195);
    ellipse(200,300,300, 300); 
    pop();
    
    push(); 
    noStroke();
    fill(232,44,44);
    ellipse(200,300,210, 210); 
    pop();  
  }
  else if (zone_percentage >= 80){  //yellow zone
    yellow_secs += curr_time;
    push(); 
    noStroke();
    fill(255,231,188);
    ellipse(200,300,300, 300); 
    pop();
    
    push(); 
    noStroke();
    fill(255,209,72);
    ellipse(200,300,210, 210); 
    pop();
  }
  else if (zone_percentage >= 70){  //green zone
    green_secs += curr_time;
    push(); 
    noStroke();
    fill(216,252,166);
    ellipse(200,300,300, 300); 
    pop();
    
    push(); 
    noStroke();
    fill(107,195,85);
    ellipse(200,300,210, 210); 
    pop();
  }
  else if (zone_percentage >= 60){  //blue zone
    blue_secs += curr_time;
    push(); 
    noStroke();
    fill(198,233,246);
    ellipse(200,300,300, 300); 
    pop();
    
    push(); 
    noStroke();
    fill(62,181,224);
    ellipse(200,300,210, 210); 
    pop();
  }
  else{
    gray_secs += curr_time;
    push(); 
    noStroke();
    fill(221,221,221);
    ellipse(200,300,300, 300); 
    pop();
    
    push(); 
    noStroke();
    fill(151,151,151);
    ellipse(200,300,210, 210); 
    pop();
  }
  prev_secs += curr_time;
  
  //Draws white circle of the bpm circle
  curr_bpm_img.resize(150, 150); 
  image(curr_bpm_img, 200, 300); 
  
   //Draws current bpm number
   push(); 
   textAlign(RIGHT);
   PFont curr_bpm_font = createFont("Helvetica", 60);
   textFont(curr_bpm_font);
   fill(0,0,0);
   text((int)curr_bpm, 230, 330);
   pop();
}

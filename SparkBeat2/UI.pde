/* ---------------------------------------------------------------------------------------------------------
BME/CS 479 Spring 2025 - Lab 1
Prof. Hananeh Esmailbeigi

Project: SparkBeat - Smart Heartrate and Blood Oxygenation Wristband
Description: This project uses the FireBeetle Board-328P with BLE4.1 x 2, FireBeetle Proto Board, AD8232 Heart Monitor, 
              ECG Leads and Snap-On ECG electrodes, and Force Sensitive Resistors (FSR) to collect clean ECG signals 
              from the patients heart and measure respiratory rate through analyzing resistance changes when the patient 
              exhales and inhales.

Authors: Kegan Jones, Rohan Kakarlapudi, Sufyan Siddiqui, Cindy Nakhammouane

Date: March 11, 2025

Acknowledgements:
- Suggestions and debugging guidance provided by ChatGPT (OpenAI)

References: 
- https://processing.org/reference/libraries/serial/index.html
- https://www.gicentre.net/utils
-----------------------------------------------------------------------------------------------------------*/


PImage background_img;
PImage background_img_med;
PImage background_img_fit;
PImage curr_bpm_img; 
PImage curr_resp_img;
PImage main_menu_img;
PImage leave_fitness_img;
PImage leave_med_img;
PImage leave_stress_img;

double curr_bpm = 0;
float prev_bpm = 0;
float curr_resp = 0;
float curr_resp2 = 0;
float curr_ecg = 0;
int oxygen_level = 0;
int confidence = 0;
int avg_bpm = 0; 
int inhalation = 0;
int exhalation = 0;
int resting_bpm = 0; 
int resting_resp = 0;
int age = 20; 
int max_heart_rate = 220 - age;
double zone_percentage = (curr_bpm / max_heart_rate) * 100;

String ageInput = "20";
boolean isFocused = false;
int ageBoxX = 360, ageBoxY = 210, ageBoxW = 180, ageBoxH = 40;
int fitBoxX = 230, fitBoxY = 325, fitBoxW = 300, fitBoxH = 120;
int stressBoxX = 230, stressBoxY = 500, stressBoxW = 300, stressBoxH = 120;
int medBoxX = 230, medBoxY = 675, medBoxW = 300, medBoxH = 120; 
int returnBoxX = 560, returnBoxY = 35, returnBoxW = 180, returnBoxH = 70;
String currMode = "mainMenu"; // mainMenu, fitness, stress, meditation


void setup(){
  Serial set up
  String portName = Serial.list()[0]; 
  //be sure to select the correct port that you have in your laptop 
  println(Serial.list());
  println(portName);
  
  myPort = new Serial(this, portName, 115200);
  myPort.bufferUntil('\n');
  
  println("Hello from setup");
  surface.setTitle("SparkBeat");
  size(768, 1025); 
}


void draw(){
  imageMode(CENTER); 

  // Decides which backgrounds to draw
  if (currMode == "mainMenu" ){
    background(220);
    main_menu_img = loadImage("MainMenu.png");
    main_menu_img.resize(768, 1025);
    image(main_menu_img,.5*width,.5*height); 
    drawMenuButtons();
    //bgDrawn = true;
  }
  else if (currMode != "mainMenu"){
      background(220);
      
    drawBase();
    drawReturnButton();
    draw_curr_resp_rate();
    draw_curr_bpm_circle();
    translate(30, 230);
    drawBPMGraph();
    translate(0, 230);

    if(currMode == "fitness"){
        drawECGGraph();
    }
    else{
      drawRespGraph();
    }
    translate(-30, -460);
    updateFitAnalytics();
  }
}


//Draws main menu buttons
void drawMenuButtons(){
  // Draw the age input textbox
  noStroke();
  fill(isFocused ? color(255,244,201) : 200); // Highlight when active
  rect(ageBoxX, ageBoxY, ageBoxW, ageBoxH);
  fill(0);
  textSize(20);
  text(ageInput, ageBoxX + 5, ageBoxY + 25);
  
  //Draws mode buttons
  fill(0,0,0,0);
  rect(fitBoxX, fitBoxY, fitBoxW, fitBoxH);
  rect(stressBoxX, stressBoxY, stressBoxW, stressBoxH);
  rect(medBoxX, medBoxY, medBoxW, medBoxH);
}

void drawReturnButton(){
    if(currMode == "fitness"){
        leave_fitness_img = loadImage("leaveFitness.png");
        leave_fitness_img.resize(180, 70); 
        image(leave_fitness_img,655,70);
    }
    else if (currMode == "stress"){
      leave_stress_img = loadImage("leaveStress.png");
      leave_stress_img.resize(180, 70); 
      image(leave_stress_img,655,70);
    }
    else if(currMode == "meditation"){
      leave_med_img = loadImage("leaveMeditation.png");
      leave_med_img.resize(185, 70); 
      image(leave_med_img,660,70);
    }
    noStroke();
    fill(0,0,0,0);
    rect(returnBoxX, returnBoxY, returnBoxW, returnBoxH); //draws back button 
}

// Main Menu click events
void mousePressed() {
  if (currMode == "mainMenu"){
    if (mouseX > ageBoxX && mouseX < ageBoxX + ageBoxW && // Detect clicks inside the age input textbox
        mouseY > ageBoxY && mouseY < ageBoxY + ageBoxH) {
      isFocused = true;
    } else {
      isFocused = false;
    }
    if (mouseX > fitBoxX && mouseX < fitBoxX + fitBoxW && // User chose fitness mode
        mouseY > fitBoxY && mouseY < fitBoxY + fitBoxH) {
          currMode = "fitness";
        }
    else if (mouseX > stressBoxX && mouseX < stressBoxX + stressBoxW && // User chose stress mode
        mouseY > stressBoxY && mouseY < stressBoxY + stressBoxH){
      currMode = "stress";

    }
    else if (mouseX > medBoxX && mouseX < medBoxX + medBoxW && // User chose meditation mode
        mouseY > medBoxY && mouseY < medBoxY + medBoxH){
      currMode = "meditation";
    }
  }
  else{
    if (mouseX > returnBoxX && mouseX < returnBoxX + returnBoxW && // Detect clicks inside the age input textbox
        mouseY > returnBoxY && mouseY < returnBoxY + returnBoxH) {
        currMode = "mainMenu";
    }
  }
}

// Capture keyboard input fro age input
void keyPressed() {
  if (isFocused) {
    if (key == BACKSPACE && ageInput.length() > 0) {
      ageInput = ageInput.substring(0, ageInput.length() - 1);
    } else if (key == ENTER || key == RETURN) {
      println("Entered text: " + ageInput); // Retrieve the input text
      isFocused = false; // Optionally, unfocus after pressing Enter
    } else if (key != CODED) {
      ageInput += key;
      age =  int(ageInput);
      max_heart_rate = 220 - age;
    }
  }
}


//User's fitness data should update in realtime, zone times are recorded, avg bpm is updates, oxygen levels updated
void drawBase(){
  
  if(currMode == "meditation"){
    background_img_med = loadImage("bg_med.png");
    background_img_med.resize(768, 1025);
    image(background_img_med,.5*width,.5*height);  
  }
  else if (currMode == "fitness"){
    background_img_fit = loadImage("bg_fit.png");
    background_img_fit.resize(768, 1025);
    image(background_img_fit,.5*width,.5*height);  
  }
  else{
    background_img = loadImage("bg.png"); 
    background_img.resize(768, 1025); 
    image(background_img,.5*width,.5*height); 
  }
  
  curr_bpm_img = loadImage("curr_bpm_circle.png");
  curr_resp_img = loadImage("currResp.png");
  zone_percentage = ((float)curr_bpm / (float)max_heart_rate) * 100; // updates current percentage
}



// Updates stress status, activity time, oxygen level %, avg bpm, and resting bpm
void updateFitAnalytics(){

   //Draws stress status
   if(currMode == "stress"){
     push(); 
     PFont stress_font = createFont("Helvetica", 18);
     textFont(stress_font);
     fill(0,0,0);
     text("FEELING:", 480, 185);
     if(zone_percentage >= 20 && curr_resp2 >= 20){
       text("STRESSED", 570, 185);
     }
     else{
       text("NOT STRESSED", 570, 185);     
     }
     pop();
   }
   
   else if(currMode == "meditation"){
     push(); 
     PFont stress_font = createFont("Helvetica", 18);
     textFont(stress_font);
     fill(0,0,0);
     text("BREATHING:", 490, 185);
     
     if(inhalation <= exhalation/3.0){
       text("STEADY", 605, 185);
     }
     else{   
       text("TOO FAST", 605, 185);
     }
     pop();
   }
   
   PFont num_font = createFont("Helvetica", 25); 
   
   //Draws resting bpm
   push(); 
   textAlign(RIGHT);
   textFont(num_font);
   fill(0,0,0);
   text(resting_bpm, 720, 595);
   pop();
   
    //Draws resting resp rate
   push(); 
   textAlign(RIGHT);
   textFont(num_font);
   fill(0,0,0);
   text(resting_resp, 720, 820);
   pop();
   
   if(currMode != "stress"){//Draws the exhalation and Inhalation
   push(); 
   textAlign(RIGHT);
   textFont(num_font);
   fill(0,0,0);
   text(inhalation, 720, 870);
   pop();
   
   push(); 
   textAlign(RIGHT);
   textFont(num_font);
   fill(0,0,0);
   text(exhalation, 720, 920);
   pop();
   }
}


// Updates the current resp rate square
void draw_curr_resp_rate(){
  // Draw a rounded square
  push();
    if (curr_resp2 >= 60){//Changes square color to red if the breathing is too high
         fill(255,195,195);//red square
         noStroke();
        rect(440, 150, 300, 300, 20); // A 100x100 square with rounded corners (radius 20)
        fill(232,44,44);
        rect(485,195,210, 210, 20); 
    }
    else{
      fill(221,221,221);//grey square
      noStroke();
      rect(440, 150, 300, 300, 20); // A 100x100 square with rounded corners (radius 20)
      fill(151,151,151);
      rect(485,195,210, 210, 20); 
    }
    pop(); 
  
   //Draws white square of the resp rate square
   curr_resp_img.resize(150, 150); 
   image(curr_resp_img, 590, 300); 
   push(); 
   textAlign(RIGHT);
   PFont curr_bpm_font = createFont("Helvetica", 60);
   textFont(curr_bpm_font);
   fill(0,0,0);
   text((int)curr_resp2, 640, 340);
   pop(); 
}

// Updates the current bpm circle
void draw_curr_bpm_circle(){   
  //Draws bpm circle according to curr bpm zone
  if (zone_percentage >= 90){// red zone
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
  else if (zone_percentage >= 32.5){  //blue zone
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
  
  //Draws white circle of the bpm circle
  curr_bpm_img.resize(150, 150); 
  image(curr_bpm_img, 200, 300); 
  
   //Draws curr bpm number
   push(); 
   textAlign(RIGHT);
   PFont curr_bpm_font = createFont("Helvetica", 60);
   textFont(curr_bpm_font);
   fill(0,0,0);
   text((int)curr_bpm, 230, 330);
   pop();
}

XYChart graph;
XYChart graphR;
XYChart graphECG;
XYChart CB_testLineChart;
XYChart testLineSIGNChart;

FloatList xPoints;
FloatList yPoints;
FloatList xPointsR;
FloatList yPointsR;
FloatList xPointsECG;
FloatList yPointsECG;
int graphWidth = 350;
int graphHeight = 125;
int translatePointX = 100;
int translatePointY = 100;
color prevColor;
color[] myColors = new color[100];
int[] colorTime = new int[100];



void setupBPMGraph() {
    graph = new XYChart(this);

    // create float lists to store the x and y points
    xPoints = new FloatList();
    yPoints = new FloatList();

    // Set the range of values to display
    graph.setMinY(0);
    graph.setMaxY(max_heart_rate);

    graph.setMinX(0);
    graph.setMaxX(200);
    
    // Styling the chart:
    graph.showXAxis(true); // shows numbers on the x/y axis
    graph.showYAxis(true);

    graph.setLineColour(color(255, 0, 0));
    graph.setPointSize(10); // set the size of the points
    graph.setLineWidth(3); // set the width of the line
}

void setupRespGraph() {
    graphR = new XYChart(this);

    // create float lists to store the x and y points
    xPointsR = new FloatList();
    yPointsR = new FloatList();


    // Set the range of values to display
    graphR.setMinY(0);
    graphR.setMaxY(800);

    graphR.setMinX(0);
    graphR.setMaxX(200);
    
    // Styling the chart:
    graphR.showXAxis(true); // shows numbers on the x/y axis
    graphR.showYAxis(true);

    graphR.setLineColour(color(255, 0, 0));
    graphR.setPointSize(10); // set the size of the points
    graphR.setLineWidth(3); // set the width of the line
    
   
}

void setupECGGraph() {
    graphECG = new XYChart(this);

    // create float lists to store the x and y points
    xPointsECG = new FloatList();
    yPointsECG = new FloatList();

    // Set the range of values to display
    graphECG.setMinY(200);
    graphECG.setMaxY(1000);

    graphECG.setMinX(0);
    graphECG.setMaxX(200);
    
    // Styling the chart:
    graphECG.showXAxis(true); // shows numbers on the x/y axis
    graphECG.showYAxis(true);

    graphECG.setLineColour(color(255, 0, 0));
    graphECG.setPointSize(10); // set the size of the points
    graphECG.setLineWidth(3); // set the width of the line
}

void drawBPMGraph() {
    pushMatrix();
    PFont chartFont = createFont("Helvetica", 16);
    textFont(chartFont);

    translate(50, 350); // Move origin to the top-left corner of the box

    float maxVisibleTime = 200;  // Set max x-range for scrolling effect
    if (xPoints.size() > 0) {
        float latestTime = xPoints.get(xPoints.size() - 1);
        graph.setMinX(latestTime - maxVisibleTime);
        graph.setMaxX(latestTime);
    }
    graph.setLineColour(color(0)); // Set the graph line color to black
    graph.setPointSize(10);
    graph.setLineWidth(3);

    graph.draw(0, 0, graphWidth, graphHeight); // Draw the chart
    
    popMatrix();
    drawPointsAndLines();
}


void drawRespGraph() {
    pushMatrix();
    PFont chartFont = createFont("Helvetica", 16);
    textFont(chartFont);
    translate(50, 350); // Move origin to the top-left corner of the box
    float maxVisibleTime = 200;  // Set max x-range for scrolling effect
    
    if (xPointsR.size() > 0) {
        float latestTime = xPointsR.get(xPointsR.size() - 1);
        graphR.setMinX(latestTime - maxVisibleTime);
        graphR.setMaxX(latestTime);
    }
    graphR.setLineColour(color(0));
    graphR.setPointSize(10);
    graphR.setLineWidth(3);

    graphR.draw(0, 0, graphWidth, graphHeight); 
    
    popMatrix();
    drawPointsAndLinesR();
}

void drawECGGraph() {
    pushMatrix();
    PFont chartFont = createFont("Helvetica", 16);
    textFont(chartFont);

    translate(50, 350); // Move origin to the top-left corner of the box

    float maxVisibleTime = 200;  // Set max x-range for scrolling effect
    if (xPointsECG.size() > 0) {
        float latestTime = xPointsECG.get(xPointsECG.size() - 1);
        graphECG.setMinX(latestTime - maxVisibleTime);
        graphECG.setMaxX(latestTime);
    }
    graphECG.setLineColour(color(0));
    graphECG.setPointSize(10);
    graphECG.setLineWidth(3);

    graphECG.draw(0, 0, graphWidth, graphHeight); 
    
    popMatrix();
    drawPointsAndLinesECG();
}


 float maxVisibleTime = 200;
 float minVisibleTime = 0;
 float shiftNumX = 0;
void addPointToGraph(double time, double bpm) {
    xPoints.append((float) time);// 2 is to increase gap between points
    yPoints.append((float)bpm);

     // Time range to display
    shiftNumX = xPoints.get(xPoints.size() - 1) - 200;
    minVisibleTime = shiftNumX;
   
    if (time > maxVisibleTime) {
      // Remove old points that are now off-screen
        while (xPoints.size() > 0 && xPoints.get(0) < minVisibleTime) {
            xPoints.remove(0);
            yPoints.remove(0);
        }        
    maxVisibleTime = xPoints.get(xPoints.size() - 1);
    }
}

 float maxVisibleTimeR = 200;
 float minVisibleTimeR = 0;
 float shiftNumXR = 0;

void addPointToGraphR(double time, double resp) {
    xPointsR.append((float) time);// 2 is to increase gap between points
    yPointsR.append((float)resp);

     // Time range to display
    shiftNumXR = xPointsR.get(xPointsR.size() - 1) - 200;
    minVisibleTimeR = shiftNumXR;
   
    if (time > maxVisibleTimeR) {
      // Remove old points that are now off-screen
        while (xPointsR.size() > 0 && xPointsR.get(0) < minVisibleTimeR) {
            xPointsR.remove(0);
            yPointsR.remove(0);
        }
    maxVisibleTimeR = xPointsR.get(xPointsR.size() - 1);
    }
}



 float maxVisibleTimeECG = 200;
 float minVisibleTimeECG = 0;
 float shiftNumXECG = 0;
// FUNCTION 3 --> SERIAL
void addPointToGraphECG(double time, double ecg) {
    xPointsECG.append((float) time);// 2 is to increase gap between points
    yPointsECG.append((float)ecg);

     // Time range to display
    shiftNumXECG = xPointsECG.get(xPointsECG.size() - 1) - 200;
    minVisibleTimeECG = shiftNumXECG;
   
    if (time > maxVisibleTimeECG) {
      // Remove old points that are now off-screen
        while (xPointsECG.size() > 0 && xPointsECG.get(0) < minVisibleTimeECG) {
            //println("REMOVED: " + +xPointsECG.get(0) + " " + yPointsECG.get(0));
            xPointsECG.remove(0);
            yPointsECG.remove(0);
        }
        
    maxVisibleTimeECG = xPointsECG.get(xPointsECG.size() - 1);
    //println("Min time: " + minVisibleTimeECG + "    " + "Max Time: " + maxVisibleTimeECG);
    //println(xPointsECG);
    }
}

//Draws the heart rate over time points and line segments
void drawPointsAndLines(){
  // Draws line segments
    for(int i = 0; i < xPoints.size(); i++){
        if (i > 0) {
            float x = xPoints.get(i);
            float y = yPoints.get(i);
            float prevX = xPoints.get(i - 1);
            float prevY = yPoints.get(i - 1);
            float prevZone = (yPoints.get(i - 1) / max_heart_rate) * 100;
            
            int lineColor;
            if (prevZone >= 90) {
                lineColor = color(255, 0, 0);
                //println("RED Prev Zone %: " + prevZone);
            } else if (prevZone >= 80) {
                lineColor = color(255,209,72);
                //println("YELLOW Prev Zone %: " + prevZone);
            } else if (prevZone >= 70) {
                //println("GREEN Prev Zone %: " + prevZone);
                lineColor = color(107,195,8);
            } else if (prevZone >= 60) {
                //println("BLUE Prev Zone %: " + prevZone);
                lineColor = color(62,181,224);
            } else {
                //println("GRAY Prev Zone %: " + prevZone);
                lineColor = color(128, 128, 128);
            }
            
            if(lineColor != prevColor){//new line is a diff zone color, document this change in the two arrays
              prevColor = lineColor;
              for(int j = 0; j < 100; j++){
                if (colorTime[j] == 0){//finds first empty space
                  colorTime[j] = int(x);
                  myColors[j] = lineColor;
                  break;
                }
              }
            }
            stroke(lineColor);
            strokeWeight(2); 
            line(prevX *(1.5) + 100 - shiftNumX*(1.55), height/2 - prevY/2 - 50, 
                  x *(1.5) + 100 - shiftNumX*(1.55), height/2 - y/2 - 50);  // Draw the line segment
        }
    }
    //Draws points on top of line segments
    for (int i = 0; i < xPoints.size(); i++) {
        float x = xPoints.get(i);
        float y = yPoints.get(i);
        float zone = (yPoints.get(i) / max_heart_rate) * 100;
        //println("Zone Percentage at i=" + i + ": " + zone + "    " + yPoints.get(i) + " " + max_heart_rate);
        

        int pointColor;
        // **Set point color based on zone**
        if (zone >= 90) {
            pointColor = color(255, 0, 0);  // RED
        } else if (zone >= 80) {
            pointColor = color(255,209,72);  // YELLOW
        } else if (zone >= 70) {
            pointColor = color(107,195,8);  // GREEN
        } else if (zone >= 32.5) {
            pointColor = color(62,181,224);  // BLUE
        } else {
            pointColor = color(128, 128, 128);  // GRAY
        }

        if(i == 0){//puts inital starting color into an array of colors so the other graphs know what color to make each segment
            prevColor = pointColor;
            myColors[0] = prevColor;
            colorTime[0] = int(x);
        }
        stroke(pointColor);
        strokeWeight(10); 
         // Draws the point
         //point(x*(1.5)+ 75 - shiftNumX*(1.55), height/2 - y/2 - 50);  // Draw the point

    }
}

//draws resp rate graph's points and line segments
void drawPointsAndLinesR(){
  // Draws line segments
    for(int i = 0; i < xPointsR.size(); i++){
        if (i > 0) {
            float x = xPointsR.get(i);
            float y = yPointsR.get(i);
            float prevX = xPointsR.get(i - 1);
            float prevY = yPointsR.get(i - 1);            

            
            //Based on the recorded time, figures ou wjat color to be based on bpm color arrays
            int prevIndex = 0;
            for(int j = 0; j < 100; j++){
              if(int(x) < colorTime[j]){
                prevIndex = j;
              }
              else{
                break;
              }
            }
            
            stroke(myColors[prevIndex]);
            strokeWeight(2); 
            line(prevX *(1.5) + 80 - shiftNumXR*(1.55), height/5 - prevY/5 +250, 
                  x *(1.5) + 80 - shiftNumXR*(1.55), height/5 - y/5 + 250);  // Draw the line segment
            //line(prevX *(1.5) + 70 - shiftNumXR*(1.55), height/2 - prevY*2.5 +50, 
            //      x *(1.5) + 70 - shiftNumXR*(1.55), height/2 - y*2.5 + 50);  // Draw the line segment
        }
    }
    //Draws points on top of line segments
    for (int i = 0; i < xPointsR.size(); i++) {
        float x = xPointsR.get(i);
        float y = yPointsR.get(i);
        
        int prevIndex = 0;
            for(int j = 0; j < 100; j++){
              if(int(x) < colorTime[j]){
                prevIndex = j;
              }
              else{
                break;
              }
            }
        stroke(myColors[prevIndex]);
        strokeWeight(10); 
        //point( x *(1.5)+ 70 - shiftNumXR*(1.55), height/5 - y/5 + 200);  // Draw the point

        //point( x *(1.5)+ 70 - shiftNumXR*(1.55), height/2 - y*2.5 + 50);  // Draw the point
    }
}


//draws resp rate graph's points and line segments
void drawPointsAndLinesECG(){
  // Draws line segments
    for(int i = 0; i < xPointsECG.size(); i++){
        if (i > 0) {
            float x = xPointsECG.get(i);
            float y = yPointsECG.get(i);
            float prevX = xPointsECG.get(i - 1);
            float prevY = yPointsECG.get(i - 1);            
        
            
            int prevIndex = 0;
            for(int j = 0; j < 100; j++){
              if(int(x) < colorTime[j]){
                prevIndex = j;
              }
              else{
                break;
              }
            }
            stroke(myColors[prevIndex]);
            
            strokeWeight(2); 
            line(prevX *(1.5)+ 100 - shiftNumXECG*(1.55), height/2 - prevY/8 - 25, 
                  x *(1.5)+ 100 - shiftNumXECG*(1.55), height/2 - y/8 - 25);  // Draw the line segment
        }
    }

}

XYChart graph;
XYChart graphLF;
XYChart graphMM;
XYChart graphHEEL;
XYChart CB_testLineChart;
XYChart testLineSIGNChart;

FloatList xPoints;
FloatList yPoints;
FloatList xPointsLF;
FloatList yPointsLF;
FloatList xPointsMM;
FloatList yPointsMM;
FloatList xPointsHEEL;
FloatList yPointsHEEL;
int graphWidth = 600;
int graphHeight = 125;
int translatePointX = 100;
int translatePointY = 100;


// Sets up MF Graph
void setupMFGraph() {
    graph = new XYChart(this);

    // create float lists to store the x and y points
    xPoints = new FloatList();
    yPoints = new FloatList();

    // Set the range of values to display
    graph.setMinY(0);
    graph.setMaxY(1);

    graph.setMinX(0);
    graph.setMaxX(1000);
    
    // Styling the chart:
    graph.showXAxis(true); // shows numbers on the x/y axis
    graph.showYAxis(true);

    graph.setLineColour(color(255, 0, 0));
    graph.setPointSize(10); // set the size of the points
    graph.setLineWidth(3); // set the width of the line
}


// Sets up LF Graph
void setupLFGraph() {
    graphLF = new XYChart(this);

    // create float lists to store the x and y points
    xPointsLF = new FloatList();
    yPointsLF = new FloatList();

    // Set the range of values to display
    graphLF.setMinY(0);
    graphLF.setMaxY(1);

    graphLF.setMinX(0);
    graphLF.setMaxX(1000);
    
    // Styling the chart:
    graphLF.showXAxis(true); // shows numbers on the x/y axis
    graphLF.showYAxis(true);

    graphLF.setLineColour(color(255, 0, 0));
    graphLF.setPointSize(10); // set the size of the points
    graphLF.setLineWidth(3); // set the width of the line
}


// Sets up MM Graph
void setupMMGraph() {
    graphMM = new XYChart(this);

    // create float lists to store the x and y points
    xPointsMM = new FloatList();
    yPointsMM = new FloatList();

    // Set the range of values to display
    graphMM.setMinY(0);
    graphMM.setMaxY(1);

    graphMM.setMinX(0);
    graphMM.setMaxX(1000);
    
    // Styling the chart:
    graphMM.showXAxis(true); // shows numbers on the x/y axis
    graphMM.showYAxis(true);

    //graphMM.setLineColour(color(255, 0, 0));
    graphMM.setPointSize(10); // set the size of the points
    graphMM.setLineWidth(3); // set the width of the line
}

// Sets up HEEL Graph
void setupHEELGraph() {
    graphHEEL = new XYChart(this);

    // create float lists to store the x and y points
    xPointsHEEL = new FloatList();
    yPointsHEEL = new FloatList();

    // Set the range of values to display
    graphHEEL.setMinY(0);
    graphHEEL.setMaxY(1);

    graphHEEL.setMinX(0);
    graphHEEL.setMaxX(1000);
    
    // Styling the chart:
    graphHEEL.showXAxis(true); // shows numbers on the x/y axis
    graphHEEL.showYAxis(true);

    graphHEEL.setLineColour(color(255, 0, 0));
    graphHEEL.setPointSize(10); // set the size of the points
    graphHEEL.setLineWidth(3); // set the width of the line
}

void drawMFGraph() {
    pushMatrix();
    PFont chartFont = createFont("Helvetica", 16);
    textFont(chartFont);

    translate(50, 350); // Move origin to the top-left corner of the box

    float maxVisibleTime = 1000;  // Set max x-range for scrolling effect
    //if (xPoints.size() > 0) {
    //    float latestTime = xPoints.get(xPoints.size() - 1);
    //    graph.setMinX(latestTime - maxVisibleTime);
    //    graph.setMaxX(latestTime);
    //}
    graph.setLineColour(color(0)); // Set the graph line color to black
    graph.setPointSize(10);
    graph.setLineWidth(3);

    graph.draw(0, 0, graphWidth, graphHeight); // Draw the chart
    
    popMatrix();
    drawMFPointsAndLines();
}

void drawLFGraph() {
    pushMatrix();
    PFont chartFont = createFont("Helvetica", 16);
    textFont(chartFont);

    translate(50, 350); // Move origin to the top-left corner of the box

    float maxVisibleTime = 1000;  // Set max x-range for scrolling effect
    //if (xPointsLF.size() > 0) {
    //    float latestTime = xPointsLF.get(xPointsLF.size() - 1);
    //    graphLF.setMinX(latestTime - maxVisibleTime);
    //    graphLF.setMaxX(latestTime);
    //}
    graphLF.setLineColour(color(0)); // Set the graph line color to black
    graphLF.setPointSize(10);
    graphLF.setLineWidth(3);

    graphLF.draw(0, 0, graphWidth, graphHeight); // Draw the chart
    
    popMatrix();
    drawLFPointsAndLines();
}


void drawMMGraph() {
    pushMatrix();
    PFont chartFont = createFont("Helvetica", 16);
    textFont(chartFont);

    translate(50, 350); // Move origin to the top-left corner of the box

    float maxVisibleTime = 1000;  // Set max x-range for scrolling effect
    //if (xPointsMM.size() > 0) {
    //    float latestTime = xPointsMM.get(xPointsMM.size() - 1);
    //    graphMM.setMinX(latestTime - maxVisibleTime);
    //    graphMM.setMaxX(latestTime);
    //}
    graphMM.setLineColour(color(0)); // Set the graph line color to black
    graphMM.setPointSize(10);
    graphMM.setLineWidth(3);

    graphMM.draw(0, 0, graphWidth, graphHeight); // Draw the chart
    
    popMatrix();
    drawMMPointsAndLines();
}

void drawHEELGraph() {
    pushMatrix();
    PFont chartFont = createFont("Helvetica", 16);
    textFont(chartFont);

    translate(50, 350); // Move origin to the top-left corner of the box

    float maxVisibleTime = 1000;  // Set max x-range for scrolling effect
    //if (xPointsHEEL.size() > 0) {
    //    float latestTime = xPointsHEEL.get(xPointsHEEL.size() - 1);
    //    graphHEEL.setMinX(latestTime - maxVisibleTime);
    //    graphHEEL.setMaxX(latestTime);
    //}
    graphHEEL.setLineColour(color(0)); // Set the graph line color to black
    graphHEEL.setPointSize(10);
    graphHEEL.setLineWidth(3);

    graphHEEL.draw(0, 0, graphWidth, graphHeight); // Draw the chart
    
    popMatrix();
    drawHEELPointsAndLines();
}

 float maxVisibleTime = 1000;
 float minVisibleTime = 0;
 float shiftNumX = 0;
void addPointToMFGraph(double time, double bpm) {
    xPoints.append((float) time);// 2 is to increase gap between points
    yPoints.append((float)bpm);

     // Time range to display
    shiftNumX = xPoints.get(xPoints.size() - 1) - 1000;
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

void addPointToLFGraph(double time, double bpm) {
    xPointsLF.append((float) time);// 2 is to increase gap between points
    yPointsLF.append((float)bpm);

     // Time range to display
    shiftNumX = xPointsLF.get(xPointsLF.size() - 1) - 1000;
    minVisibleTime = shiftNumX;
   
    if (time > maxVisibleTime) {
      // Remove old points that are now off-screen
        while (xPointsLF.size() > 0 && xPointsLF.get(0) < minVisibleTime) {
            xPointsLF.remove(0);
            yPointsLF.remove(0);
        }        
    maxVisibleTime = xPointsLF.get(xPointsLF.size() - 1);
    }
}

void addPointToMMGraph(double time, double bpm) {
    xPointsMM.append((float) time);// 2 is to increase gap between points
    yPointsMM.append((float)bpm);

     // Time range to display
    shiftNumX = xPointsMM.get(xPointsMM.size() - 1) - 1000;
    minVisibleTime = shiftNumX;
   
    if (time > maxVisibleTime) {
      // Remove old points that are now off-screen
        while (xPointsMM.size() > 0 && xPointsMM.get(0) < minVisibleTime) {
            xPointsMM.remove(0);
            yPointsMM.remove(0);
        }        
    maxVisibleTime = xPointsMM.get(xPointsMM.size() - 1);
    }
}

void addPointToHEELGraph(double time, double bpm) {
    xPointsHEEL.append((float) time);// 2 is to increase gap between points
    yPointsHEEL.append((float)bpm);

     // Time range to display
    shiftNumX = xPointsHEEL.get(xPointsHEEL.size() - 1) - 1000;
    minVisibleTime = shiftNumX;
   
    if (time > maxVisibleTime) {
      // Remove old points that are now off-screen
        while (xPointsHEEL.size() > 0 && xPointsHEEL.get(0) < minVisibleTime) {
            xPointsHEEL.remove(0);
            yPointsHEEL.remove(0);
        }        
    maxVisibleTime = xPointsHEEL.get(xPointsHEEL.size() - 1);
    }
}

//Draws the heart rate over time points and line segments
void drawMFPointsAndLines(){
  // Draws line segments
    for(int i = 0; i < xPoints.size(); i++){
        if (i > 0) {
            float x = xPoints.get(i);
            float y = yPoints.get(i);
            float prevX = xPoints.get(i - 1);
            float prevY = yPoints.get(i - 1);
         
            stroke(color(11,95,212));
            strokeWeight(1); 
            line(prevX/1.8 + 65, height/2 - prevY*100 + 10, 
                  x/1.8 + 65, height/2 - y*100 + 10); 
        }
    }
}

//Draws the heart rate over time points and line segments
void drawLFPointsAndLines(){
  // Draws line segments
    for(int i = 0; i < xPointsLF.size(); i++){
        if (i > 0) {
            float x = xPointsLF.get(i);
            float y = yPointsLF.get(i);
            float prevX = xPointsLF.get(i - 1);
            float prevY = yPointsLF.get(i - 1);
         
            stroke(color(11,95,212));
            strokeWeight(1); 
            line(prevX/1.8 + 65, height/2 - prevY*100 + 10, 
                  x/1.8 + 65, height/2 - y*100 + 10); 
        }
    }
}

//Draws the heart rate over time points and line segments
void drawMMPointsAndLines(){
  // Draws line segments
    for(int i = 0; i < xPointsMM.size(); i++){
        if (i > 0) {
            float x = xPointsMM.get(i);
            float y = yPointsMM.get(i);
            float prevX = xPointsMM.get(i - 1);
            float prevY = yPointsMM.get(i - 1);
         
            stroke(color(11,95,212));
            strokeWeight(1); 
            line(prevX/1.8 + 65, height/2 - prevY*100 + 10, 
                  x/1.8 + 65, height/2 - y*100 + 10); 
        }
    }
}

//Draws the heart rate over time points and line segments
void drawHEELPointsAndLines(){
  // Draws line segments
    for(int i = 0; i < xPointsHEEL.size(); i++){
        if (i > 0) {
            float x = xPointsHEEL.get(i);
            float y = yPointsHEEL.get(i);
            float prevX = xPointsHEEL.get(i - 1);
            float prevY = yPointsHEEL.get(i - 1);
         
            stroke(color(11,95,212));
            strokeWeight(1); 
            line(prevX/1.8 + 65, height/2 - prevY*100 + 10, 
                  x/1.8 + 65, height/2 - y*100 + 10); 
        }
    }
}

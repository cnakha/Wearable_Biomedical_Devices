XYChart graph;
XYChart CB_testLineChart;
XYChart testLineSIGNChart;

FloatList xPoints;
FloatList yPoints;

// Initializes graph
void setupGraph() {
    graph = new XYChart(this);

    // create float lists to store the x and y points
    xPoints = new FloatList();
    yPoints = new FloatList();

    // Set the range of values to display
    graph.setMinY(0);
    graph.setMaxY(max_heart_rate);

    graph.setMinX(0);
    graph.setMaxX(200);
    
    graph.showXAxis(true); // shows numbers on the x and y axes
    graph.showYAxis(true);

    graph.setLineColour(color(255, 0, 0));
    graph.setPointSize(10); 
    graph.setLineWidth(3); 
}

int graphWidth = 700;
int graphHeight = 350;
int translatePointX = 100;
int translatePointY = 100;

// Draws Heart Rate Over Time graph
void drawGraph() {
    // Translate drawing context to start chart inside the white box
    pushMatrix();
    
    PFont chartFont = createFont("Helvetica", 28);
    textFont(chartFont);

    // Move origin to the top-left corner of the box
    translate((width - graphWidth) / 2, (height - graphHeight) / 2); 

    graph.setLineColour(color(0));  // Set the graph line color to black
    graph.setPointSize(10);
    graph.setLineWidth(3);
    graph.setMaxX(200);

    // Draw the chart
    graph.draw(0, 0, graphWidth, graphHeight);

    // Draw four horizontal grid lines
    strokeWeight(1); // Thin lines
    stroke(200); // Grey color
    line(18, 102 - 78, 750, 102 - 78); 
    line(18, 102 + 78, 750, 102 + 78);
    line(18, 102 + 2 * 78, 750, 102 + 2 * 78);
    line(18, 102, 750, 102);
    
     push();
    textAlign(CENTER, CENTER);
    fill(0,0,0);
    text("Time (seconds)", graphWidth / 2, graphHeight + 40); 
    pop();
    pushMatrix();
    
    push();
    textAlign(CENTER, CENTER);
    fill(0,0,0);
    translate(-50, graphHeight / 2);
    rotate(-HALF_PI);  // Rotate text 90 degrees counterclockwise
    text("Heart Rate (BPM)", 0, 0);
    pop();
    popMatrix();
    
    popMatrix();
    drawPointsAndLines();
}

// Adds a point to the graph arrays
// double time (x coordinate)
// double bpm (y coordinate)
void addPointToGraph(double time, double bpm) {
    xPoints.append((float) time * 3);// Multiply by 3 to increase gap between points
    yPoints.append((float)bpm * 2);

    if (xPoints.size() > 100 && yPoints.size() > 100) {
        xPoints.remove(0);
        yPoints.remove(0);
    } 
}

// draws points and lines based on x and y arrays
void drawPointsAndLines(){
  // Draws line segments
    for(int i = 0; i < xPoints.size(); i++){
        if (i > 0) {
            float x = xPoints.get(i);
            float y = yPoints.get(i);
            float prevX = xPoints.get(i - 1);
            float prevY = yPoints.get(i - 1);
            float prevZone = (yPoints.get(i - 1)/2 / max_heart_rate) * 100;
            int lineColor;
            
            if (prevZone >= 90) {
                lineColor = color(255, 0, 0);
            } else if (prevZone >= 80) {
                lineColor = color(255,209,72);
            } else if (prevZone >= 70) {
                lineColor = color(107,195,8);
            } else if (prevZone >= 60) {
                lineColor = color(62,181,224);
            } else {
                lineColor = color(128, 128, 128);
            }

            stroke(lineColor);
            strokeWeight(2); 
            line(prevX + 50 , height/2 + graphHeight - 50 - prevY, 
                  x + 50, height/2 + graphHeight - 50- y);  // Draw the line segment
        }
    }
    //Draws points on top of line segments
    for (int i = 0; i < xPoints.size(); i++) {
        float x = xPoints.get(i);
        float y = yPoints.get(i);
        float zone = (yPoints.get(i)/2 / max_heart_rate) * 100;
        int pointColor;
        
        // Sets point color based on zone**
        if (zone >= 90) {
            pointColor = color(255, 0, 0);  // RED
        } else if (zone >= 80) {
            pointColor = color(255,209,72);  // ORANGE
        } else if (zone >= 70) {
            pointColor = color(107,195,8);  // GREEN
        } else if (zone >= 60) {
            pointColor = color(62,181,224);  // BLUE
        } else {
            pointColor = color(128, 128, 128);  // GRAY
        }

        stroke(pointColor);
        strokeWeight(10); 
         point(x + 50, height/2 + graphHeight - 50- y);  // Draw the point
    }
}

// Calculates average heart rate
// double bpm_to_add - newly recorded heart rate from device
void calculateAverage(double bpm_to_add){
  total_bpm += bpm_to_add;
  bpm_count += 1;
  avg_bpm = total_bpm / bpm_count;
}

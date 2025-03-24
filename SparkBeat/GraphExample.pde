
// documentation: https://processing.org/reference/libraries/serial/index.html
import processing.serial.*;

// documentation: https://www.gicentre.net/utils
import org.gicentre.utils.stat.*;

Serial myPort;
int numPoints = 0; 
int activity_time_start = 0;
boolean recievingData = false;


//Reads in output from port and updates UI values
void serialEvent(Serial myPort) {
  String tempVal = myPort.readStringUntil('\n');
 
  if (tempVal != null) {
    tempVal = trim(tempVal);
    println(tempVal); // Print full console message (for debugging)
    
    if(!recievingData){ // Interface is collecting resting heart rate
      print("Gathering resting heart rate ");
    
      if(tempVal.indexOf("Average") != -1){// Resting Heartrate = first returned Average HeartRate
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            resting_bpm = int(parts[i]);
            avg_bpm = resting_bpm;
          activity_time_start = millis();
          recievingData = true;
          println("Recieved resting heart rate: " + resting_bpm);
            break;
          }
        }
      }
    }
    else{// User has entered Fitness mode
      if(tempVal.indexOf("Heartrate:") != -1){//Heartrate
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            curr_bpm = int(parts[i]);
            addPointToGraph(curr_bpm, (millis() - activity_time_start) / 1000);   
            break;
          }
        }
      }
      else if(tempVal.indexOf("Confidence:") != -1){// Captures Confidence Percentage
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            confidence = int(parts[i]);
            break;
          }
        }
      }
      else if(tempVal.indexOf("Oxygen:") != -1){// Captures Oxygen Level
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            oxygen_level = int(parts[i]);
            break;
          }
        }
      }
        else if(tempVal.indexOf("Average") != -1){// Captures Average Heart Rate
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            avg_bpm = int(parts[i]);
            break;
          }
        }
      }
    }
  }
}

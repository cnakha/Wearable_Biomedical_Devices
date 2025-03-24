
// check website for references 
import processing.serial.*;

// documentation: https://www.gicentre.net/utils
import org.gicentre.utils.stat.*;

//Serial myPort;
int numPoints = 0; 
int activity_time_start = 0;
boolean gatheredRestingHeartRate = false;
boolean gatheredRestingRespRate = false;


//Reads in output from port and updates UI values
void serialEvent(Serial myPort) {
  String tempVal = myPort.readStringUntil('\n');//Reads line from console
 
  if (tempVal != null) {
    tempVal = trim(tempVal);
    println(tempVal); // Prints message from console (for debugging)
   

    if(!gatheredRestingHeartRate || !gatheredRestingRespRate){// when either is false, we're still gathering the resting heart rate and resp rate
    
      if(tempVal.indexOf("Resting Heart Rate:") != -1){
        String[] parts = split(tempVal, ' ');
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            resting_bpm = int(parts[i]);
            activity_time_start = millis();
            gatheredRestingHeartRate = true;
            println("Recieved resting heart rate" + resting_bpm);
            break;
          }
        }
      }
      if(tempVal.indexOf("Resting Respiratory Rate:") != -1){
        String[] parts = split(tempVal, ' ');
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            resting_resp = int(parts[i]);
            activity_time_start = millis();
            gatheredRestingRespRate = true;
            println("Recieved resting respiratory rate: " + resting_resp);
            break;
          }
        }
      }
    }
    else{// Done collecting resting bpm and resp rate
    
      if(tempVal.indexOf("Heart Rate:") != -1){// Collects Heartrate
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            prev_bpm = (float) curr_bpm;
            curr_bpm = int(parts[i]);
            addPointToGraph((millis() - activity_time_start) / 100, curr_bpm);   
            break;
          }
        }
      }
      else if(tempVal.indexOf("FSR") != -1 ){//Collects Resp rate
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            curr_resp = int(parts[i]);
            addPointToGraphR((millis() - activity_time_start) / 100, curr_resp);   
            break;
          }
        }
      }
      else if(tempVal.indexOf("Respiratory Rate") != -1 ){//Collects Resp rate
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            curr_resp2 = int(parts[i]);
            //addPointToGraphR((millis() - activity_time_start) / 100, curr_resp);   
            break;
          }
        }
      }
      else if(tempVal.indexOf("ECG Value") != -1 && currMode == "fitness"){//Collects ECG Signal rate
        String[] parts = split(tempVal, ' ');
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) {
            curr_ecg = int(parts[i]);
            addPointToGraphECG((millis() - activity_time_start) / 100, curr_ecg);   
            break;
          }
        }
      }
     else if(tempVal.indexOf("Inhale:") != -1 && currMode != "stress"){//Collects inhalation duration
        String[] parts = split(tempVal, ' ');
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) {
            inhalation = int(parts[i]);
            break;
          }
        }
      }
      else if(tempVal.indexOf("Exhale:") != -1 && currMode != "stress"){//Collects exhalation duration
        String[] parts = split(tempVal, ' ');
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) {
            exhalation = int(parts[i]);
            break;
          }
        }
      }
    }
  }
}

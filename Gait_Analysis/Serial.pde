
// check website for references 
import processing.serial.*;

// documentation: https://www.gicentre.net/utils
import org.gicentre.utils.stat.*;

Serial myPort;
int numPoints = 0; 
int activity_time_start = 0;



//Reads in output from port and updates UI values
void serialEvent(Serial myPort) {
  String tempVal = myPort.readStringUntil('\n');//Reads line from console
  //activity_time_start = millis();
  if (tempVal != null) {
    tempVal = trim(tempVal);
    println(tempVal); // Prints message from console (for debugging)
    
      if(tempVal.indexOf("mf:") != -1){// Collects MF FSR
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            mf = float(parts[i])/1000; // Keagan's values between 0 - 800ish
            //mf = float(parts[i])/1000 - 400; //Suffyans between 600 - something?
            array[1][2] = mf *1000 * 5 / 230;//make this a number between 2 and 10
            float time = (millis() - activity_time_start);
            if (time > 1000){
              time -= 1000;
            }
            addPointToMFGraph((millis() - activity_time_start) / 100, mf);   
            break;
          }
        }
      }    
      else if(tempVal.indexOf("lf:") != -1){// Collects LF FSR
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            lf = float(parts[i])/1000;// Keagan
            //lf = float(parts[i])/1000-400;//Sufyan
            array[2][3] = lf *1000 *5 / 230;//make this a number between 2 and 10
            addPointToLFGraph((millis() - activity_time_start) / 100, lf);   
            break;
          }
        }
      } 
      else if(tempVal.indexOf("mm:") != -1){// Collects MM FSR
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            mm = float(parts[i])/1000;//Kegan
            //mm = float(parts[i])/1000- 600;//Suffyan
            array[3][1] = mm * 1000 * 5 / 230;//make this a number between 2 and 10
            addPointToMMGraph((millis() - activity_time_start) / 100, mm);   
            break;
          }
        }
      }
      else if(tempVal.indexOf("heel:") != -1){// Collects heel FSR
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            heel = float(parts[i])/1000;//Kegan
            //heel = float(parts[i])/1000 - 600;//Suffyan
            array[8][2] = heel * 1000 * 5 / 230;//make this a number between 2 and 10
            addPointToHEELGraph((millis() - activity_time_start) / 100, heel);   
            break;
          }
        }
      }
      else if(tempVal.indexOf("Stride Length:") != -1){// Collects stride length
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            strideLength = float(parts[i]) / 100;
            break;
          }
        }
      }
      else if(tempVal.indexOf("Step Length:") != -1){// Collects step length
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            stepLength = float(parts[i])/100;
            break;
          }
        }
      }
      else if(tempVal.indexOf("Cadence:") != -1){// Collects cadence
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            cadence = int(parts[i]);
            break;
          }
        }
      }
      else if(tempVal.indexOf("Step Count:") != -1){// Collects number of steps
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            stepCount = int(parts[i]);
            break;
          }
        }
      }
      else if(tempVal.indexOf("MFP:") != -1){// Collects MFP
        String[] parts = split(tempVal, ' '); 
        for (int i = 0; i < parts.length; i++) {
          if (parts[i].matches("\\d+")) { 
            mfp = int(parts[i]);
            updateMFP();
            break;
          }
        }
      }
      else if(tempVal.indexOf("Status:") != -1){// Collects motion status
        status = tempVal.substring(tempVal.indexOf(":") + 2);
      }
      else if(tempVal.indexOf("GaitAlert:") != -1){// Collects motion status
        gaitAlert = tempVal.substring(tempVal.indexOf(":") + 2);
     
      }
      else if(tempVal.indexOf("Action:") != -1){// Collects motion status
        action = tempVal.substring(tempVal.indexOf(":") + 2);
      }
      else if(tempVal.indexOf("period") != -1){// Collects motion status
        period = tempVal;
      }
    }
}

// check website for references 
import processing.serial.*;

// documentation: https://www.gicentre.net/utils
import org.gicentre.utils.stat.*;

Serial myPort;



//Reads in output from port and updates UI values
void serialEvent(Serial myPort) {
   String tempVal = myPort.readStringUntil('\n');//Reads line from console
   switchPageP = false;
   swipeUpP = false;
   muteP = false;
   followP = false;
   likeP = false;
   pauseP = false;
   commentP = false;
   favoriteP = false;
   downloadP = false;
   refreshP = false;
   swipeDownP = false;
   shareP = false;
   
  if (tempVal != null) {
    tempVal = trim(tempVal);
    println(tempVal); // Prints message from console (for debugging)
  
      if(tempVal.indexOf("Switch Page") != -1){// Makes circle red if button is being pressed
          switchPageP = true;
          saveStrings("command.txt", new String[]{"cycle"});
        }
      else if(tempVal.indexOf("Swipe Up") != -1){
        swipeUpP = true;
        saveStrings("command.txt", new String[]{"swipe up"});
      }
      else if(tempVal.indexOf("Mute") != -1){
        muteP = true;
        mute = !mute;
        saveStrings("command.txt", new String[]{"mute"});
      }
      else if(tempVal.indexOf("Follow") != -1){
        followP = true;
        follow = !follow;
        saveStrings("command.txt", new String[]{"follow"});
      }
      else if(tempVal.indexOf("Like") != -1){
        likeP = true;
        like = !like;
        saveStrings("command.txt", new String[]{"like"});
      }
      else if(tempVal.indexOf("Pause") != -1){
        pauseP = true;
        pause = !pause;
        saveStrings("command.txt", new String[]{"pause"});
      }
      else if(tempVal.indexOf("Comment") != -1){
        commentP = true;
        saveStrings("command.txt", new String[]{"comment"});
      }
      else if(tempVal.indexOf("Favorite") != -1){
        favoriteP = true;
        favorite = !favorite;
        saveStrings("command.txt", new String[]{"favorite"});
      }
      else if(tempVal.indexOf("Download") != -1){
        downloadP = true;
        saveStrings("command.txt", new String[]{"download"});
      }
      else if(tempVal.indexOf("Refresh") != -1){
        refreshP = true;
        saveStrings("command.txt", new String[]{"refresh"});
      }
      else if(tempVal.indexOf("Swipe Down") != -1){
        swipeDownP = true;
        saveStrings("command.txt", new String[]{"swipe down"});
      }
      else if(tempVal.indexOf("Share") != -1){
        shareP = true;
        saveStrings("command.txt", new String[]{"share"});
      }
    }
}
  

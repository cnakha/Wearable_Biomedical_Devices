/* ---------------------------------------------------------------------------------------------------------
BME/CS 479 Spring 2025 - Lab 3
Prof. Hananeh Esmailbeigi

Project: TikTokTattoo
Description: This project creates a smart Tattoo that can control TikTok on web from your arm

Authors: Kegan Jones, Rohan Kakarlapudi, Sufyan Siddiqui, Cindy Nakhammouane

Date: March 30, 2025

Acknowledgements:
- Suggestions and debugging guidance provided by ChatGPT (OpenAI)

References: 
- https://processing.org/reference/libraries/serial/index.html
- https://www.gicentre.net/utils
-----------------------------------------------------------------------------------------------------------*/

PImage bg;
PImage base_controls;

PImage mute_unmute;
PImage follow_unfollow;
PImage like_unlike;
PImage pause_unpause;
PImage fav_unfav;

boolean TikTokOpen = false;

boolean mute = false;
boolean follow = false;
boolean like = false;
boolean pause = false;
boolean favorite = false;

boolean switchPageP = false;
boolean swipeUpP = false;
boolean muteP = false;
boolean followP = false;
boolean likeP = false;
boolean pauseP = false;
boolean commentP = false;
boolean favoriteP = false;
boolean downloadP = false;
boolean refreshP = false;
boolean swipeDownP = false;
boolean shareP = false;


void setup(){
  //Serial set up
  String portName = Serial.list()[0]; 
  //be sure to select the correct port that you have in your laptop 
  println(Serial.list());
  println(portName);
  
  myPort = new Serial(this, portName, 115200);
  myPort.bufferUntil('\n');
  
  println("Hello from setup");
  surface.setTitle("TikTok Tattoo");
  size(500, 1000); 
}


void draw(){
  background(220);
  imageMode(CENTER); 
 
  if(TikTokOpen){
    //testSwipe();
    drawControlPage();
  }
  else{
    drawLaunchPage();
  }
}


boolean testSwitch = true;

 // Opens Tiktok in Google Chrome
void mousePressed() {
 if(!TikTokOpen){
   TikTokOpen = true;
   try {
      if (System.getProperty("os.name").toLowerCase().contains("win")) {
        exec("cmd", "/c", "start chrome https://www.tiktok.com/");
      } else if (System.getProperty("os.name").toLowerCase().contains("mac")) {
        exec("open", "-a", "Google Chrome", "https://www.tiktok.com/");
      } else if (System.getProperty("os.name").toLowerCase().contains("linux")) {
        exec("google-chrome", "https://www.tiktok.com/");
      }
    } catch (Exception e) {
      println("Error launching TikTok: " + e.getMessage());
    }
 }
}

int lastTime = 0;
int intervalMillis = 5000; // 5 seconds

void testSwipe(){
 // Every 5 seconds, alternate between swipe up and down
  int currentTime = millis();
  if (currentTime - lastTime >= intervalMillis) {
    lastTime = currentTime; 
    println("hi");
    followP = !followP;
    follow = !follow;
    String command = "share";
    saveStrings("command.txt", new String[]{command});
    println("Command Sent: " + command);
  }
}

// Draws the launch/landing page that prompts user to open TikTok
void drawLaunchPage(){
    bg = loadImage("TikTok_Start.png");
    bg.resize(500, 1000);
   image(bg,.5*width,.5*height);
}

// Draws control page showing what buttons are being clicked
void drawControlPage(){
  
  bg = loadImage("TikTok_Control.png");
  bg.resize(500, 1000);
  image(bg,.5*width,.5*height);
  
  //Draws circles
  noStroke();
  if(switchPageP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(103,208,63,63); 
  
  if(swipeUpP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(253,208,63,63); 
  
  if(muteP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(412,208,63,63); 
  
  if(followP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(412,327,63,63); 
  
  if(likeP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(412,440,63,63); 
  
  if(pauseP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(253,553,63,63); 
  
  if(commentP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(412,553,63,63); 
  
  if(favoriteP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(412,666,63,63); 
  
  if(downloadP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(412,779,63,63);
  
  if(refreshP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(103,892,63,63);
  
  if(swipeDownP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(253,892,63,63);
  
  if(shareP){fill(238,60,94);}
  else{fill(31,31,31);}
  ellipse(412,892,63,63);
  
  // Draws icons
  base_controls = loadImage("Base_Controls.png");
  base_controls.resize(419, 796);
  image(base_controls,.5*width + 8,.5*height + 18);
  
  if(mute){//If mute == true, we should be seeing the unmute icon
    mute_unmute = loadImage("UnMute.png");
  }
  else{
    mute_unmute = loadImage("Mute.png");
  }
  mute_unmute.resize(105, 79);
  image(mute_unmute, 412, 185);
  
  if(follow){//If follow == true, we should be seeing the unfollow icon
    follow_unfollow = loadImage("UnFollow.png");
    follow_unfollow.resize(105, 79);
    image(follow_unfollow, 412, 307);
  }
  else{
    follow_unfollow = loadImage("Follow.png");
    follow_unfollow.resize(105, 79);
    image(follow_unfollow, 412, 310);
  }
  
  if(like){//If like == true, we should be seeing the unlike icon
    like_unlike = loadImage("UnLike.png");
  }
  else{
    like_unlike = loadImage("Like.png");
  }
  like_unlike.resize(105, 79);
  image(like_unlike, 412, 420);
  
  if(pause){//If pause == true, we should be seeing the unpause icon
    pause_unpause = loadImage("UnPause.png");
    pause_unpause.resize(105, 79);
    image(pause_unpause, 255, 533);
  }
  else{
    pause_unpause = loadImage("Pause.png");
    pause_unpause.resize(65, 86);
    image(pause_unpause, 256, 538);
  }
  
  
  if(favorite){//If pause == true, we should be seeing the unpause icon
    fav_unfav = loadImage("UnFavorite.png");
  }
  else{
    fav_unfav = loadImage("Favorite.png");
  }
  fav_unfav.resize(105, 79);
  image(fav_unfav, 412,646);
}

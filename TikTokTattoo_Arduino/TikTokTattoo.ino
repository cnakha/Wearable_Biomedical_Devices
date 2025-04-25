/* ---------------------------------------------------------------------------------------------------------
BME/CS 479 Spring 2025 - Lab 3
Prof. Hananeh Esmailbeigi

Project: TikTokTattoo
Description: This project creates a smart Tattoo that can control TikTok on web from your arm

Authors: Kegan Jones, Rohan Kakarlapudi, Sufyan Siddiqui, Cindy Nakhammouane

Date: March 30, 2025

Acknowledgements:
- Suggestions and debugging guidance provided by ChatGPT (OpenAI)
-----------------------------------------------------------------------------------------------------------*/


#include <Wire.h>
#include <Adafruit_MPR121.h>

// Create MPR121 object
Adafruit_MPR121 cap = Adafruit_MPR121();

// Array to hold the custom messages for each of the 12 electrodes (D0-D11)
const char* messages[12] = {
    "Recieved Switch Page",    // D0
    "Recieved Swipe Up",       // D1
    "Recieved Mute",           // D2
    "Recieved Follow",         // D3
    "Recieved Like",           // D4
    "Recieved Pause",          // D5
    "Recieved Comment",        // D6
    "Recieved Favorite",       // D7
    "Recieved Download",       // D8
    "Recieved Refresh",        // D9
    "Recieved Swipe Down",     // D10
    "Recieved Share"           // D11
};

void setup() {
    Serial.begin(115200);
    
    // Initialize the MPR121 sensor with default I2C address 0x5A
    if (!cap.begin(0x5A)) { 
        Serial.println("MPR121 not found, check wiring!");
        while (1);  // Halt if sensor is not found
    }
    Serial.println("MPR121 found!");
}

void loop() {
    // Read the touch state from all electrodes
    uint16_t touchState = cap.touched();
    
    // Check each of the 12 electrodes
    for (uint8_t i = 0; i < 12; i++) {
        if (touchState & (1 << i)) {
            Serial.println(messages[i]);
        }
    }
    
    delay(250); // Delay to prevent flooding the serial monitor with messages
}

/*-------------------------------------------------------------------------------------------------------------------------------------

BME/CS 479 Spring 2025 - Lab 1
Prof. Hananeh Esmailbeigi

Project: SparkBeat - Smart Heartrate and Blood Oxygenation Wristband
Description: This project uses the Sparkfun Pulse Oximeter and Heart Rate Monitor (MAX30101 & MAX32664) 
            and FIREBEETLE BOARD-32P BLE 4.1, which together allows us to measure heart rates and blood oxygen saturation (SpO2), 
            providing insights into the wearer's cardiovascular health. Data is transmitted via BLE for real-time monitoring.

Authors: Rohan Kakarlapudi, Sufyan Siddiqui, Cindy Nakhammouane

Date: February 25, 2025

Acknowledgements:
- Suggestions and debugging guidance provided by ChatGPT (OpenAI)
- Portions of the code are adapted from the official Arduino starter code available at [Arduino Project Hub](https://www.arduino.cc/en/Tutorial/HomePage) or other relevant sources.

-----------------------------------------------------------------------------------------------------------------------------------------*/

#include <SparkFun_Bio_Sensor_Hub_Library.h>
#include <Wire.h>

// Reset pin, MFIO pin, and Buzzer pin
int resPin = 4;
int mfioPin = 5;
int buzzerPin = 12;  // Buzzer pin

SparkFun_Bio_Sensor_Hub bioHub(resPin, mfioPin);
bioData body;
unsigned long lastHeartbeatTimestamp = 0;

// Array to store heart rate values
const int numReadings = 30;
int heartRates[numReadings];
int readIndex = 0;
int age = 20;  // Example age
unsigned long startTime;

void setup() {
  Serial.begin(115200);
  Wire.begin();
  pinMode(buzzerPin, OUTPUT);  // Set the buzzer pin as an output
  int result = bioHub.begin();
  if (result == 0) {
    Serial.println("Sensor started!");
  } else {
    Serial.println("Could not communicate with the sensor.");
  }
  Serial.println("Configuring Sensor....");
  int error = bioHub.configBpm(MODE_ONE);
  if (error == 0) {
    Serial.println("Sensor configured.");
  } else {
    Serial.print("Error: ");
    Serial.println(error);
  }

  // Initialize heartRates array
  for (int i = 0; i < numReadings; i++) {
    heartRates[i] = 0;
  }
 
  startTime = millis();  // Start the timing for heart rate collection
  Serial.println("\nHeart rate collection has begun.\n");
}

void loop() {
  // Collect data continuously
  if (millis() - startTime <= 30000) {  // Collect data for 30 seconds
    body = bioHub.readBpm();
    if (body.heartRate > 0) {  // Check if the reading is valid
      //Serial.println(body.heartRate);

      Serial.print("Heartrate: ");
      Serial.println(body.heartRate);
      Serial.print("Confidence: ");
      Serial.println(body.confidence);
      Serial.print("Oxygen: ");
      Serial.println(body.oxygen);

      heartRates[readIndex++] = body.heartRate;  // Store the heart rate in the array
      if (readIndex >= numReadings) {  // Prevent array overflow
        readIndex = 0;
      }
    }
  } else {
    // Calculate average resting heart rate every 30 seconds
    int sum = 0;
    int validReadings = 0;
    for (int i = 0; i < numReadings; i++) {
      if (heartRates[i] > 0) {
        sum += heartRates[i];
        validReadings++;
      }
    }
    int averageRestingRate = validReadings > 0 ? sum / validReadings : 0;
    Serial.print("Average Heart Rate: ");
    Serial.print(averageRestingRate);
    Serial.println(" BPM");
    Serial.println("Average Heart Rate: " + String(averageRestingRate));  // Send average BPM to Processing

    // Reset timer and array index for continuous operation
    startTime = millis();
    readIndex = 0;
    for (int i = 0; i < numReadings; i++) {
      heartRates[i] = 0;  // Reset the array for fresh data
    }
  }

  // Example condition to activate the buzze(r when stress is detected
  float zone_percentage = (body.heartRate / (200 - age)) * 100;
  if (50 >= 40) {  // Arbitrary condition for demonstration, modify as needed
    digitalWrite(buzzerPin, HIGH);
    delay(100);  // Buzzer on for 100 milliseconds
    digitalWrite(buzzerPin, LOW);

    delay(100);  // Buzzer on for 100 milliseconds

    digitalWrite(buzzerPin, HIGH);
    delay(100);  // Buzzer on for 100 milliseconds
    digitalWrite(buzzerPin, LOW);
    delay(1000);  // Buzzer on for 100 milliseconds

  }

  delay(1000);  // Slow down the loop to roughly once per second
}
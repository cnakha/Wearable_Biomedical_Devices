// #include <Wire.h>
// #include <MPU6050.h>
// #include <math.h>  // for sqrt

// // --- FSR Sensor Pin Definitions (Analog Inputs) ---
// #define FSR_MF_PIN A1  // Medial Forefoot (MF)
// #define FSR_LF_PIN A2  // Lateral Forefoot (LF)
// #define FSR_MM_PIN A0  // Medial Midfoot (MM)
// #define FSR_HEEL_PIN A3  // Heel

// // --- LED Pin Definitions (PWM Digital Outputs) ---
// #define LED_MF 5
// #define LED_LF 6
// #define LED_MM 2
// #define LED_HEEL 3

// // --- Calibration and Threshold Constants ---
// #define STEP_THRESHOLD 300      // Threshold for detecting a heel strike (adjust as needed)
// #define MOTION_THRESHOLD 0.2    // Threshold (in g) for accelerometer motion detection
// #define MFP_LOWER 40.0          // Lower bound for balanced medial force (%)
// #define MFP_UPPER 80.0          // Upper bound for balanced medial force (%)

// // --- Global Variables ---
// MPU6050 mpu;
// unsigned long startTime;       // For cadence calculation (Section I)
// unsigned long currentTime;

// unsigned long stepCount = 0;   // Counts steps detected using the heel sensor
// bool stepDetected = false;     // Flag to avoid multiple counts per step
// // enum StepState {
// //   WAIT_FOR_HEEL,
// //   WAIT_FOR_LF_MM,
// //   WAIT_FOR_MF
// // };
// // StepState stepState = WAIT_FOR_HEEL;
// // For accelerometer motion detection (Section III)
// bool inMotion = false;
// bool prevMotion = false;
// unsigned long motionStartTime = 0;
// unsigned long motionPeriod = 0;

// // --- Placeholders for Lab Measurements ---
// // Update these with your actual measured values.
// float measuredStepLength = 0.75; // (in meters) measured using a tape measure
// // For a simple model, stride length is assumed to be twice the step length.
// float measuredStrideLength = measuredStepLength * 2; 

// // Gait profile: 1: Normal, 2: In-toeing, 3: Out-toeing, 4: Tiptoeing, 5: Heel walking
// int gaitProfile = 1;  // Change this manually to indicate the walking profile during testing


// void setup() {
//   Serial.begin(115200);
//   while (!Serial) { ; }  // Wait for Serial port

//   // Initialize LED pins as outputs
//   pinMode(LED_MF, OUTPUT);
//   pinMode(LED_LF, OUTPUT);
//   pinMode(LED_MM, OUTPUT);
//   pinMode(LED_HEEL, OUTPUT);

//   // Initialize I2C and the MPU6050 accelerometer
//   Wire.begin();
//   mpu.initialize();
//   if (mpu.testConnection()) {
//     Serial.println("MPU6050 connection successful");
//   } else {
//     Serial.println("MPU6050 connection failed");
//   }

//   // Record the start time for cadence calculations
//   startTime = millis();
//   Serial.println("System Initialized");
  
//   // Print measured parameters with the expected tags
//   Serial.print("Step Length: ");
//   Serial.println(int(measuredStepLength * 100));
//   Serial.print("Stride Length: ");
//   Serial.println(int(measuredStrideLength * 100));
//   Serial.print("Gait Profile (1: Normal, 2: In-toeing, 3: Out-toeing, 4: Tiptoeing, 5: Heel walking): ");
//   Serial.println(gaitProfile);
// }

// void loop() {
//   // --- Section I & II: FSR Sensors & LED Control ---
//   // Read FSR sensor values (analog inputs)
//   int fsr_mf = analogRead(FSR_MF_PIN);
//   int fsr_lf = analogRead(FSR_LF_PIN);
//   int fsr_mm = analogRead(FSR_MM_PIN);
//   int fsr_heel = analogRead(FSR_HEEL_PIN);

//   // Map FSR sensor values to LED brightness (0-255)
//   int brightness_mf = map(fsr_mf, 0, 1023, 0, 255);
//   int brightness_lf = map(fsr_lf, 0, 1023, 0, 255);
//   int brightness_mm = map(fsr_mm, 0, 1023, 0, 255);
//   int brightness_heel = map(fsr_heel, 0, 1023, 0, 255);

//   // Set LED brightness (using PWM)
//   analogWrite(LED_MF, brightness_mf);
//   analogWrite(LED_LF, brightness_lf);
//   analogWrite(LED_MM, brightness_mm);
//   analogWrite(LED_HEEL, brightness_heel);

//   // Print FSR sensor readings using tags expected by Processing
//   Serial.print("mf: ");
//   Serial.println(fsr_mf);
//   Serial.print("lf: ");
//   Serial.println(fsr_lf);
//   Serial.print("mm: ");
//   Serial.println(fsr_mm);
//   Serial.print("heel: ");
//   Serial.println(fsr_heel);

//   // --- Section II: Calculate Medial Force Percentage (MFP) ---
//   // MFP = ((MM + MF) * 100) / (MM + MF + LF + HEEL + 0.001)
//   float mfp = ((float)fsr_mm + (float)fsr_mf) * 100.0 / ((float)fsr_mm + (float)fsr_mf + (float)fsr_lf + (float)fsr_heel + 0.001);
//   Serial.print("MFP: ");
//   Serial.println(int(mfp));

//   // Extra Feature (Section IV): Gait Imbalance Alert
//   if(mfp > MFP_UPPER) {
//     Serial.println("GaitAlert: Overpronation");   // Tag for overpronation alert
//     Serial.println("Action: Increase lateral support or adjust footwear");
//   } else if(mfp < MFP_LOWER) {
//     Serial.println("GaitAlert: Supination");       // Tag for supination alert
//     Serial.println("Action: Increase medial support or adjust footwear");
//   } else {
//     Serial.println("GaitAlert: Balanced");         // Tag for balanced gait
//     Serial.println("Action: No intervention required");
//   }

//   // --- Step Detection for Step Count and Cadence (Section I) ---
//   // Simple algorithm: when the heel sensor exceeds the threshold, count a step.
//   if(fsr_heel > STEP_THRESHOLD && !stepDetected) {
//     stepDetected = true;
//     stepCount++;
//     Serial.print("Step Count: ");
//     Serial.println(stepCount);
//   }
//   if(fsr_heel < STEP_THRESHOLD && stepDetected) {
//     stepDetected = false;
//   }
// // switch(stepState) {
// //     case WAIT_FOR_HEEL:
// //       if (fsr_heel > STEP_THRESHOLD) {
// //         stepState = WAIT_FOR_LF_MM;
// //       }
// //       break;

// //     case WAIT_FOR_LF_MM:
// //       if ((fsr_lf > STEP_THRESHOLD) && (fsr_mm > STEP_THRESHOLD)) {
// //         stepState = WAIT_FOR_MF;
// //       }
// //       // Optionally: reset if the heel reading falls back too low
// //       if (fsr_heel < (STEP_THRESHOLD * 0.8)) {
// //         stepState = WAIT_FOR_HEEL;
// //       }
// //       break;

// //     case WAIT_FOR_MF:
// //       if (fsr_mf > STEP_THRESHOLD) {
// //         // A complete step has been detected with the required sequence.
// //         stepCount++;
// //         Serial.print("Step Count: ");
// //         Serial.println(stepCount);
// //         // Reset state machine for next step detection.
// //         stepState = WAIT_FOR_HEEL;
// //       }
// //       // Optionally: reset if LF or MM readings drop before MF activation.
// //       if ((fsr_lf < (STEP_THRESHOLD * 0.8)) || (fsr_mm < (STEP_THRESHOLD * 0.8))) {
// //         stepState = WAIT_FOR_HEEL;
// //       }
// //       break;
// //   }
//   // Calculate cadence (steps per minute)
//   currentTime = millis();
//   float elapsedMinutes = (currentTime - startTime) / 60000.0;
//   float cadence = (elapsedMinutes > 0) ? stepCount / elapsedMinutes : 0;
//   Serial.print("Cadence: ");
//   Serial.println(int(cadence));

//   // --- Section III: MPU-6050 Accelerometer for Motion Detection ---
//   // Read raw accelerometer data
//   int16_t ax_raw, ay_raw, az_raw;
//   mpu.getAcceleration(&ax_raw, &ay_raw, &az_raw);
//   // Convert raw data to acceleration in g's (assuming ±2g range: 16384 LSB/g)
//   float ax = ax_raw / 16384.0;
//   float ay = ay_raw / 16384.0;
//   float az = az_raw / 16384.0;

//   // Print accelerometer values (these lines are kept for debugging and will be ignored by Processing)
//   // Serial.print("Accel (g): X=");
//   // Serial.print(ax, 2);
//   // Serial.print(" Y=");
//   // Serial.print(ay, 2);
//   // Serial.print(" Z=");
//   // Serial.println(az, 2);

//   // Compute the difference from expected static acceleration (assume 1g in Z when still)
//   // float accDiff = sqrt((ax * ax) + (ay * ay) + ((az - 1.0) * (az - 1.0)));
//   // if(accDiff > MOTION_THRESHOLD) {
//   //   inMotion = true;
//   // } else {
//   //   inMotion = false;
//   // }
//   float accMag = sqrt((ax * ax) + (ay * ay) + (az * az));
//   float accDiff = fabs(accMag - 1.0);  // compare the magnitude against 1g
//   if (accDiff > MOTION_THRESHOLD) {
//     inMotion = true;
//   } else {
//     inMotion = false;
//   }
//   // Detect transitions between motion and stillness and calculate motion period
//   if(inMotion && !prevMotion) {
//     // Transition from still to in motion
//     motionStartTime = millis();
//     Serial.println("Status: In Motion");
//   }
//   if(!inMotion && prevMotion) {
//     // Transition from in motion to standing still
//     unsigned long motionEndTime = millis();
//     motionPeriod = motionEndTime - motionStartTime;
//     Serial.println("Status: Standing Still");
//     Serial.print("Last motion period (ms): ");
//     Serial.println(motionPeriod);
//   }
//   prevMotion = inMotion;

//   // --- Loop Delay ---
//   delay(50);  // Adjust delay as needed for your sampling rate
// }


#include <Wire.h>
#include <MPU6050.h>
#include <math.h>  // for sqrt

// --- FSR Sensor Pin Definitions (Analog Inputs) ---
#define FSR_MF_PIN A1  // Medial Forefoot (MF)
#define FSR_LF_PIN A2  // Lateral Forefoot (LF)
#define FSR_MM_PIN A0  // Medial Midfoot (MM)
#define FSR_HEEL_PIN A3  // Heel

// --- LED Pin Definitions (PWM Digital Outputs) ---
#define LED_MF 5
#define LED_LF 6
#define LED_MM 2
#define LED_HEEL 3

// --- Calibration and Threshold Constants ---
#define STEP_THRESHOLD 300
#define MOTION_THRESHOLD 0.2
#define MFP_LOWER 40.0
#define MFP_UPPER 80.0

// --- Global Variables ---
MPU6050 mpu;
unsigned long startTime;
unsigned long currentTime;
unsigned long stepCount = 0;
bool stepDetected = false;
bool inMotion = false;
bool prevMotion = false;
unsigned long motionStartTime = 0;
unsigned long motionPeriod = 0;
float measuredStepLength = 0.75;
float measuredStrideLength = measuredStepLength * 2;
int gaitProfile = 1;

// --- Gait Aggregation Variables (New Section IV Logic) ---
#define WINDOW_DURATION 2000
#define MAX_RECORDS 100
String gaitHistory[MAX_RECORDS];
int gaitIndex = 0;
unsigned long gaitWindowStart = 0;

void setup() {
  Serial.begin(115200);
  while (!Serial) { ; }

  pinMode(LED_MF, OUTPUT);
  pinMode(LED_LF, OUTPUT);
  pinMode(LED_MM, OUTPUT);
  pinMode(LED_HEEL, OUTPUT);

  Wire.begin();
  mpu.initialize();
  if (mpu.testConnection()) {
    Serial.println("MPU6050 connection successful");
  } else {
    Serial.println("MPU6050 connection failed");
  }

  startTime = millis();
  Serial.println("System Initialized");
  Serial.print("Step Length: ");
  Serial.println(int(measuredStepLength * 100));
  Serial.print("Stride Length: ");
  Serial.println(int(measuredStrideLength * 100));
  Serial.print("Gait Profile (1: Normal, 2: In-toeing, 3: Out-toeing, 4: Tiptoeing, 5: Heel walking): ");
  Serial.println(gaitProfile);
}

void loop() {
  int fsr_mf = analogRead(FSR_MF_PIN);
  int fsr_lf = analogRead(FSR_LF_PIN);
  int fsr_mm = analogRead(FSR_MM_PIN);
  int fsr_heel = analogRead(FSR_HEEL_PIN);

  int brightness_mf = map(fsr_mf, 0, 1023, 0, 255);
  int brightness_lf = map(fsr_lf, 0, 1023, 0, 255);
  int brightness_mm = map(fsr_mm, 0, 1023, 0, 255);
  int brightness_heel = map(fsr_heel, 0, 1023, 0, 255);

  analogWrite(LED_MF, brightness_mf);
  analogWrite(LED_LF, brightness_lf);
  analogWrite(LED_MM, brightness_mm);
  analogWrite(LED_HEEL, brightness_heel);

  Serial.print("mf: ");
  Serial.println(fsr_mf);
  Serial.print("lf: ");
  Serial.println(fsr_lf);
  Serial.print("mm: ");
  Serial.println(fsr_mm);
  Serial.print("heel: ");
  Serial.println(fsr_heel);

  float mfp = ((float)fsr_mm + (float)fsr_mf) * 100.0 / ((float)fsr_mm + (float)fsr_mf + (float)fsr_lf + (float)fsr_heel + 0.001);
  Serial.print("MFP: ");
  Serial.println(int(mfp));

  // --- Section IV: Gait Imbalance Alert with Aggregation ---
  String currentGait = "Balanced";
  if (mfp > MFP_UPPER) {
    currentGait = "Overpronation";
    Serial.println("GaitAlert: Overpronation");
    Serial.println("Action: Increase lateral support or adjust footwear");
  } else if (mfp < MFP_LOWER) {
    currentGait = "Supination";
    Serial.println("GaitAlert: Supination");
    Serial.println("Action: Increase medial support or adjust footwear");
  } else {
    currentGait = "Balanced";
    Serial.println("GaitAlert: Balanced");
    Serial.println("Action: No intervention required");
  }

  gaitHistory[gaitIndex] = currentGait;
  gaitIndex = (gaitIndex + 1) % MAX_RECORDS;

  if (gaitWindowStart == 0) {
    gaitWindowStart = millis();
  }

  if (millis() - gaitWindowStart >= WINDOW_DURATION) {
    int supCount = 0, overCount = 0, balCount = 0;
    for (int i = 0; i < MAX_RECORDS; i++) {
      if (gaitHistory[i] == "Supination") supCount++;
      else if (gaitHistory[i] == "Overpronation") overCount++;
      else balCount++;
    }

    String dominantGait = "Balanced";
    if (supCount > overCount && supCount > balCount) dominantGait = "Supination";
    else if (overCount > supCount && overCount > balCount) dominantGait = "Overpronation";

    Serial.print("Dominant Gait: ");
    Serial.println(dominantGait);

    gaitWindowStart = millis();
    gaitIndex = 0;
  }

  if(fsr_heel > STEP_THRESHOLD && !stepDetected) {
    stepDetected = true;
    stepCount++;
    Serial.print("Step Count: ");
    Serial.println(stepCount);
  }
  if(fsr_heel < STEP_THRESHOLD && stepDetected) {
    stepDetected = false;
  }

  currentTime = millis();
  float elapsedMinutes = (currentTime - startTime) / 60000.0;
  float cadence = (elapsedMinutes > 0) ? stepCount / elapsedMinutes : 0;
  Serial.print("Cadence: ");
  Serial.println(int(cadence));

  int16_t ax_raw, ay_raw, az_raw;
  mpu.getAcceleration(&ax_raw, &ay_raw, &az_raw);
  float ax = ax_raw / 16384.0;
  float ay = ay_raw / 16384.0;
  float az = az_raw / 16384.0;

  float accMag = sqrt((ax * ax) + (ay * ay) + (az * az));
  float accDiff = fabs(accMag - 1.0);
  if (accDiff > MOTION_THRESHOLD) {
    inMotion = true;
  } else {
    inMotion = false;
  }

  if(inMotion && !prevMotion) {
    motionStartTime = millis();
    Serial.println("Status: In Motion");
  }
  if(!inMotion && prevMotion) {
    unsigned long motionEndTime = millis();
    motionPeriod = motionEndTime - motionStartTime;
    Serial.println("Status: Standing Still");
    Serial.print("Last motion period (ms): ");
    Serial.println(motionPeriod);
  }
  prevMotion = inMotion;

  delay(50);
}
// #include <Wire.h>
// #include <MPU6050.h>
// #include <math.h>  // for sqrt

// // --- FSR Sensor Pin Definitions (Analog Inputs) ---
// #define FSR_MF_PIN A1  // Medial Forefoot (MF)
// #define FSR_LF_PIN A2  // Lateral Forefoot (LF)
// #define FSR_MM_PIN A0  // Medial Midfoot (MM)
// #define FSR_HEEL_PIN A3  // Heel

// // --- LED Pin Definitions (PWM Digital Outputs) ---
// #define LED_MF 5
// #define LED_LF 6
// #define LED_MM 2
// #define LED_HEEL 3

// // --- Calibration and Threshold Constants ---
// #define STEP_THRESHOLD 300      // Threshold for detecting a heel strike (adjust as needed)
// #define MOTION_THRESHOLD 0.2    // Threshold (in g) for accelerometer motion detection
// #define MFP_LOWER 40.0          // Lower bound for balanced medial force (%)
// #define MFP_UPPER 80.0          // Upper bound for balanced medial force (%)

// // --- Global Variables ---
// MPU6050 mpu;
// unsigned long startTime;       // For cadence calculation (Section I)
// unsigned long currentTime;

// unsigned long stepCount = 0;   // Counts steps detected using the heel sensor
// bool stepDetected = false;     // Flag to avoid multiple counts per step
// // enum StepState {
// //   WAIT_FOR_HEEL,
// //   WAIT_FOR_LF_MM,
// //   WAIT_FOR_MF
// // };
// // StepState stepState = WAIT_FOR_HEEL;
// // For accelerometer motion detection (Section III)
// bool inMotion = false;
// bool prevMotion = false;
// unsigned long motionStartTime = 0;
// unsigned long motionPeriod = 0;

// // --- Placeholders for Lab Measurements ---
// // Update these with your actual measured values.
// float measuredStepLength = 0.75; // (in meters) measured using a tape measure
// // For a simple model, stride length is assumed to be twice the step length.
// float measuredStrideLength = measuredStepLength * 2; 

// // Gait profile: 1: Normal, 2: In-toeing, 3: Out-toeing, 4: Tiptoeing, 5: Heel walking
// int gaitProfile = 1;  // Change this manually to indicate the walking profile during testing


// void setup() {
//   Serial.begin(115200);
//   while (!Serial) { ; }  // Wait for Serial port

//   // Initialize LED pins as outputs
//   pinMode(LED_MF, OUTPUT);
//   pinMode(LED_LF, OUTPUT);
//   pinMode(LED_MM, OUTPUT);
//   pinMode(LED_HEEL, OUTPUT);

//   // Initialize I2C and the MPU6050 accelerometer
//   Wire.begin();
//   mpu.initialize();
//   if (mpu.testConnection()) {
//     Serial.println("MPU6050 connection successful");
//   } else {
//     Serial.println("MPU6050 connection failed");
//   }

//   // Record the start time for cadence calculations
//   startTime = millis();
//   Serial.println("System Initialized");
  
//   // Print measured parameters with the expected tags
//   Serial.print("Step Length: ");
//   Serial.println(int(measuredStepLength * 100));
//   Serial.print("Stride Length: ");
//   Serial.println(int(measuredStrideLength * 100));
//   Serial.print("Gait Profile (1: Normal, 2: In-toeing, 3: Out-toeing, 4: Tiptoeing, 5: Heel walking): ");
//   Serial.println(gaitProfile);
// }

// void loop() {
//   // --- Section I & II: FSR Sensors & LED Control ---
//   // Read FSR sensor values (analog inputs)
//   int fsr_mf = analogRead(FSR_MF_PIN);
//   int fsr_lf = analogRead(FSR_LF_PIN);
//   int fsr_mm = analogRead(FSR_MM_PIN);
//   int fsr_heel = analogRead(FSR_HEEL_PIN);

//   // Map FSR sensor values to LED brightness (0-255)
//   int brightness_mf = map(fsr_mf, 0, 1023, 0, 255);
//   int brightness_lf = map(fsr_lf, 0, 1023, 0, 255);
//   int brightness_mm = map(fsr_mm, 0, 1023, 0, 255);
//   int brightness_heel = map(fsr_heel, 0, 1023, 0, 255);

//   // Set LED brightness (using PWM)
//   analogWrite(LED_MF, brightness_mf);
//   analogWrite(LED_LF, brightness_lf);
//   analogWrite(LED_MM, brightness_mm);
//   analogWrite(LED_HEEL, brightness_heel);

//   // Print FSR sensor readings using tags expected by Processing
//   Serial.print("mf: ");
//   Serial.println(fsr_mf);
//   Serial.print("lf: ");
//   Serial.println(fsr_lf);
//   Serial.print("mm: ");
//   Serial.println(fsr_mm);
//   Serial.print("heel: ");
//   Serial.println(fsr_heel);

//   // --- Section II: Calculate Medial Force Percentage (MFP) ---
//   // MFP = ((MM + MF) * 100) / (MM + MF + LF + HEEL + 0.001)
//   float mfp = ((float)fsr_mm + (float)fsr_mf) * 100.0 / ((float)fsr_mm + (float)fsr_mf + (float)fsr_lf + (float)fsr_heel + 0.001);
//   Serial.print("MFP: ");
//   Serial.println(int(mfp));

// // Extra Feature (Section IV): Gait Imbalance Alert
// if (mfp > MFP_UPPER) {
//   Serial.println("GaitAlert: Overpronation");   // Tag for overpronation alert
//   Serial.println("Action: Increase lateral support or adjust footwear");
// } else if (mfp < MFP_LOWER) {
//   Serial.println("GaitAlert: Supination");       // Tag for supination alert
//   Serial.println("Action: Increase medial support or adjust footwear");
// } else {
//   Serial.println("GaitAlert: Balanced");         // Tag for balanced gait
//   Serial.println("Action: No intervention required");
// }

// delay(5000); // Keep the message in place for 5 seconds


//   // --- Step Detection for Step Count and Cadence (Section I) ---
//   // Simple algorithm: when the heel sensor exceeds the threshold, count a step.
//   if(fsr_heel > STEP_THRESHOLD && !stepDetected) {
//     stepDetected = true;
//     stepCount++;
//     Serial.print("Step Count: ");
//     Serial.println(stepCount);
//   }
//   if(fsr_heel < STEP_THRESHOLD && stepDetected) {
//     stepDetected = false;
//   }
// // switch(stepState) {
// //     case WAIT_FOR_HEEL:
// //       if (fsr_heel > STEP_THRESHOLD) {
// //         stepState = WAIT_FOR_LF_MM;
// //       }
// //       break;

// //     case WAIT_FOR_LF_MM:
// //       if ((fsr_lf > STEP_THRESHOLD) && (fsr_mm > STEP_THRESHOLD)) {
// //         stepState = WAIT_FOR_MF;
// //       }
// //       // Optionally: reset if the heel reading falls back too low
// //       if (fsr_heel < (STEP_THRESHOLD * 0.8)) {
// //         stepState = WAIT_FOR_HEEL;
// //       }
// //       break;

// //     case WAIT_FOR_MF:
// //       if (fsr_mf > STEP_THRESHOLD) {
// //         // A complete step has been detected with the required sequence.
// //         stepCount++;
// //         Serial.print("Step Count: ");
// //         Serial.println(stepCount);
// //         // Reset state machine for next step detection.
// //         stepState = WAIT_FOR_HEEL;
// //       }
// //       // Optionally: reset if LF or MM readings drop before MF activation.
// //       if ((fsr_lf < (STEP_THRESHOLD * 0.8)) || (fsr_mm < (STEP_THRESHOLD * 0.8))) {
// //         stepState = WAIT_FOR_HEEL;
// //       }
// //       break;
// //   }
//   // Calculate cadence (steps per minute)
//   currentTime = millis();
//   float elapsedMinutes = (currentTime - startTime) / 60000.0;
//   float cadence = (elapsedMinutes > 0) ? stepCount / elapsedMinutes : 0;
//   Serial.print("Cadence: ");
//   Serial.println(int(cadence));

//   // --- Section III: MPU-6050 Accelerometer for Motion Detection ---
//   // Read raw accelerometer data
//   int16_t ax_raw, ay_raw, az_raw;
//   mpu.getAcceleration(&ax_raw, &ay_raw, &az_raw);
//   // Convert raw data to acceleration in g's (assuming ±2g range: 16384 LSB/g)
//   float ax = ax_raw / 16384.0;
//   float ay = ay_raw / 16384.0;
//   float az = az_raw / 16384.0;

//   // Print accelerometer values (these lines are kept for debugging and will be ignored by Processing)
//   // Serial.print("Accel (g): X=");
//   // Serial.print(ax, 2);
//   // Serial.print(" Y=");
//   // Serial.print(ay, 2);
//   // Serial.print(" Z=");
//   // Serial.println(az, 2);

//   // Compute the difference from expected static acceleration (assume 1g in Z when still)
//   // float accDiff = sqrt((ax * ax) + (ay * ay) + ((az - 1.0) * (az - 1.0)));
//   // if(accDiff > MOTION_THRESHOLD) {
//   //   inMotion = true;
//   // } else {
//   //   inMotion = false;
//   // }
//   float accMag = sqrt((ax * ax) + (ay * ay) + (az * az));
//   float accDiff = fabs(accMag - 1.0);  // compare the magnitude against 1g
//   if (accDiff > MOTION_THRESHOLD) {
//     inMotion = true;
//   } else {
//     inMotion = false;
//   }
//   // Detect transitions between motion and stillness and calculate motion period
//   if(inMotion && !prevMotion) {
//     // Transition from still to in motion
//     motionStartTime = millis();
//     Serial.println("Status: In Motion");
//   }
//   if(!inMotion && prevMotion) {
//     // Transition from in motion to standing still
//     unsigned long motionEndTime = millis();
//     motionPeriod = motionEndTime - motionStartTime;
//     Serial.println("Status: Standing Still");
//     Serial.print("Last motion period (ms): ");
//     Serial.println(motionPeriod);
//   }
//   prevMotion = inMotion;

//   // --- Loop Delay ---
//   delay(50);  // Adjust delay as needed for your sampling rate
// }
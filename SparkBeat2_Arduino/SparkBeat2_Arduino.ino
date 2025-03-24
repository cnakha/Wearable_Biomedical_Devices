// Wearable Technology Lab - Heart Rate and Breathing Rate Monitor
// FireBeetle Board-328P + AD8232 + FSR

// Sensor Pin Assignments
const int ECG_PIN = A0;       // ECG signal (AD8232)
const int FSR_PIN = A1;       // FSR for respiratory rate
const int LO_PLUS_PIN = 11;   // AD8232 LO+ pin
const int LO_MINUS_PIN = 10;  // AD8232 LO- pin

// Baseline Data
int baselineHeartRate = 0;
int baselineRespirationRate = 0;

// Breathing cycle tracking
bool isInhaling = false; 
unsigned long inhaleStartTime = 0;
unsigned long exhaleStartTime = 0;
int inhaleDuration = 0;  // Measured in milliseconds
int exhaleDuration = 0;  // Measured in milliseconds

// Resting rate tracking
unsigned long lastRestingCheckTime = 0; // Keeps track of last baseline update
const unsigned long RESTING_PERIOD = 30000; // 30 seconds

void setup() {
  Serial.begin(115200);
  pinMode(LO_PLUS_PIN, INPUT);
  pinMode(LO_MINUS_PIN, INPUT);

  Serial.println("System Ready.");
}

void loop() {
  if (digitalRead(LO_PLUS_PIN) == 1 || digitalRead(LO_MINUS_PIN) == 1) {
    Serial.println("Leads off! Check electrodes.");
  } else {
    // Read sensor values
    int ecgValue = analogRead(ECG_PIN);
    int fsrValue = analogRead(FSR_PIN);

    // Calculate heart rate and respiration rate
    int heartRate = calculateHeartRate(ecgValue);
    int respirationRate = calculateRespirationRate(fsrValue);

    // Measure actual inhalation and exhalation duration
    measureBreathingCycle(fsrValue);

    // Continuous Serial Printing of Sensor Data
    Serial.print("ECG Value: ");
    Serial.println(ecgValue);
    Serial.print("FSR Value: ");
    Serial.println(fsrValue);
    Serial.print("Heart Rate: ");
    Serial.println(heartRate);
    Serial.print("Respiratory Rate: ");
    Serial.println(respirationRate);
    Serial.print("Inhale: ");
    Serial.println(inhaleDuration/100); // Prints duration in milliseconds
    Serial.print("Exhale: ");
    Serial.println(exhaleDuration/100); // Prints duration in milliseconds

    // Check if 30 seconds have passed to print baseline rates
    if (millis() - lastRestingCheckTime >= RESTING_PERIOD) {
      baselineHeartRate = heartRate; // Store latest heart rate as resting rate
      baselineRespirationRate = respirationRate; // Store latest respiration rate

      Serial.print("Resting Heart Rate: ");
      Serial.println(baselineHeartRate);
      Serial.print("Resting Respiratory Rate: ");
      Serial.println(baselineRespirationRate);

      lastRestingCheckTime = millis(); // Reset timer
    }
  }
  delay(100);
}

// Heart Rate Calculation 
int calculateHeartRate(int ecgValue) {
  return ecgValue / 10; 
}

// Respiratory Rate Calculation
int calculateRespirationRate(int fsrValue) {
  return fsrValue / 10; 
}

// Measure Inhalation & Exhalation Duration
void measureBreathingCycle(int fsrValue) {
  static int lastFsrValue = 0;
  
  unsigned long currentTime = millis();
  int deltaFSR = fsrValue - lastFsrValue; 
  
  if (deltaFSR > 2) {  // Inhalation Detected
    if (!isInhaling) {
      isInhaling = true;
      inhaleStartTime = currentTime;
      if (exhaleStartTime > 0) {  // Calculate previous exhalation duration
        exhaleDuration = currentTime - exhaleStartTime; // In milliseconds
      }
    }
  } 
  else if (deltaFSR < -2) {  // Exhalation Detected
    if (isInhaling) {
      isInhaling = false;
      exhaleStartTime = currentTime;
      if (inhaleStartTime > 0) {  // Calculate previous inhalation duration
        inhaleDuration = currentTime - inhaleStartTime; // In milliseconds
      }
    }
  }
  
  lastFsrValue = fsrValue;
}




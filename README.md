# Team Members:
Cindy Nakhammouane, Kegan Jones, Rohan Kakarlapudi, Sufyan Siddiqui


# Overview
Here are my projects from BME/CS 479 - Wearables and Nearables Technology Laboratory at the University of Illinois Chicago


# Course Description: 
Students will gain practical experience designing and developing wearable and nearable devices, acquisition and processing of sensor data, designing and development
of user-friendly interfaces.


# Course Objectives: 
The course is intended to provide students with an understanding of:
+ Wearable and nearable devices
+ Wearable and nearable technology can be applied in sports, fitness, medicine, assistive devices, and rehabilitation devices.
+ User Interface design for wearable technology
+ Internet of Things


# Class Projects:
## MotionSense -  A Wearable System for Real-Time Assessment of Lower Body Form and Muscle Engagement During Exercise
<img src= "https://github.com/user-attachments/assets/08989975-2625-4bd3-992b-83c639c3b176" alt="Screenshot 1" style="width:55%;"/>


### Description 
Poor exercise form, especially during lower body workouts like squats and deadlifts, can lead to long-term injuries and chronic back issues. Without real-time feedback, subtle mistakes often go unnoticed. MotionSense addresses this by using a wearable multi-sensor system to monitor lower back posture, hamstring activation, and foot pressure, providing corrective insights to reduce injury risk and improve training effectiveness. This device is developed with:
+ MIKROE EMG Click: Placed on the hamstrings to detect electrical activity during muscle engagement.
+ Force Sensitive Resistor Sensors: Embedded into shoe insoles to measure foot pressure distribution (toe, heel, lateral, medial).
+ MPU6050 Accelerometer: Placed on the lower back to track posture and chest angulation.
+ FIREBEETLE BOARD-32P BLE 4.1: Provides Bluetooth device capabilities.
+ Rechargeable Li-ion battery
+ Tech Stack: React.js, Tailwind CSS, Node.js, Arduino IDE

### Design Criteria 
The system includes three main wearable segments:
+ Shoe Insole – for FSR sensors.
+ Thigh Strap – houses EMG sensors.
+ Waistband Clip – contains the FireBeetle board, accelerometer, and battery.


Here is the device's circuit diagram and packaging:<br/>
<img src = "https://github.com/user-attachments/assets/544583e9-12c8-4e99-b8b7-7bec19ae5471" alt="Screenshot 1" style="width:45%;"/>
<img src ="https://github.com/user-attachments/assets/06414ce9-5643-4499-9403-e0c4b231e47f" alt="Screenshot 1" style="width:25%;"/>


### Evaluation and Results
Preliminary testing using squats and lunges across multiple users showed that EMG sensors detected hamstring activation within 50 milliseconds, FSR readings distinguished balanced vs. forward-leaning postures, and accelerometers consistently tracked trunk angle. The system accurately identified poor form in 84% of misaligned trials and delivered corrective feedback based on sensor thresholds and movement patterns.




## Smart Shoe - Wearables for Motion and Gait Analysis
<img src="https://github.com/user-attachments/assets/095b406f-cceb-4d10-9c5d-06a806d8fadd" alt="Screenshot 1" style="width:55%;"/>

### Description
A wearable smart shoe insole device with force sensors and accelerometers to analyze the user’s gait. Our device informs the user which part of the foot they use more while walking and where the apply the most pressure. Example: Walking on heels, or walking on toes, or normal walking. This device is developed with:
  + MPU-6050 Accelerometer: Detects motion of the user. We use it to also calculate the period of activity.
  + Force Sensitive Resistors (FSR) sensor: Indicates which part of the foot the user applies pressure/force while walking.
  + Tech Stack: Processing, Arduino IDE

### Design Criteria
The device is worn in the shoe. It goes under the foot soles to measure the pressure applied by different parts of the foot. It balances comfort with precision, suitable for easy use in any shoe.

Here is the device's circuit diagram and packaging:<br/>
<img src="https://github.com/user-attachments/assets/a595ca67-d28c-480e-bbee-0ae97c20a9a8" alt="Screenshot 1" style="width:35%;"/>
<img src="https://github.com/user-attachments/assets/7ed38a52-a770-4733-a439-8f5685335f20" alt="Screenshot 1" style="width:35%;"/>

    
## TikTok Tattoo - Interactive Tattoos – Smart Tattoo Lab
https://github.com/user-attachments/assets/c3a58f30-1d57-401e-bc28-da38d9c11ec4

### Description
A Smart Tattoo that would allow us to control external devices like the TikTok Web with a simple swipe on your skin. This device is developed with:
  + MPR121 Breakout Board: Relies on capacitive sensor to detect touches. When a capacitive sensor (electrode) is touched, the total sensed capacitance changes. When the finger makes contact with the electrode, this shift in capacitance signals a touch event. 
  + Tech Stack: Processing, Arduino IDE
    

Here is the device's circuit diagram and packaging:<br/>
<img src="https://github.com/user-attachments/assets/5c48ec09-8f5d-4ad0-b15d-f113763b8e0b" alt="Screenshot 1" style="width:15%;"/>
<img src="https://github.com/user-attachments/assets/f231bd3a-2b54-4cb1-90c0-50ac9bf4740d" alt="Screenshot 1" style="width:15%;"/>
<img src="https://github.com/user-attachments/assets/6a349244-dd26-467e-9e06-6107a403ea06" alt="Screenshot 1" style="width:25%;"/>
<img src="https://github.com/user-attachments/assets/bdee6182-660c-4325-baba-48d7f9bf91c8" alt="Screenshot 1" style="width:25%;"/>

    
## SparkBeat 2 - Wearable Sport Band
Description: This project uses the FireBeetle Board-328P with BLE4.1 x 2, FireBeetle Proto Board, AD8232 Heart Monitor, ECG Leads and Snap-On ECG electrodes, and Force Sensitive Resistors (FSR) to collect clean ECG signals from the patient’s heart and measure respiratory rate through analyzing resistance changes when the patient exhales and inhales. This device is developed with:
  + ECG Sensors and breathing sensors
  + Fitness, Stress, and Meditation Modes
  + Tech Stack: Processing, Arduino IDE
    
Here is how the application looks as well as the circuit diagram and packaging:<br/>
<img src="https://github.com/user-attachments/assets/a19d1204-b244-4325-b628-5b830906f54a" alt="Screenshot 1" style="width:15%;"/>
<img src="https://github.com/user-attachments/assets/dacc8dc2-8087-4037-af39-3befde24f31a" alt="Screenshot 1" style="width:15%;"/>
<img src="https://github.com/user-attachments/assets/1902dacd-1269-49ce-9468-edea9500cb93" alt="Screenshot 1" style="width:30%;"/>
<img src="https://github.com/user-attachments/assets/d4a10d18-2863-48b4-912f-1851fc3605fd" alt="Screenshot 2" style="width:30%;"/>


## SparkBeat - Smart Heartrate and Blood Oxygenation Wristband
Description: This project uses the Sparkfun Pulse Oximeter and Heart Rate Monitor (MAX30101 & MAX32664) and FIREBEETLE BOARD-32P BLE 4.1, which together allows us to measure heart rates and blood oxygen saturation (SpO2), providing insights into the wearer's cardiovascular health. Data is transmitted via BLE for real-time monitoring.
  + Photoplethysmogram (PPG) Sensors
  + Stress indicative buzzer
  
Here is how the application looks when monitoring heart rate in real-time as well as the circuit diagram and packaging:
<br/> <br/>
<img src="https://github.com/user-attachments/assets/8721ab9b-11ad-45e3-8228-98d82a1915d3" alt="Screenshot 1" style="width:25%;"/>
<img src="https://github.com/user-attachments/assets/fe8f5205-c845-46c9-92b2-d71fa5799ace" alt="Screenshot 2" style="width:30%;"/>
<img src="https://github.com/user-attachments/assets/8e5eb531-5bd3-4c97-bbf1-2e0f5a0b7d59" alt="Screenshot 2" style="width:30%;"/>


# Acknowledgments
- This project was developed using insights and code suggestions from [ChatGPT by OpenAI](https://openai.com/chatgpt).
- Portions of the code are adapted from the official Arduino starter code available at [Arduino Project Hub](https://www.arduino.cc/en/Tutorial/HomePage) or other relevant sources.

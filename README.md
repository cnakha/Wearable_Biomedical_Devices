BME/CS 479 Spring 2025 - Lab 5
Prof. Hananeh Esmailbeigi

Project: MotionSense
Description: A real-time lower body motion sensing dashboard built with React and Node.js.
            Tracks live body sensor data like foot pressure, chest angle, and hamstring 
            engagement, visualized with graphs, a heatmap, and live indicators.

Authors: Kegan Jones, Rohan Kakarlapudi, Sufyan Siddiqui, Cindy Nakhammouane
Date: May 27, 2025


# Running the Project:

## Open in Terminal

### How to Start the WebSocket Server:
    cd motion-sense-server
    npm install
    node index.js

### How to Start the React UI:
    cd motion-sense-ui
    npm install
    npm start

# Tech Stack
Frontend: React + Tailwind CSS + Recharts + Heatmap.js
Backend: Node.js + ws (WebSocket)
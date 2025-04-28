const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 3001 });

console.log("WebSocket server is running on ws://localhost:3001");

wss.on('connection', (ws) => {
  console.log('Client connected');

  const sendData = () => {
    const balanceOptions = ["Balanced", "Toe Heavy", "Heel Heavy"];
    const randomBalance = balanceOptions[Math.floor(Math.random() * balanceOptions.length)];

    const data = {
      mf: Math.random() * 100,       // random between 0-100
      lf: Math.random() * 100,
      mm: Math.random() * 100,
      heel: Math.random() * 100,
      chestAngle: Math.floor(Math.random() * 180), // random between 0-180
      hamstring: Math.floor(Math.random() * 100),  // random between 0-100
      footBalance: randomBalance                  // randomly pick a string
    };
    
    ws.send(JSON.stringify(data));
  };

  const intervalId = setInterval(sendData, 1000); // Send data every second

  ws.on('close', () => {
    clearInterval(intervalId);
    console.log('Client disconnected');
  });
});

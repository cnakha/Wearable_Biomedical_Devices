// App.jsx
import React, { useState, useEffect } from 'react';

import BodyImg from "./assets/body.png"; 
import Check1Img from "./assets/checked.png"; 
import Check2Img from "./assets/unChecked.png"; 
import Check3Img from "./assets/emptyCheck.png"; 

import ClockImg from "./assets/Clock.png"; 
import HeatmapImg from "./assets/Clock.png"; 

// import LiveTimer from "./components/LiveTimer";
import TargetFields from "./components/TargetFields";
import ChestAngulation from "./components/ChestAngulation";
import HamstringChart from "./components/HamstringChart";
import Heatmap from "./components/Heatmap";
import VoltageChart from "./components/VoltageChart";

/*
TODO:
- if mid screen foot balance goes below left and center div
- node server
- Arduino + normalize values
- packaging

*/



export default function App() {

      const [liveData, setLiveData] = useState({
        mf: 100,//between 0-100
        lf: 75,
        mm: 25,
        heel: 10,
        chestAngle: 90,
        hamstring: 75,
        footBalance: "Balanced", //Can be "Balanced", "Toe Heavy", or "Heel Heavy"
      });


      useEffect(() => {
        const socket = new WebSocket('ws://localhost:3001');
    
        socket.onopen = () => {
          console.log('✅ WebSocket connected');
        };
    
        socket.onmessage = (event) => {
          const data = JSON.parse(event.data);
          setLiveData(prev => ({
            ...prev,    // keep existing fields
            ...data     // overwrite any updated fields
          }));
        };
    
        socket.onclose = () => {
          console.log('❌ WebSocket disconnected');
        };
    
        return () => socket.close();
      }, []);


      const getVoltageValue = (label) => {
        switch (label) {
          case "MF":
            return liveData.mf;
          case "LF":
            return liveData.lf;
          case "MM":
            return liveData.mm;
          case "HEEL":
            return liveData.heel;
          default:
            return 0;
        }
      };

      const [isChestCorrect, setIsChestCorrect] = useState(false);
      const [isHamstringCorrect, setIsHamstringCorrect] = useState(false);
      const [isFootBalanceCorrect, setIsFootBalanceCorrect] = useState(false);
      const [isChestActive, setIsChestActive] = useState(true);
      const [isHamstringActive, setIsHamstringActive] = useState(true);
      const [isFootBalanceActive, setIsFootBalanceActive] = useState(true);
      const [elapsedSeconds, setElapsedSeconds] = useState(0);


      useEffect(() => {
        const timer = setInterval(() => {
          setElapsedSeconds((prev) => prev + 1);
        }, 1000);
      
        return () => clearInterval(timer); // cleanup
      }, []);

      
  return (
    // Webpage
    <div className=" flex-col bg-white pb-8">
      {/* Top Bar */}
      <header className="bg-[#0B5FD4] text-white text-2xl font-bold p-4 ">MotionSense</header>
      
      {/* Below Top Bar */}
      <div className="flex justify-center">
      
        {/* Main Layout */}
        <div className="flex flex-wrap w-full justify-center">

          {/* Left + Center + Live Engagement (Top Bar 2) */}
          <div className=" pb-8">
            <header className="text-[#0B5FD4] text-3xl font-bold pt-4 pb-2 rounded-lg">Live Engagement</header>

            {/* Left + Center */}
            <div className="flex h-full max-h-[800px]">

              {/* Left Sidebar - Set Target Form */}
              <div className="flex flex-col bg-[#0B5FD4] shadow text-white rounded-2xl p-4 max-w-[920px] min-w-[420px] h-full justify-center">
                <div className=" flex-col ">
                  <h className="font-semibold text-2xl px-2">Set Target Form</h>

                  {/* Body */}
                  <div className="flex justify-center pt-6 pr-8">
                    {/* Body and Indicators */}
                    <div className="flex justify-center max-w-[300px] ">
                      <div><img src={BodyImg} alt="Human Body" className="rounded-lg " /></div>
                      <div className="flex-col space-y-8 pt-10">
                        <div>
                          <img
                            src={!isChestActive ? Check3Img : isChestCorrect ? Check1Img : Check2Img}
                            alt="Check 1"
                            className="rounded-lg" />
                        </div>
                        <div>
                          <img
                            src={!isHamstringActive ? Check3Img : isHamstringCorrect ? Check1Img : Check2Img}
                            alt="Check 2"
                            className="rounded-lg" />
                        </div>
                        <div>
                          <img
                            src={!isFootBalanceActive ? Check3Img : isFootBalanceCorrect ? Check1Img : Check2Img}
                            alt="Check 3"
                            className="rounded-lg" />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Target Fields */}
                <div className="flex items-center justify-center h-full"> 
                  <div className="flex flex-col bg-[#0B5FD4] px-4 pb-4 pt-6">
                    <div className="flex justify-center">
                      <h className="text-2xl font-semibold">Target Fields</h>
                    </div>
                    <TargetFields
                      chestAngle={45}
                      hamstring={100}
                      footBalance="Balanced"
                      liveChestAngle={liveData.chestAngle}
                      liveHamstring={liveData.hamstring}
                      liveFootBalance={liveData.footBalance}
                      isChestActive={isChestActive}
                      isHamstringActive={isHamstringActive}
                      isFootBalanceActive={isFootBalanceActive}
                      setIsChestCorrect={setIsChestCorrect}
                      setIsHamstringCorrect={setIsHamstringCorrect}
                      setIsFootBalanceCorrect={setIsFootBalanceCorrect}
                      setIsChestActive={setIsChestActive}
                      setIsHamstringActive={setIsHamstringActive}
                      setIsFootBalanceActive={setIsFootBalanceActive}
                    />
                  </div>
                </div>
              </div>


              {/* Center Section */}
              <div className="flex flex-col flex-1 h-full max-w-[400px]">
                <div className="bg-white rounded-2xl px-8 flex flex-col h-full gap-8">

                  {/* Activity Time */}
                  <div className="flex flex-col bg-blue-50 shadow border-[#0B5FD4] border-2 rounded-2xl p-4 flex-1 max-h-[140px]">
                    <h className="font-semibold text-2xl text-[#0B5FD4] px-2">Activity Time</h>
                    <div className="flex justify-center items-center flex-1">
                      <h className="font-semibold text-[#0B5FD4] text-6xl">
                        {String(Math.floor(elapsedSeconds / 60)).padStart(2, '0')}:
                        {String(elapsedSeconds % 60).padStart(2, '0')}
                      </h>
                    </div>
                  </div>

                  {/* Chest Angulation */}
                  <div className="flex flex-col bg-blue-50 shadow border-[#0B5FD4] border-2 rounded-2xl flex-1">
                    <div className="flex px-4 items-center">
                      <h2 className="text-2xl font-semibold text-[#0B5FD4] pt-4 px-2">Chest Angulation</h2>
                      <div className="min-w-[100px] text-right">
                        <h className="text-4xl font-semibold text-[#0B5FD4]">{liveData.chestAngle}°</h>
                      </div>
                    </div>
                    <div className="flex-1">
                      <ChestAngulation angle={liveData.chestAngle} />
                    </div>
                  </div>

                  {/* Hamstring Engagement */}
                  <div className="flex flex-col bg-blue-50 border-[#0B5FD4] border-2 rounded-2xl p-4 flex-1 shadow">
                    <div className="flex justify-between items-center">
                      <h2 className="text-2xl font-semibold text-[#0B5FD4] px-2">Hamstring Engagement</h2>
                      <div className="text-right min-w-[110px]">
                        <h className="text-4xl font-semibold text-[#0B5FD4]">{liveData.hamstring}%</h>
                      </div>
                    </div>
                    <div className="flex h-full items-center pt-6 pb-6">
                      <HamstringChart graphlabel={"ham"} value={liveData.hamstring} />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>


          {/* Right Sidebar */}
          <div className="pt-16 ">
            <div className="flex flex-col col-span-6 bg-white border-2 border-[#0B5FD4] rounded-2xl px-4 pr-10 py-4 pb-10 max-w-[900px] shadow">
              <h2 className="text-2xl text-[#0B5FD4] font-semibold px-2">Foot Balance</h2>

              {/* Flex layout for Heatmap + Charts */}
              <div className="flex w-full">
                {/* Heatmap - tall rectangle */}
                <div className="flex flex-col items-center ">
                  <Heatmap mf={liveData.mf} lf={liveData.lf} mm={liveData.mm} heel={liveData.heel} />
                  <div className="flex shadow bg-white border-2 border-[#0B5FD4] rounded-2xl p-2">
                    <div className="flex justify-center text-2xl text-[#0B5FD4] font-semibold min-w-[150px]">{liveData.footBalance}</div>
                  </div>
                </div>

                {/* Charts */}
                <div className="flex flex-col flex-1 bg-blue-50 border-[#0B5FD4] border-2 rounded-xl space-y-10 p-4 shadow items-center">
                  <div className="flex flex-col justify-between h-full items-center py-2">
                  {["MF", "LF", "MM", "HEEL"].map((label) => (
                    <div key={label} className="flex rounded-xl p-2 items-center">
                      <h className="font-semibold text-[#0B5FD4] text-xl w-12">{label}</h>
                      <VoltageChart graphlabel={label} value={getVoltageValue(label)} />
                    </div>
                  ))}
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>
  </div>

  );
}

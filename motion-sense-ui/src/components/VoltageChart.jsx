import React, { useEffect, useRef, useState } from "react";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Label
} from "recharts";

export default function VoltageChart({ graphlabel, value }) {
  const [data, setData] = useState([]);
  const timeRef = useRef(0);
  const valueRef = useRef(value); // store latest voltage without causing rerenders

  useEffect(() => {
    valueRef.current = value;
  }, [value]);

  useEffect(() => {
    const interval = setInterval(() => {
      timeRef.current += 1;
      setData((prev) => {
        const newPoint = { time: timeRef.current, voltage: valueRef.current };
        const updated = [...prev, newPoint];
        return updated.slice(-100); // keep last 100 points
      });
    }, 1000);

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="w-full max-w-[300px] min-w-[200px] h-28 text-[#0B5FD4] flex-shrink-0 ">

      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={data}>
          <CartesianGrid strokeDasharray="3 3" />
          
          {/* X Axis */}
          <XAxis
            dataKey="time"
            type="number"
            domain={["dataMin", "dataMax"]}
            tickFormatter={(tick) => `${tick}s`}
            tick={{ fill: "#0B5FD4", fontWeight: 600, fontSize: 12 }}
          >
            <Label
              value="Time (s)"
              offset={-5}
              position="insideBottom"
              style={{ fill: "#0B5FD4", fontWeight: 600 }}
            />
          </XAxis>

          {/* Y Axis */}
          <YAxis domain={[0, 100]}
            tick={{ fill: "#0B5FD4", fontWeight: 600, fontSize: 12 }}
          >
            <Label
              value="Voltage"
              angle={-90}
              position="insideLeft"
              offset={14}
              style={{ fill: "#0B5FD4", fontWeight: 600, textAnchor: "middle" }}
            />
          </YAxis>

          <Tooltip />
          <Line
            type="monotone"
            dataKey="voltage"
            stroke="#0B5FD4"
            strokeWidth={1}
            dot={false}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}

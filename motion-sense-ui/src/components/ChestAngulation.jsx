import React, { useEffect, useRef, useState } from "react";

export default function ChestAngulation({ angle }) {
  const radius = 100;
  const center = 125;

  const [displayAngle, setDisplayAngle] = useState(angle);
  const animationRef = useRef(null);

  // Animate to the new angle
  useEffect(() => {
    cancelAnimationFrame(animationRef.current);
    const duration = 500; // ms
    const start = performance.now();
    const initial = displayAngle;

    const animate = (now) => {
      const progress = Math.min((now - start) / duration, 1);
      const current = initial + (angle - initial) * progress;
      setDisplayAngle(current);

      if (progress < 1) {
        animationRef.current = requestAnimationFrame(animate);
      }
    };

    animationRef.current = requestAnimationFrame(animate);

    return () => cancelAnimationFrame(animationRef.current);
  }, [angle]);

  const startAngle = -90;
  const endAngle = displayAngle + startAngle;

  const polarToCartesian = (cx, cy, r, deg) => {
    const rad = (deg * Math.PI) / 180;
    return {
      x: cx + r * Math.cos(rad),
      y: cy + r * Math.sin(rad),
    };
  };

  const start = polarToCartesian(center, center, radius, startAngle);
  const end = polarToCartesian(center, center, radius, endAngle);
  const largeArcFlag = displayAngle > 180 ? 1 : 0;

  const piePath = `
    M ${center} ${center}
    L ${start.x} ${start.y}
    A ${radius} ${radius} 0 ${largeArcFlag} 1 ${end.x} ${end.y}
    Z
  `;

  return (
    <div className="flex justify-center items-center">
      <svg width="200" height="200" viewBox="120 0 250 250">
        {/* Pie Slice */}
        <path
          d={piePath}
          fill="#B9DBFF"
        />
        {/* Angle Line */}
        <line
          x1={center}
          y1={center}
          x2={end.x}
          y2={end.y}
          stroke="#0B5FD4"
          strokeWidth="6"
        />
      </svg>
    </div>

  );
}

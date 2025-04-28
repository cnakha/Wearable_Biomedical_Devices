import React, { useEffect, useRef, useState } from 'react';
import FootOverlay from '../assets/heatmap_foot.png';
import h337 from 'heatmap.js';

const Heatmap = ({ mf, lf, mm, heel }) => {
  const heatmapRef = useRef(null);
  const heatmapInstance = useRef(null);

  const [points, setPoints] = useState([
    { id: 'mf', x: 180, y: 160, value: 0 },
    { id: 'lf', x: 250, y: 220, value: 0 },
    { id: 'mm', x: 140, y: 230, value: 0 },
    { id: 'heel', x: 190, y: 490, value: 0 },
  ]);

  const targets = useRef({
    mf: mf,
    lf: lf,
    mm: mm,
    heel: heel,
  });

  // Create heatmap once
  useEffect(() => {
    if (heatmapRef.current) {
      heatmapInstance.current = h337.create({
        container: heatmapRef.current,
        radius: 70,
        maxOpacity: 1,
        minOpacity: 1,
        blur: 0.8,
        gradient: {
          0.0: '#ffffff',
          0.1: '#001eff',
          0.3: '#70f1ff',
          0.5: '#00ff00',
          0.7: '#ffff00',
          0.85: '#ffa500',
          1.0: '#ff0000',
        },
      });
    }
  }, []);

  // Whenever new live data comes, update the target values
  useEffect(() => {
    targets.current = { mf, lf, mm, heel };
  }, [mf, lf, mm, heel]);

  // Animation loop to move values toward targets smoothly
  useEffect(() => {
    const interval = setInterval(() => {
      setPoints(prevPoints => {
        const updated = prevPoints.map((p) => {
          const targetValue = targets.current[p.id];
          const newValue = p.value + (targetValue - p.value) * 0.1; // smooth approach
          return { ...p, value: newValue };
        });

        if (heatmapInstance.current) {
          heatmapInstance.current.setData({
            max: 100,
            data: updated.map(p => ({
              x: p.x,
              y: p.y,
              value: p.value,
              radius: Math.max(p.value / 1.5, 10),
            })),
          });
        }

        return updated;
      });
    }, 50);

    return () => clearInterval(interval);
  }, []);

  return (
    <div style={{ minWidth: '380px', minHeight: '650px', position: 'relative' }}>
      <div
        ref={heatmapRef}
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          width: '100%',
          height: '100%',
        }}
      />
      <img
        src={FootOverlay}
        alt="Foot Overlay"
        style={{
          position: 'absolute',
          top: 0,
          left: 0,
          width: '100%',
          maxWidth: '380px',
          height: '100%',
          maxHeight: '650px',
          pointerEvents: 'none',
        }}
      />
    </div>
  );
};

export default Heatmap;

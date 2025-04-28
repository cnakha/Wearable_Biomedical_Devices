import { useEffect, useState } from "react";
import Check1Img from "../assets/checked.png";
import UnCheck1Img from "../assets/unChecked.png";
import emptyCheck from "../assets/emptyCheck.png";

export default function TargetFields({
  chestAngle,
  hamstring,
  footBalance,
  liveChestAngle,
  liveHamstring,
  liveFootBalance,
  isChestActive,
  isHamstringActive,
  isFootBalanceActive,
  setIsChestCorrect,
  setIsHamstringCorrect,
  setIsFootBalanceCorrect,
  setIsChestActive,
  setIsHamstringActive,
  setIsFootBalanceActive
}) {
  const [targetChestAngle, setTargetChestAngle] = useState(chestAngle);
  const [targetHamstring, setTargetHamstring] = useState(hamstring);

  const balanceStates = ["Balanced", "Heel Heavy", "Toe Heavy"];
  const [currentBalanceIndex, setCurrentBalanceIndex] = useState(
    balanceStates.indexOf(footBalance) || 0
  );

  // live correctness checks
  const chestMatch = isChestActive && Math.abs(targetChestAngle - liveChestAngle) <= 5;
  const hamstringMatch = isHamstringActive && Math.abs(targetHamstring - liveHamstring) <= 5;
  const footBalanceMatch = isFootBalanceActive && balanceStates[currentBalanceIndex] === liveFootBalance;

  useEffect(() => {
    setIsChestCorrect(chestMatch);
    setIsHamstringCorrect(hamstringMatch);
    setIsFootBalanceCorrect(footBalanceMatch);
  }, [chestMatch, hamstringMatch, footBalanceMatch, setIsChestCorrect, setIsHamstringCorrect, setIsFootBalanceCorrect]);

  return (
    <div className="flex-col justify-center p-4 text-white space-y-4">
      {/* Chest Angle */}
      <div className="flex items-center justify-center gap-4">
        <button
          onClick={() => setIsChestActive((prev) => !prev)}
          className={`w-8 h-8 border-4 rounded-full transition shadow ${isChestActive ? "bg-white" : "bg-[#0B5FD4]"}`}
        ></button>
        <p className="font-semibold">Chest Angle</p>
        <input
          type="number"
          value={targetChestAngle}
          onChange={(e) => setTargetChestAngle(Number(e.target.value))}
          className="mt-1 block w-24 rounded-md border-gray-300 px-2 text-[#0B5FD4] font-semibold shadow-sm"
        />
        <img
          src={
            !isChestActive ? emptyCheck : chestMatch ? Check1Img : UnCheck1Img}
          alt="Check Status"
          className="h-6"
        />
      </div>

      {/* Hamstring Engagement */}
      <div className="flex items-center justify-center gap-4">
        <button
          onClick={() => setIsHamstringActive((prev) => !prev)}
          className={`w-8 h-8 border-4 rounded-full shadow transition ${isHamstringActive ? "bg-white" : "bg-[#0B5FD4]"}`}
        ></button>
        <div className="font-semibold">
          <p >Hamstring</p>
          <p>Engagement</p>
        </div>
        <input
          type="number"
          value={targetHamstring}
          onChange={(e) => setTargetHamstring(Number(e.target.value))}
          className="mt-1 block w-24 rounded-md border-gray-300 px-2 text-[#0B5FD4] font-semibold shadow-sm"
        />
        <img
          src={!isHamstringActive ? emptyCheck : hamstringMatch ? Check1Img : UnCheck1Img}
          alt="Check Status"
          className="h-6"
        />
      </div>

      {/* Foot Balance */}
      <div className="flex items-center justify-center gap-4">
        <button
          onClick={() => setIsFootBalanceActive((prev) => !prev)}
          className={`w-8 h-8 border-4 shadow rounded-full transition ${isFootBalanceActive ? "bg-white" : "bg-[#0B5FD4]"}`}
        ></button>
        <div className="font-semibold">
          <p>Foot Balance</p>
        </div>
        <button
          onClick={() =>
            setCurrentBalanceIndex((prev) => (prev + 1) % balanceStates.length)
          }
          className="w-24 bg-white shadow-sm text-[#0B5FD4] rounded-lg py-1 text-center font-semibold"
        >
          {balanceStates[currentBalanceIndex]}
        </button>
        <img
          src={!isFootBalanceActive ? emptyCheck : footBalanceMatch ? Check1Img : UnCheck1Img}
          alt="Check Status"
          className="h-6"
        />
      </div>
    </div>
  );
}

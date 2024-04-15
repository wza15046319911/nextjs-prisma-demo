"use client"

import Image from "next/image";
import { useState } from "react";


export default function Home() {
  const options = [];
  for (let i = 0; i < 10; i++) {
    options.push(<option key={i} value={i}>{i}</option>);
  }
  const [model, setModel] = useState<string>("");
  const [quantity, setQuantity] = useState<number>(0);
  const [licenseLevel, setLicenseLevel] = useState<number>(0);
  const [date, setDate] = useState<string>("");
  const [comment, setComment] = useState<string>("");

  const submitBatch = () => {
    const batchObject = {
      model, quantity, licenseLevel, date, comment
    }
    fetch("/api/batch", {
      method: "POST",
      body: JSON.stringify({ batch: batchObject }),
      headers: {
        "Content-Type": "application/json"
      }
    }

    ).then((response => response.json()))
  }

  return (
    <div>
      <main className="flex min-h-screen flex-col items-center justify-center border-2 border-#7a5b30 rounded-lg my-5 mx-20 ">
        <div className="w-10/12 py-5">
          <h2 className="text-3xl text-white text-left">Batch Form</h2>
        </div>
        <select className="w-10/12 bg-gray-200 border border-gray-300 rounded-md p-2 m-2" onChange={(e) => setModel(e.target.value)}>
          <option value="">Model</option>
          <option value="model1">Model 1</option>
          <option value="model2">Model 2</option>
          <option value="model3">Model 3</option>
        </select>
        <div className="flex w-10/12 items-center bg-gray-200 border border-gray-300 rounded-md p-2 m-2">
          <input placeholder="10/04/2024" className="bg-transparent flex-1" onChange={(e) => setDate(e.target.value)} />
          <Image src="/images/calendar-small.png" alt="Calendar" width={15} height={15} />
        </div>
        <input type="number" placeholder="Quantity" className="w-10/12 bg-gray-200 border border-gray-300 rounded-md p-2 m-2" onChange={(e) => setQuantity(Number.parseInt(e.target.value))} />
        <select className="w-10/12 bg-gray-200 border border-gray-300 rounded-md p-2 m-2" onChange={(e) => setLicenseLevel(Number.parseInt(e.target.value))}>
          <option value="">License Level</option>
          {options}
        </select>
        <input placeholder="Comment (Not Required)" className="w-10/12 bg-gray-200 border border-gray-300 rounded-md p-2 m-2" onChange={(e) => setComment(e.target.value)} />
        <button className="w-10/12 text-white font-bold py-2 px-4 rounded-md mt-4" onClick={submitBatch}>Submit</button>
      </main>
    </div>
  );
}

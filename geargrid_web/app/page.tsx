import Image from "next/image";

export default function Home() {
  return (
    <div className="container">
      <h1 className="text-3xl font-bold underline">Hello world!</h1>
      <Image src="/GearGrid-removebg-preview.png" alt="Vercel Logo" width={200} height={200} />
    </div>
  );
}
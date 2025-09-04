"use client";

import Login from "./auth/login/page";
// import { Button } from "@/components/ui/button";

export default function HomePage() {

  return (
    <main className="flex flex-col items-center justify-center ">
      <Login />
      {/* <h1 className="text-4xl font-bold mb-6">Welcome to MyApp</h1>
      <p className="text-lg text-gray-600 mb-8">Your one-stop e-commerce platform</p>
      <Button 
        size="lg"
        className="rounded-2xl shadow-lg"
        onClick={() => router.push("/auth/login")}
      >
        Get Started
      </Button> */}
    </main>
  );
}
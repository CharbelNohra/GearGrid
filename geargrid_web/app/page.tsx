"use client";

import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";

export default function HomePage() {
  const router = useRouter();

  return (
    <main className="flex flex-col items-center justify-center h-screen bg-gradient-to-b">
      <h1 className="text-4xl font-bold mb-6">Welcome to MyApp</h1>
      <p className="text-lg text-gray-600 mb-8">Your one-stop e-commerce platform</p>
      <Button 
        size="lg"
        className="rounded-2xl shadow-lg"
        onClick={() => router.push("/auth/login")}
      >
        Get Started
      </Button>
    </main>
  );
}
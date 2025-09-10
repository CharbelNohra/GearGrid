"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import Login from "./auth/login/page";
import { useAuth } from "@/context/AuthContext";

export default function HomePage() {
  const { isAuthenticated, isLoading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!isLoading && isAuthenticated) {
      router.replace("/dashboard");
    }
  }, [isAuthenticated, isLoading, router]);

  if (isLoading) {
    return (
      <main className="flex flex-col items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-gray-900"></div>
        <p className="mt-4">Loading...</p>
      </main>
    );
  }

  return (
    <main className="flex flex-col items-center justify-center">
      {!isAuthenticated && <Login />}
    </main>
  );
}
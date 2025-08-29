"use client";

import React, { useState } from "react";
import Image from "next/image";
import { Input } from "@/components/ui/input";
import { FiUser, FiLock, FiEye, FiEyeOff } from "react-icons/fi";
import { Button } from "@/components/ui/button";
import { useRouter } from "next/navigation";

const Login = () => {
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    
    setTimeout(() => {
      setIsLoading(false);
      router.push("/dashboard");
    }, 2000);
  };

  return (
    <div className="flex flex-col align-center items-center mt-30">
      <div>
        <Image src="/assets/svg/logo.svg" alt="Logo" width={200} height={200} />
      </div>

      <div className="text-center flex flex-col mt-4">
        <h1 className="text-2xl font-bold mb-2">Welcome back 👋</h1>
        <p className="text-muted-foreground mb-4">Log in as Administrator</p>

        <form className="flex flex-col items-center" onSubmit={handleSubmit}>
          <Input
            type="email"
            placeholder="Email"
            className="mb-4 w-80"
            required
            prefix={<FiUser className="h-5 w-5 text-muted-foreground" />}
          />

          <Input
            type={showPassword ? "text" : "password"}
            placeholder="Password"
            className="mb-4 w-80"
            required
            prefix={<FiLock className="h-5 w-5 text-muted-foreground" />}
            suffix={
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="p-1 focus:outline-none"
              >
                {showPassword ? (
                  <FiEyeOff className="h-5 w-5 text-muted-foreground" />
                ) : (
                  <FiEye className="h-5 w-5 text-muted-foreground" />
                )}
              </button>
            }
          />

          <Button
            type="submit"
            className="w-80 h-10"
            style={{ borderRadius: "10px" }}
            disabled={isLoading}
          >
            {isLoading ? "Logging in..." : "Login"}
          </Button>
        </form>
      </div>
    </div>
  );
};

export default Login;
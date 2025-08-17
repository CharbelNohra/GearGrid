"use client";

import React, { useState } from "react";
import Image from "next/image";
import { Input } from "@/components/ui/input";
import { FiUser, FiLock, FiEye, FiEyeOff } from "react-icons/fi";
import { Button } from "@/components/ui/button";
import Link from "next/link";

const Login = () => {
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    // TEMP: simulate API call
    setTimeout(() => {
      setIsLoading(false);
    }, 2000);
  };

  return (
    <div className="flex flex-col align-center items-center mt-30 h-screen">
      <div>
        <Image src="/GearGrid.svg" alt="Logo" width={200} height={200} />
      </div>

      <div className="text-center flex flex-col mt-4">
        <h1 className="text-2xl font-bold mb-2">Welcome back 👋</h1>
        <p className="text-muted-foreground mb-4">Log in to your account</p>

        {/* Email & Password Form */}
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

          <Link
            href="/auth/forgot-password"
            className="text-sm text-primary mb-4 self-end pr-1"
          >
            Forgot password?
          </Link>

          <Button
            type="submit"
            className="w-80 h-10"
            style={{ borderRadius: "10px" }}
            disabled={isLoading}
          >
            {isLoading ? "Logging in..." : "Login"}
          </Button>
        </form>

        <p className="text-sm mt-4">
          Don&apos;t have an account?{" "}
          <Link href="/auth/register" className="text-primary">
            Register
          </Link>
        </p>
      </div>
    </div>
  );
};

export default Login;
/* eslint-disable @typescript-eslint/no-unused-vars */
"use client";

import React, { useState } from "react";
import Image from "next/image";
import { Input } from "@/components/ui/input";
import { FiUser, FiLock, FiEye, FiEyeOff } from "react-icons/fi";
import { Button } from "@/components/ui/button";
import { useRouter } from "next/navigation";
import { authService } from "@/services/authService";
import { toast } from "sonner";

interface LoginFormData {
  email: string;
  password: string;
}

const Login = () => {
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [formData, setFormData] = useState<LoginFormData>({
    email: "",
    password: ""
  });
  const [error, setError] = useState("");
  const router = useRouter();

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    if (error) setError("");
  };

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setIsLoading(true);
    setError("");

    try {
      if (!formData.email || !formData.password) {
        const msg = "Please fill in all fields.";
        setError(msg);
        toast.error(msg);
        return;
      }

      await authService.login(formData.email, formData.password);

      if (!authService.isAdmin()) {
        const msg = "Access denied. Admin only.";
        setError(msg);
        toast.error(msg);
        await authService.logout();
        return;
      }

      toast.success("Login successful! Welcome back.");
      router.push("/dashboard");
    } catch (err: unknown) {
      const errorMessage =
        err instanceof Error ? err.message : "Login failed. Please try again.";
      setError(errorMessage);
      toast.error(errorMessage);
    } finally {
      setIsLoading(false);
    }
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
            name="email"
            placeholder="Email"
            className="mb-4 w-80"
            // required
            value={formData.email}
            onChange={handleInputChange}
            disabled={isLoading}
            prefix={<FiUser className="h-5 w-5 text-muted-foreground" />}
          />

          <Input
            type={showPassword ? "text" : "password"}
            name="password"
            placeholder="Password"
            className="mb-4 w-80"
            // required
            value={formData.password}
            onChange={handleInputChange}
            disabled={isLoading}
            prefix={<FiLock className="h-5 w-5 text-muted-foreground" />}
            suffix={
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="p-1 focus:outline-none"
                disabled={isLoading}
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
"use client";

import React, { useState, useRef } from "react";
import Image from "next/image";
import { Input } from "@/components/ui/input";
import {
    FiUser,
    FiMail,
    FiLock,
    FiPhone,
    FiMapPin,
    FiEye,
    FiEyeOff,
    FiArrowLeft,
    FiArrowRight,
} from "react-icons/fi";
import Link from "next/link";
import countries from "@/lib/countries";

const steps = ["Account Info", "Contact Info", "OTP Verification"];

const Register = () => {
    const [step, setStep] = useState(1);
    const [showPassword, setShowPassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);
    const [otp, setOtp] = useState(Array(6).fill(""));
    const [isVerifying, setIsVerifying] = useState(false);
    const [selectedCountry, setSelectedCountry] = useState({ code: "+1", flag: "🇺🇸", name: "United States" });
    const [phoneNumber, setPhoneNumber] = useState("");
    const otpRefs = useRef<HTMLInputElement[]>([]);


    const totalSteps = steps.length;

    const handleNext = (e: React.FormEvent) => {
        e.preventDefault();
        if (step < totalSteps) {
            setStep(step + 1);
        }
    };

    const handleVerify = (e: React.FormEvent) => {
        e.preventDefault();
        setIsVerifying(true);
        // Simulate verification delay
        setTimeout(() => {
            setIsVerifying(false);
            console.log("Registration submitted!");
            // You can add success handling here, like redirecting or showing success message
        }, 2000);
    };

    const handleBack = () => {
        if (step > 1) setStep(step - 1);
    };

    const handleStepClick = (clickedStep: number) => {
        if (clickedStep <= step) {
            setStep(clickedStep);
        }
    };

    const handleOtpChange = (index: number, value: string) => {
        if (!/^\d*$/.test(value)) return; // Only digits
        const newOtp = [...otp];
        newOtp[index] = value;
        setOtp(newOtp);

        if (value && index < 5) {
            otpRefs.current[index + 1]?.focus();
        }
    };

    return (
        <div className="flex flex-col items-center h-screen p-6">
            {/* Logo */}
            <div className="mb-6">
                <Image src="/GearGrid.svg" alt="Logo" width={200} height={200} />
            </div>

            {/* Step Circles */}
            <div className="flex justify-center items-center w-full max-w-md mb-6">
                {steps.map((label, index) => {
                    const stepNumber = index + 1;
                    const isCompleted = step > stepNumber;
                    const isCurrent = step === stepNumber;

                    return (
                        <div
                            key={label}
                            className="flex items-center cursor-pointer"
                            onClick={() => handleStepClick(stepNumber)}
                        >
                            <div
                                className={`flex items-center justify-center w-8 h-8 rounded-full border-2
                  ${isCompleted ? "bg-primary border-primary text-white" : ""}
                  ${isCurrent ? "border-primary text-primary" : "border-gray-300 text-gray-500"}
                `}
                            >
                                {isCompleted ? "✓" : stepNumber}
                            </div>
                            {index !== steps.length - 1 && (
                                <div
                                    className={`w-16 h-1 ${step > stepNumber ? "bg-primary" : "bg-gray-300"} mx-2 rounded`}
                                ></div>
                            )}
                        </div>
                    );
                })}
            </div>

            {/* Form */}
            <form onSubmit={step === 3 ? handleVerify : handleNext} className="flex flex-col items-center w-80">
                {/* Step 1: Account Info */}
                {step === 1 && (
                    <div className="w-full">
                        <h1 className="text-xl font-bold mb-4 text-center">Create Account</h1>
                        <Input
                            type="text"
                            placeholder="Full Name"
                            className="mb-4 w-80"
                            required
                            prefix={<FiUser className="h-5 w-5 text-muted-foreground" />}
                        />
                        <Input
                            type="email"
                            placeholder="Email"
                            className="mb-4 w-80"
                            required
                            prefix={<FiMail className="h-5 w-5 text-muted-foreground" />}
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
                        <Input
                            type={showConfirmPassword ? "text" : "password"}
                            placeholder="Confirm Password"
                            className="mb-4 w-80"
                            required
                            prefix={<FiLock className="h-5 w-5 text-muted-foreground" />}
                            suffix={
                                <button
                                    type="button"
                                    onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                                    className="p-1 focus:outline-none"
                                >
                                    {showConfirmPassword ? (
                                        <FiEyeOff className="h-5 w-5 text-muted-foreground" />
                                    ) : (
                                        <FiEye className="h-5 w-5 text-muted-foreground" />
                                    )}
                                </button>
                            }
                        />
                    </div>
                )}

                {/* Step 2: Contact Info */}
                {step === 2 && (
                    <div className="w-full">
                        <h1 className="text-xl font-bold mb-4 text-center">Contact Info</h1>
                        <Input
                            type="text"
                            placeholder="Address"
                            className="mb-4 w-80"
                            required
                            prefix={<FiMapPin className="h-5 w-5 text-muted-foreground" />}
                        />

                        {/* Phone Number with Country Code */}
                        <div className="mb-4 w-80">
                            <div className="flex">
                                {/* Country Code Selector */}
                                <select
                                    value={`${selectedCountry.code}|${selectedCountry.flag}|${selectedCountry.name}`}
                                    onChange={(e) => {
                                        const [code, flag, name] = e.target.value.split('|');
                                        setSelectedCountry({ code, flag, name });
                                    }}
                                    className="border rounded-l-md p-2 bg-primary min-w-[100px] focus:ring focus:ring-primary focus:border-primary"
                                >
                                    {countries.map((country) => (
                                        <option
                                            key={`${country.code}-${country.name}`}
                                            value={`${country.code}|${country.flag}|${country.name}`}
                                        >
                                            {country.flag} {country.code}
                                        </option>
                                    ))}
                                </select>

                                {/* Phone Number Input */}
                                <div className="relative flex-1">
                                    <FiPhone className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-muted-foreground" />
                                    <input
                                        type="tel"
                                        placeholder="Phone Number"
                                        value={phoneNumber}
                                        onChange={(e) => setPhoneNumber(e.target.value)}
                                        className="border border-l-0 rounded-r-md p-2 pl-10 w-full focus:ring focus:ring-primary focus:border-primary"
                                        required
                                    />
                                </div>
                            </div>
                            {/* Display full phone number */}
                            {phoneNumber && (
                                <p className="text-sm text-muted-foreground mt-1">
                                    Full number: {selectedCountry.code} {phoneNumber}
                                </p>
                            )}
                        </div>
                    </div>
                )}

                {/* Step 3: OTP Verification */}
                {step === 3 && (
                    <div className="w-full">
                        <h1 className="text-xl font-bold mb-4 text-center">Verify Your Email</h1>
                        <p className="text-center text-muted-foreground mb-4">
                            We&apos;ve sent a verification code to your email.
                        </p>
                        <div className="flex justify-between w-full max-w-xs mx-auto">
                            {otp.map((digit, index) => (
                                <input
                                    key={index}
                                    ref={(el) => {
                                        if (el) otpRefs.current[index] = el;
                                    }}
                                    type="text"
                                    maxLength={1}
                                    value={digit}
                                    onChange={(e) => handleOtpChange(index, e.target.value)}
                                    className="border rounded w-12 h-12 text-center text-lg focus:ring focus:ring-primary"
                                />
                            ))}
                        </div>
                    </div>
                )}

                {/* Navigation Icons */}
                <div className="flex justify-between items-center w-full mt-4 relative">
                    {step > 1 && (
                        <button
                            type="button"
                            onClick={handleBack}
                            className="text-primary hover:text-primary/80 transition-colors p-2"
                        >
                            <FiArrowLeft className="h-6 w-6" />
                        </button>
                    )}
                    {step === 3 ? (
                        <button
                            type="submit"
                            disabled={isVerifying}
                            className="bg-primary hover:bg-primary/90 disabled:bg-primary/50 text-white px-6 py-2 rounded-md transition-colors ml-auto"
                        >
                            {isVerifying ? "Verifying..." : "Verify"}
                        </button>
                    ) : (
                        <button
                            type="submit"
                            className="text-primary hover:text-primary/80 transition-colors p-2 ml-auto"
                        >
                            <FiArrowRight className="h-6 w-6" />
                        </button>
                    )}
                </div>

                {/* Already have account */}
                <p className="text-sm mt-4 text-center">
                    Already have an account?{" "}
                    <Link href="/auth/login" className="text-primary">
                        Login
                    </Link>
                </p>
            </form>
        </div>
    );
};

export default Register;
import mongoose from "mongoose";
import { nanoid } from "nanoid";

const userSchema = new mongoose.Schema({
    userId: {
        type: String,
        default: () => nanoid(8),
        unique: true,
    },
    fullName: { type: String, required: true },
    email: { type: String, required: true, unique: true, lowercase: true },
    password: { type: String, required: true },
    country: { type: String, required: true },
    countryCode: { type: String, required: true },
    address: { type: String, required: true },
    phoneNumber: { type: String, required: true },
    avatar: { type: String, default: "" },
    isVerified: { type: Boolean, default: false },
    otp: { type: String },
    otpExpires: { type: Date },
    role: {
        type: String,
        enum: ["client", "admin"],
        default: "client"
    }
}, { timestamps: true });

export default mongoose.model("User", userSchema);

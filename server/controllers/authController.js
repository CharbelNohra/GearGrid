import bcrypt from "bcryptjs";
import User from "../models/user.js";
import { validateRegister } from "../middlewares/validateInput.js";
import { generateOTP } from "../utils/generateOtp.js";
import { sendRegistrationOTP } from "../utils/sendEmail.js";
import { generateAccessToken, generateRefreshToken } from "../utils/generateToken.js";
import { verifyRefreshToken } from "../utils/verifyToken.js";

let refreshTokens = [];

// REGISTER
export async function register(req, res) {
    console.log("Incoming register body:", req.body);
    try {
        const errors = validateRegister(req.body);
        if (errors.length > 0) return res.status(400).json({ errors });

        const { fullName, email, password, confirmPassword, country, address, phoneNumber } = req.body;

        if (password !== confirmPassword) {
            return res.status(400).json({ error: "Password and confirm password do not match" });
        }

        const existingUser = await User.findOne({ email });
        if (existingUser) return res.status(400).json({ error: "Email already registered" });

        const hashedPassword = await bcrypt.hash(password, 10);
        const otp = generateOTP();
        const normalizedPhone = phoneNumber.replace(/\s+/g, "");

        const user = new User({
            fullName,
            email,
            password: hashedPassword,
            country,
            address,
            phoneNumber: normalizedPhone,
            otp,
            otpExpires: Date.now() + 3 * 60 * 1000,
            role: role || "client"
        });

        await user.save();

        await sendRegistrationOTP(email, otp);

        // Optional: return OTP for testing in Postman (remove in production)
        res.status(201).json({ message: "User registered. Please verify with OTP.", otp });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}

// VERIFY OTP
export async function verifyOTP(req, res) {
    const { email, otp } = req.body;
    const user = await User.findOne({ email });

    if (!user) return res.status(404).json({ error: "User not found" });
    if (user.otp !== otp || Date.now() > user.otpExpires) {
        return res.status(400).json({ error: "Invalid or expired OTP" });
    }

    user.isVerified = true;
    user.otp = undefined;
    user.otpExpires = Date.now() + 3 * 60 * 1000;
    await user.save();

    res.json({ message: "Account verified successfully" });
}

// LOGIN
export async function login(req, res) {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ error: "User not found" });
    if (!user.isVerified) return res.status(403).json({ error: "Please verify your email first" });

    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) return res.status(400).json({ error: "Invalid password" });

    const accessToken = generateAccessToken(user);
    const refreshToken = generateRefreshToken(user);

    refreshTokens.push(refreshToken);

    res.json({
        accessToken,
        refreshToken,
        user: {
            id: user.userId,
            email: user.email,
            fullName: user.fullName,
            role: user.role
        }
    });
}

// FORGOT PASSWORD (send OTP)
export async function forgotPassword(req, res) {
    const { email } = req.body;
    const user = await User.findOne({ email });

    if (!user) return res.status(404).json({ error: "User not found" });

    const otp = generateOTP();
    user.otp = otp;
    user.otpExpires = Date.now() + 10 * 60 * 1000;
    await user.save();

    await sendEmail(email, "Password Reset", `Your reset OTP is: ${otp}`);
    res.json({ message: "OTP sent to your email" });
}

// RESET PASSWORD
export async function resetPassword(req, res) {
    const { email, otp, newPassword, confirmPassword } = req.body;
    const user = await User.findOne({ email });

    if (!user) return res.status(404).json({ error: "User not found" });
    if (user.otp !== otp || Date.now() > user.otpExpires) {
        return res.status(400).json({ error: "Invalid or expired OTP" });
    }

    if (newPassword !== confirmPassword) {
        return res.status(400).json({ error: "Password and confirm password do not match" });
    }

    user.password = await bcrypt.hash(newPassword, 10);
    user.otp = undefined;
    user.otpExpires = undefined;
    await user.save();

    res.json({ message: "Password reset successfully" });
}

// GET PROFILE
export async function getProfile(req, res) {
    try {
        const user = await User.findOne({ userId: req.user.id });
        if (!user) return res.status(404).json({ error: "User not found" });

        res.json({
            user: {
                userId: user.userId,
                fullName: user.fullName,
                email: user.email,
                country: user.country || "",
                address: user.address || "",
                phoneNumber: user.phoneNumber || "",
                avatar: user.avatar || "",
                role: user.role,
            }
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}

export async function updateProfile(req, res) {
    try {
        const user = await User.findOne({ userId: req.user.id });
        if (!user) return res.status(404).json({ error: "User not found" });

        const { fullName, email, password, country, address, phoneNumber } = req.body;
        if (fullName) user.fullName = fullName;
        if (email) user.email = email;
        if (password) user.password = await bcrypt.hash(password, 10);
        if (country) user.country = country;
        if (address) user.address = address;
        if (phoneNumber) user.phoneNumber = phoneNumber;

        if (req.file) {
            user.avatar = `${req.protocol}://${req.get("host")}/uploads/avatars/${req.file.filename}`;
        }

        await user.save();

        res.json({
            message: "Profile updated successfully",
            user: {
                userId: user.userId,
                fullName: user.fullName,
                email: user.email,
                country: user.country,
                address: user.address,
                phoneNumber: user.phoneNumber,
                avatar: user.avatar,
                role: user.role
            }
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}


export function refreshToken(req, res) {
    const { token } = req.body;

    if (!token) return res.status(401).json({ message: "Refresh token required" });
    if (!refreshTokens.includes(token)) return res.status(403).json({ message: "Invalid refresh token" });

    const payload = verifyRefreshToken(token);
    if (!payload) return res.status(403).json({ message: "Invalid or expired refresh token" });

    // Generate new tokens
    const user = { _id: payload.id, email: payload.email };
    const newAccessToken = generateAccessToken(user);
    const newRefreshToken = generateRefreshToken(user);

    // Replace old refresh token with new one
    refreshTokens = refreshTokens.filter(t => t !== token);
    refreshTokens.push(newRefreshToken);

    res.json({
        accessToken: newAccessToken,
        refreshToken: newRefreshToken
    });
}

// LOGOUT
export function logout(req, res) {
    const { token } = req.body;
    refreshTokens = refreshTokens.filter(t => t !== token);
    res.json({ message: "Logged out successfully" });
}
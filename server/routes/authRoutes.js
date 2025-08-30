import express from "express";
import { register, verifyOTP, login, forgotPassword, resetPassword, logout, updateProfile } from "../controllers/authController.js";
import { authenticateToken } from "../middlewares/authMiddleware.js";
import { upload } from "../middlewares/upload.js";

const router = express.Router();
router.post("/register", register);
router.post("/verify-otp", verifyOTP);
router.post("/login", login);
router.post("/forgot-password", forgotPassword);
router.post("/reset-password", resetPassword);
router.put("/profile", authenticateToken, upload.single("avatar"), updateProfile);
router.post("/logout", logout);

export default router;

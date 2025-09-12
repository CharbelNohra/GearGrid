import jwt from "jsonwebtoken";

/**
 * Generate Access Token (short-lived)
 * @param {Object} user - User object containing _id and email
 */
export function generateAccessToken(user) {
    if (!process.env.JWT_SECRET) {
        throw new Error("JWT_SECRET is not defined in environment variables");
    }
    return jwt.sign(
        { id: user.userId, email: user.email },
        process.env.JWT_SECRET,
        { expiresIn: process.env.ACCESS_TOKEN_EXPIRATION || "2d" }
    );
}

/**
 * Generate Refresh Token (long-lived)
 * @param {Object} user - User object containing _id and email
 */
export function generateRefreshToken(user) {
    if (!process.env.JWT_REFRESH_SECRET) {
        throw new Error("JWT_REFRESH_SECRET is not defined in environment variables");
    }
    return jwt.sign(
        { id: user.userId, email: user.email },
        process.env.JWT_REFRESH_SECRET,
        { expiresIn: process.env.REFRESH_TOKEN_EXPIRATION || "7d" }
    );
}

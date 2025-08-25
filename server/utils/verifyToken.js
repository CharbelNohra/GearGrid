import jwt from "jsonwebtoken";

/**
 * Verify Access Token
 */
export function verifyAccessToken(token) {
    try {
        return jwt.verify(token, process.env.JWT_SECRET);
    } catch (err) {
        return null; // or throw error
    }
}

/**
 * Verify Refresh Token
 */
export function verifyRefreshToken(token) {
    try {
        return jwt.verify(token, process.env.JWT_REFRESH_SECRET);
    } catch (err) {
        return null; // or throw error
    }
}

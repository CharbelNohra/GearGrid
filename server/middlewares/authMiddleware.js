import { verifyAccessToken } from "../utils/verifyToken.js";

export function authenticateToken(req, res, next) {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1];

    if (!token) return res.status(401).json({ error: "Access token required" });

    const user = verifyAccessToken(token);
    if (!user) return res.status(403).json({ error: "Invalid or expired token" });

    req.user = user; // { id, email, role }
    next();
}

import validator from "validator";

export function validateRegister(data) {
    const errors = [];

    if (!data.fullName || data.fullName.trim().length < 3) {
        errors.push("Full name must be at least 3 characters.");
    }

    if (!validator.isEmail(data.email || "")) {
        errors.push("Invalid email address.");
    }

    if (!validator.isStrongPassword(data.password || "", {
        minLength: 8,
        minLowercase: 1,
        minUppercase: 1,
        minNumbers: 1,
        minSymbols: 1,
    })) {
        errors.push("Password must be strong (8+ chars, upper, lower, number, symbol).");
    }

    if (data.password !== data.confirmPassword) {
        errors.push("Passwords do not match.");
    }

    const cleanedPhone = (data.phoneNumber || "").replace(/\s+/g, "");
    const phoneRegex = /^\+?[0-9]{7,15}$/;
    if (!cleanedPhone || !phoneRegex.test(cleanedPhone)) {
        errors.push("Invalid phone number.");
    }

    if (!data.country || !data.address) {
        errors.push("Country and address are required.");
    }

    return errors;
}

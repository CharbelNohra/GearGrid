import nodemailer from "nodemailer";

// Email templates
const emailTemplates = {
    registration: (otpCode) => ({
        subject: "Welcome to GearGrid - Verify Your Account",
        text: `
Dear User,

Welcome to GearGrid! We're excited to have you join our community.

To complete your registration and secure your account, please verify your email address using the verification code below:

VERIFICATION CODE: ${otpCode}

This code is valid for 3 minutes and can only be used once.

If you didn't create a GearGrid account, please ignore this email.

Need help? Contact our support team at support@geargrid.com

Best regards,
The GearGrid Team

---
This is an automated message, please do not reply to this email.
        `.trim(),
        html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; color: #333;">
            <div style="text-align: center; margin-bottom: 30px;">
                <h1 style="color: #2563eb; margin: 0;">GearGrid</h1>
                <p style="color: #666; margin: 5px 0;">Welcome to our community!</p>
            </div>
            
            <div style="background: #f8fafc; padding: 20px; border-radius: 8px; margin: 20px 0;">
                <h2 style="color: #1e40af; margin-top: 0;">Verify Your Account</h2>
                <p>Welcome to GearGrid! We're excited to have you join our community.</p>
                <p>To complete your registration and secure your account, please verify your email address using the verification code below:</p>
                
                <div style="background: white; padding: 20px; border-radius: 6px; text-align: center; margin: 20px 0; border: 2px dashed #2563eb;">
                    <h3 style="margin: 0; color: #1e40af; font-size: 24px; letter-spacing: 3px;">${otpCode}</h3>
                    <p style="margin: 10px 0 0 0; color: #666; font-size: 14px;">Verification Code</p>
                </div>
                
                <p style="color: #666; font-size: 14px;">
                    <strong>⏰ This code is valid for 10 minutes and can only be used once.</strong>
                </p>
            </div>
            
            <div style="margin: 30px 0; padding: 15px; background: #fef3cd; border-radius: 6px; border-left: 4px solid #f59e0b;">
                <p style="margin: 0; color: #92400e;">
                    <strong>Security Notice:</strong> If you didn't create a GearGrid account, please ignore this email.
                </p>
            </div>
            
            <div style="text-align: center; margin: 30px 0; color: #666;">
                <p>Need help? Contact our support team at <a href="mailto:support@geargrid.com" style="color: #2563eb;">support@geargrid.com</a></p>
            </div>
            
            <div style="border-top: 1px solid #e5e7eb; padding-top: 20px; margin-top: 30px; text-align: center; color: #666; font-size: 12px;">
                <p>Best regards,<br><strong>The GearGrid Team</strong></p>
                <p style="margin-top: 20px;">This is an automated message, please do not reply to this email.</p>
            </div>
        </div>
        `
    }),

    passwordReset: (otpCode) => ({
        subject: "GearGrid - Password Reset Verification",
        text: `
Dear User,

We received a request to reset your GearGrid account password.

To proceed with your password reset, please use the verification code below:

VERIFICATION CODE: ${otpCode}

This code is valid for 3 minutes and can only be used once.

If you didn't request a password reset, please ignore this email. Your account remains secure.

For security reasons, we recommend:
• Using a strong, unique password
• Enabling two-factor authentication when available
• Keeping your account information up to date

Need help? Contact our support team at support@geargrid.com

Best regards,
The GearGrid Team

---
This is an automated message, please do not reply to this email.
        `.trim(),
        html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; color: #333;">
            <div style="text-align: center; margin-bottom: 30px;">
                <h1 style="color: #2563eb; margin: 0;">GearGrid</h1>
                <p style="color: #666; margin: 5px 0;">Account Security</p>
            </div>
            
            <div style="background: #fef2f2; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #ef4444;">
                <h2 style="color: #dc2626; margin-top: 0;">Password Reset Request</h2>
                <p>We received a request to reset your GearGrid account password.</p>
                <p>To proceed with your password reset, please use the verification code below:</p>
                
                <div style="background: white; padding: 20px; border-radius: 6px; text-align: center; margin: 20px 0; border: 2px dashed #ef4444;">
                    <h3 style="margin: 0; color: #dc2626; font-size: 24px; letter-spacing: 3px;">${otpCode}</h3>
                    <p style="margin: 10px 0 0 0; color: #666; font-size: 14px;">Verification Code</p>
                </div>
                
                <p style="color: #666; font-size: 14px;">
                    <strong>⏰ This code is valid for 10 minutes and can only be used once.</strong>
                </p>
            </div>
            
            <div style="margin: 30px 0; padding: 15px; background: #fef3cd; border-radius: 6px; border-left: 4px solid #f59e0b;">
                <p style="margin: 0 0 10px 0; color: #92400e;">
                    <strong>Security Notice:</strong> If you didn't request a password reset, please ignore this email. Your account remains secure.
                </p>
                <p style="margin: 0; color: #92400e; font-size: 14px;">
                    For security reasons, we recommend using a strong, unique password and keeping your account information up to date.
                </p>
            </div>
            
            <div style="text-align: center; margin: 30px 0; color: #666;">
                <p>Need help? Contact our support team at <a href="mailto:support@geargrid.com" style="color: #2563eb;">support@geargrid.com</a></p>
            </div>
            
            <div style="border-top: 1px solid #e5e7eb; padding-top: 20px; margin-top: 30px; text-align: center; color: #666; font-size: 12px;">
                <p>Best regards,<br><strong>The GearGrid Team</strong></p>
                <p style="margin-top: 20px;">This is an automated message, please do not reply to this email.</p>
            </div>
        </div>
        `
    })
};

// Enhanced email sending function
export async function sendEmail(to, subject, text) {
    const transporter = nodemailer.createTransporter({
        service: "gmail",
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS
        }
    });

    await transporter.sendMail({
        from: `"GearGrid" <${process.env.EMAIL_USER}>`,
        to,
        subject,
        text
    });
}

// Specialized OTP email functions
export async function sendRegistrationOTP(to, otpCode) {
    const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS
        }
    });

    const template = emailTemplates.registration(otpCode);

    await transporter.sendMail({
        from: `"GearGrid" <${process.env.EMAIL_USER}>`,
        to,
        subject: template.subject,
        text: template.text,
        html: template.html
    });
}

export async function sendPasswordResetOTP(to, otpCode) {
    const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS
        }
    });

    const template = emailTemplates.passwordReset(otpCode);

    await transporter.sendMail({
        from: `"GearGrid" <${process.env.EMAIL_USER}>`,
        to,
        subject: template.subject,
        text: template.text,
        html: template.html
    });
}

// Generic OTP sender (for backward compatibility)
export async function sendOTP(to, otpCode, type = 'registration') {
    if (type === 'registration') {
        return await sendRegistrationOTP(to, otpCode);
    } else if (type === 'password-reset') {
        return await sendPasswordResetOTP(to, otpCode);
    } else {
        throw new Error('Invalid OTP type. Use "registration" or "password-reset"');
    }
}
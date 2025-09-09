export interface User {
    id: string;
    email: string;
    fullName: string;
    role: string;
    avatar?: string;
    country?: string;
    address?: string;
    phoneNumber?: string;
}

export interface LoginResponse {
    success?: boolean;
    message?: string;
    accessToken: string;
    refreshToken: string;
    user: User;
}

export interface UpdateProfileData {
    fullName?: string;
    email?: string;
    password?: string;
    country?: string;
    address?: string;
    phoneNumber?: string;
}

export interface UpdateProfileResponse {
    success?: boolean;
    message?: string;
    user: User;
}

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:5000/api';

class AuthService {
    // -----------------------
    // Login
    // -----------------------
    async login(email: string, password: string): Promise<LoginResponse> {
        try {
            const response = await fetch(`${API_BASE_URL}/auth/login`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email, password }),
            });

            const data: LoginResponse = await response.json();

            if (!response.ok) {
                throw new Error(data.message || 'Login failed');
            }

            if (typeof window !== 'undefined') {
                localStorage.setItem('accessToken', data.accessToken);
                localStorage.setItem('refreshToken', data.refreshToken);
                localStorage.setItem('user', JSON.stringify(data.user));
            }

            return data;
        } catch (error: unknown) {
            if (error instanceof Error) throw error;
            throw new Error('Unknown error occurred during login');
        }
    }

    // -----------------------
    // Update profile (with optional avatar)
    // -----------------------
    async updateProfile(profileData: UpdateProfileData, avatarFile?: File): Promise<UpdateProfileResponse> {
        try {
            const token = this.getAuthToken();
            if (!token) throw new Error('Not authenticated');

            let body: BodyInit;
            const headers: Record<string, string> = { 'Authorization': `Bearer ${token}` };

            if (avatarFile) {
                const formData = new FormData();
                Object.entries(profileData).forEach(([key, value]) => {
                    if (value !== undefined && value !== '') formData.append(key, value);
                });
                formData.append('avatar', avatarFile);
                body = formData;
                // Don't set Content-Type for FormData, browser handles it
            } else {
                headers['Content-Type'] = 'application/json';
                body = JSON.stringify(profileData);
            }

            const response = await fetch(`${API_BASE_URL}/auth/updateProfile`, {
                method: 'PUT',
                headers,
                body,
            });

            const data: UpdateProfileResponse = await response.json();

            if (!response.ok) throw new Error(data.message || 'Profile update failed');

            if (data.user && typeof window !== 'undefined') {
                localStorage.setItem('user', JSON.stringify(data.user));
            }

            return data;
        } catch (error: unknown) {
            if (error instanceof Error) throw error;
            throw new Error('Unknown error occurred during profile update');
        }
    }

    // -----------------------
    // Logout
    // -----------------------
    async logout(): Promise<void> {
        try {
            const refreshToken = this.getRefreshToken();
            if (refreshToken) {
                await fetch(`${API_BASE_URL}/auth/logout`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ token: refreshToken }),
                });
            }
        } catch (error) {
            console.error('Logout API call failed:', error);
        } finally {
            this.clearAuthData();
        }
    }

    // -----------------------
    // Utilities
    // -----------------------
    getCurrentUser(): User | null {
        if (typeof window !== 'undefined') {
            const user = localStorage.getItem('user');
            return user ? JSON.parse(user) : null;
        }
        return null;
    }

    isAuthenticated(): boolean {
        if (typeof window !== 'undefined') {
            return !!localStorage.getItem('accessToken');
        }
        return false;
    }

    getAuthToken(): string | null {
        if (typeof window !== 'undefined') return localStorage.getItem('accessToken');
        return null;
    }

    getRefreshToken(): string | null {
        if (typeof window !== 'undefined') return localStorage.getItem('refreshToken');
        return null;
    }

    clearAuthData(): void {
        if (typeof window !== 'undefined') {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('refreshToken');
            localStorage.removeItem('user');
        }
    }

    isAdmin(): boolean {
        return this.getCurrentUser()?.role === 'admin';
    }
}

export const authService = new AuthService();
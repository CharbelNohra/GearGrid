export interface User {
    userId: string;
    email: string;
    fullName: string;
    role: string;
    avatar?: string;
    country?: string;
    countryCode?: string;
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
    oldPassword?: string;
    newPassword?: string;
    country?: string;
    countryCode?: string;
    address?: string;
    phoneNumber?: string;
}

export interface UpdateProfileResponse {
    success?: boolean;
    message?: string;
    user: User;
}

const API_BASE_URL = 'http://localhost:5000/api';

class AuthService {
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

    async getProfile(): Promise<User> {
        const token = localStorage.getItem("accessToken");
        if (!token) throw new Error("No access token");

        const res = await fetch(`${API_BASE_URL}/auth/profile`, {
            method: "GET",
            headers: { Authorization: `Bearer ${token}` }
        });

        if (!res.ok) {
            const data = await res.json().catch(() => ({}));
            console.error("Profile fetch failed:", data);
            throw new Error(data.error || "Failed to fetch profile");
        }

        const data = await res.json();
        return data.user;
    }

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
            } else {
                headers['Content-Type'] = 'application/json';
                body = JSON.stringify(profileData);
            }

            const response = await fetch(`${API_BASE_URL}/auth/update-profile`, {
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

    getCurrentUser(): User | null {
        if (typeof window !== 'undefined') {
            const user = localStorage.getItem('user');
            return user ? JSON.parse(user) : null;
        }
        return null;
    }

    isAuthenticated(): boolean {
        if (typeof window !== 'undefined') {
            const token = localStorage.getItem('accessToken');
            return !!token;
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
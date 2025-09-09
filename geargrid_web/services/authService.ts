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

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:5000/api';

class AuthService {
    // Login method
    async login(email: string, password: string): Promise<LoginResponse> {
        try {
            const response = await fetch(`${API_BASE_URL}/auth/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ email, password }),
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.error || 'Login failed');
            }

            // Store tokens and user data
            if (typeof window !== 'undefined') {
                localStorage.setItem('accessToken', data.accessToken);
                localStorage.setItem('refreshToken', data.refreshToken);
                localStorage.setItem('user', JSON.stringify(data.user));
            }

            return data;
        } catch (error) {
            throw error;
        }
    }

    // Update profile method
    async updateProfile(profileData: UpdateProfileData): Promise<any> {
        try {
            const token = this.getAuthToken();

            const response = await fetch(`${API_BASE_URL}/auth/updateProfile`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`,
                },
                body: JSON.stringify(profileData),
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.error || 'Profile update failed');
            }

            // Update stored user data
            if (data.user && typeof window !== 'undefined') {
                localStorage.setItem('user', JSON.stringify(data.user));
            }

            return data;
        } catch (error) {
            throw error;
        }
    }

    // Update profile with avatar method
    async updateProfileWithAvatar(profileData: UpdateProfileData, avatarFile?: File): Promise<any> {
        try {
            const token = this.getAuthToken();
            const formData = new FormData();

            // Append profile data
            Object.entries(profileData).forEach(([key, value]) => {
                if (value !== undefined && value !== '') {
                    formData.append(key, value);
                }
            });

            // Append avatar file if provided
            if (avatarFile) {
                formData.append('avatar', avatarFile);
            }

            const response = await fetch(`${API_BASE_URL}/auth/updateProfile`, {
                method: 'PUT',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    // Don't set Content-Type for FormData - browser will set it with boundary
                },
                body: formData,
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.error || 'Profile update failed');
            }

            // Update stored user data
            if (data.user && typeof window !== 'undefined') {
                localStorage.setItem('user', JSON.stringify(data.user));
            }

            return data;
        } catch (error) {
            throw error;
        }
    }

    // Logout method
    async logout(): Promise<void> {
        try {
            const refreshToken = this.getRefreshToken();

            if (refreshToken) {
                await fetch(`${API_BASE_URL}/auth/logout`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ token: refreshToken }),
                });
            }
        } catch (error) {
            console.error('Logout API call failed:', error);
        } finally {
            // Always clear local storage
            this.clearAuthData();
        }
    }

    // Utility methods
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
        if (typeof window !== 'undefined') {
            return localStorage.getItem('accessToken');
        }
        return null;
    }

    getRefreshToken(): string | null {
        if (typeof window !== 'undefined') {
            return localStorage.getItem('refreshToken');
        }
        return null;
    }

    clearAuthData(): void {
        if (typeof window !== 'undefined') {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('refreshToken');
            localStorage.removeItem('user');
        }
    }

    // Check if user is admin
    isAdmin(): boolean {
        const user = this.getCurrentUser();
        return user?.role === 'admin';
    }
}

// Export singleton instance
export const authService = new AuthService();
// export interface User {
//     id: string;
//     email: string;
//     fullName: string;
//     role: string;
//     avatar?: string;
//     country?: string;
//     address?: string;
//     phoneNumber?: string;
// }

// export interface LoginResponse {
//     success?: boolean;
//     message?: string;
//     accessToken: string;
//     refreshToken: string;
//     user: User;
// }

// export interface UpdateProfileData {
//     fullName?: string;
//     email?: string;
//     password?: string;
//     country?: string;
//     address?: string;
//     phoneNumber?: string;
// }

// export interface UpdateProfileResponse {
//     success?: boolean;
//     message?: string;
//     user: User;
// }

// const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:5000/api';

// class AuthService {
//     // -----------------------
//     // Login with extensive debugging
//     // -----------------------
//     async login(email: string, password: string): Promise<LoginResponse> {
//         console.log("🔑 AuthService.login called with:", { email, password: "***" });
//         console.log("🌐 API_BASE_URL:", API_BASE_URL);

//         try {
//             const requestBody = { email, password };
//             console.log("📤 Request body:", requestBody);

//             const response = await fetch(`${API_BASE_URL}/auth/login`, {
//                 method: 'POST',
//                 headers: { 'Content-Type': 'application/json' },
//                 body: JSON.stringify(requestBody),
//             });

//             console.log("📥 Response status:", response.status);
//             console.log("📥 Response ok:", response.ok);

//             const data: LoginResponse = await response.json();
//             console.log("📥 Response data:", data);

//             if (!response.ok) {
//                 console.error("❌ Response not ok:", data.message);
//                 throw new Error(data.message || 'Login failed');
//             }

//             // Check if we have the required data
//             console.log("🔍 Checking response data structure:", {
//                 hasAccessToken: !!data.accessToken,
//                 hasRefreshToken: !!data.refreshToken,
//                 hasUser: !!data.user,
//                 accessToken: data.accessToken,
//                 refreshToken: data.refreshToken,
//                 user: data.user
//             });

//             if (typeof window !== 'undefined') {
//                 console.log("💾 Attempting to store in localStorage...");

//                 try {
//                     localStorage.setItem('accessToken', data.accessToken);
//                     localStorage.setItem('refreshToken', data.refreshToken);
//                     localStorage.setItem('user', JSON.stringify(data.user));

//                     console.log("✅ Data stored in localStorage");

//                     // Verify storage immediately
//                     const storedToken = localStorage.getItem('accessToken');
//                     const storedUser = localStorage.getItem('user');
//                     console.log("🔍 Verification - stored data:", {
//                         token: !!storedToken,
//                         user: !!storedUser,
//                         tokenValue: storedToken,
//                         userValue: storedUser
//                     });

//                 } catch (storageError) {
//                     console.error("❌ localStorage storage failed:", storageError);
//                 }
//             } else {
//                 console.log("❌ Window not available, cannot store in localStorage");
//             }

//             console.log("✅ Login method completing successfully");
//             return data;

//         } catch (error: unknown) {
//             console.error("❌ Login method error:", error);
//             if (error instanceof Error) throw error;
//             throw new Error('Unknown error occurred during login');
//         }
//     }

//     // -----------------------
//     // Update profile (with optional avatar)
//     // -----------------------
//     async updateProfile(profileData: UpdateProfileData, avatarFile?: File): Promise<UpdateProfileResponse> {
//         try {
//             const token = this.getAuthToken();
//             if (!token) throw new Error('Not authenticated');

//             let body: BodyInit;
//             const headers: Record<string, string> = { 'Authorization': `Bearer ${token}` };

//             if (avatarFile) {
//                 const formData = new FormData();
//                 Object.entries(profileData).forEach(([key, value]) => {
//                     if (value !== undefined && value !== '') formData.append(key, value);
//                 });
//                 formData.append('avatar', avatarFile);
//                 body = formData;
//             } else {
//                 headers['Content-Type'] = 'application/json';
//                 body = JSON.stringify(profileData);
//             }

//             const response = await fetch(`${API_BASE_URL}/auth/updateProfile`, {
//                 method: 'PUT',
//                 headers,
//                 body,
//             });

//             const data: UpdateProfileResponse = await response.json();

//             if (!response.ok) throw new Error(data.message || 'Profile update failed');

//             if (data.user && typeof window !== 'undefined') {
//                 localStorage.setItem('user', JSON.stringify(data.user));
//             }

//             return data;
//         } catch (error: unknown) {
//             if (error instanceof Error) throw error;
//             throw new Error('Unknown error occurred during profile update');
//         }
//     }

//     // -----------------------
//     // Logout
//     // -----------------------
//     async logout(): Promise<void> {
//         try {
//             const refreshToken = this.getRefreshToken();
//             if (refreshToken) {
//                 await fetch(`${API_BASE_URL}/auth/logout`, {
//                     method: 'POST',
//                     headers: { 'Content-Type': 'application/json' },
//                     body: JSON.stringify({ token: refreshToken }),
//                 });
//             }
//         } catch (error) {
//             console.error('Logout API call failed:', error);
//         } finally {
//             this.clearAuthData();
//         }
//     }

//     // -----------------------
//     // Utilities with debugging
//     // -----------------------
//     getCurrentUser(): User | null {
//         if (typeof window !== 'undefined') {
//             const user = localStorage.getItem('user');
//             console.log("🔍 getCurrentUser called, raw data:", user);
//             const parsed = user ? JSON.parse(user) : null;
//             console.log("🔍 getCurrentUser parsed:", parsed);
//             return parsed;
//         }
//         return null;
//     }

//     isAuthenticated(): boolean {
//         if (typeof window !== 'undefined') {
//             const token = localStorage.getItem('accessToken');
//             console.log("🔍 isAuthenticated called, token:", !!token);
//             return !!token;
//         }
//         return false;
//     }

//     getAuthToken(): string | null {
//         if (typeof window !== 'undefined') return localStorage.getItem('accessToken');
//         return null;
//     }

//     getRefreshToken(): string | null {
//         if (typeof window !== 'undefined') return localStorage.getItem('refreshToken');
//         return null;
//     }

//     clearAuthData(): void {
//         if (typeof window !== 'undefined') {
//             localStorage.removeItem('accessToken');
//             localStorage.removeItem('refreshToken');
//             localStorage.removeItem('user');
//         }
//     }

//     isAdmin(): boolean {
//         return this.getCurrentUser()?.role === 'admin';
//     }
// }

// export const authService = new AuthService();


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
    private inMemoryStorage: { [key: string]: string } = {};

    // Storage utilities with fallbacks
    private setItem(key: string, value: string): void {
        console.log(`💾 Attempting to store ${key}:`, value.substring(0, 50) + '...');

        try {
            // Try localStorage first
            if (typeof window !== 'undefined' && window.localStorage) {
                localStorage.setItem(key, value);
                console.log(`✅ Stored ${key} in localStorage`);

                // Verify immediately
                const retrieved = localStorage.getItem(key);
                if (retrieved === value) {
                    console.log(`✅ Verified ${key} in localStorage`);
                } else {
                    console.error(`❌ Verification failed for ${key}. Expected: ${value.substring(0, 20)}, Got: ${retrieved?.substring(0, 20)}`);
                }
                return;
            }
        } catch (localError) {
            console.error(`❌ localStorage failed for ${key}:`, localError);
        }

        try {
            // Try sessionStorage as fallback
            if (typeof window !== 'undefined' && window.sessionStorage) {
                sessionStorage.setItem(key, value);
                console.log(`✅ Stored ${key} in sessionStorage (fallback)`);
                return;
            }
        } catch (sessionError) {
            console.error(`❌ sessionStorage failed for ${key}:`, sessionError);
        }

        // Use in-memory storage as last resort
        this.inMemoryStorage[key] = value;
        console.log(`✅ Stored ${key} in memory (last resort)`);
    }

    private getItem(key: string): string | null {
        try {
            // Try localStorage first
            if (typeof window !== 'undefined' && window.localStorage) {
                const value = localStorage.getItem(key);
                if (value !== null) {
                    console.log(`📖 Retrieved ${key} from localStorage`);
                    return value;
                }
            }
        } catch (error) {
            console.error(`❌ localStorage read failed for ${key}:`, error);
        }

        try {
            // Try sessionStorage
            if (typeof window !== 'undefined' && window.sessionStorage) {
                const value = sessionStorage.getItem(key);
                if (value !== null) {
                    console.log(`📖 Retrieved ${key} from sessionStorage`);
                    return value;
                }
            }
        } catch (error) {
            console.error(`❌ sessionStorage read failed for ${key}:`, error);
        }

        // Try in-memory storage
        const memoryValue = this.inMemoryStorage[key];
        if (memoryValue !== undefined) {
            console.log(`📖 Retrieved ${key} from memory`);
            return memoryValue;
        }

        console.log(`❌ No value found for ${key} in any storage`);
        return null;
    }

    private removeItem(key: string): void {
        try {
            if (typeof window !== 'undefined') {
                localStorage.removeItem(key);
                sessionStorage.removeItem(key);
            }
        } catch (error) {
            console.error(`Error removing ${key}:`, error);
        }
        delete this.inMemoryStorage[key];
    }

    // -----------------------
    // Login with storage debugging
    // -----------------------
    async login(email: string, password: string): Promise<LoginResponse> {
        console.log("🔑 AuthService.login called");

        // Test storage first
        console.log("🧪 Testing storage capabilities...");
        this.setItem('test', 'testValue');
        const testResult = this.getItem('test');
        console.log("🧪 Storage test result:", testResult);
        this.removeItem('test');

        try {
            const response = await fetch(`${API_BASE_URL}/auth/login`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email, password }),
            });

            const data: LoginResponse = await response.json();
            console.log("📥 Login response:", data);

            if (!response.ok) {
                throw new Error(data.message || 'Login failed');
            }

            // Store the auth data using our robust storage
            console.log("💾 Storing authentication data...");
            this.setItem('accessToken', data.accessToken);
            this.setItem('refreshToken', data.refreshToken);
            this.setItem('user', JSON.stringify(data.user));

            // Verify storage worked
            console.log("🔍 Post-storage verification:");
            const storedToken = this.getItem('accessToken');
            const storedUser = this.getItem('user');
            console.log("🔍 Verification results:", {
                tokenStored: !!storedToken,
                userStored: !!storedUser,
                tokenMatch: storedToken === data.accessToken,
                userMatch: storedUser === JSON.stringify(data.user)
            });

            return data;

        } catch (error: unknown) {
            console.error("❌ Login error:", error);
            if (error instanceof Error) throw error;
            throw new Error('Unknown error occurred during login');
        }
    }

    // -----------------------
    // Update profile (unchanged)
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

            if (data.user) {
                this.setItem('user', JSON.stringify(data.user));
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
    // Utilities using robust storage
    // -----------------------
    getCurrentUser(): User | null {
        const userStr = this.getItem('user');
        if (!userStr) return null;

        try {
            return JSON.parse(userStr);
        } catch (error) {
            console.error('Error parsing user data:', error);
            return null;
        }
    }

    isAuthenticated(): boolean {
        const token = this.getItem('accessToken');
        const result = !!token;
        console.log("🔍 isAuthenticated check:", { hasToken: result });
        return result;
    }

    getAuthToken(): string | null {
        return this.getItem('accessToken');
    }

    getRefreshToken(): string | null {
        return this.getItem('refreshToken');
    }

    clearAuthData(): void {
        console.log("🧹 Clearing auth data");
        this.removeItem('accessToken');
        this.removeItem('refreshToken');
        this.removeItem('user');
    }

    isAdmin(): boolean {
        return this.getCurrentUser()?.role === 'admin';
    }
}

export const authService = new AuthService();
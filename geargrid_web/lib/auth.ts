import { authService, User, LoginResponse, UpdateProfileData, UpdateProfileResponse } from '@/services/authService';

export const loginUser = async (email: string, password: string): Promise<LoginResponse> => {
    try {
        const response = await authService.login(email, password);
        return response;
    } catch (error) {
        throw error;
    }
};

export const getProfile = (): Promise<User> => {
    return authService.getProfile();
};

export const updateProfile = (profileData: UpdateProfileData, avatarFile?: File): Promise<UpdateProfileResponse> => {
    return authService.updateProfile(profileData, avatarFile);
};

export const logoutUser = (): Promise<void> => {
    return authService.logout();
};

export const getCurrentUser = (): User | null => {
    const user = authService.getCurrentUser();
    return user;
};

export const isAuthenticated = (): boolean => {
    const authenticated = authService.isAuthenticated();
    return authenticated;
};

export const getAuthToken = (): string | null => {
    return authService.getAuthToken();
};

export const isAdmin = (): boolean => {
    return authService.isAdmin();
};

export type { User, LoginResponse, UpdateProfileData, UpdateProfileResponse };
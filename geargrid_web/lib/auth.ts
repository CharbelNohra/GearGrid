import { authService, User, LoginResponse, UpdateProfileData, UpdateProfileResponse } from '@/services/authService';

export const loginUser = (email: string, password: string): Promise<LoginResponse> => {
    return authService.login(email, password);
};

export const updateProfile = (profileData: UpdateProfileData, avatarFile?: File): Promise<UpdateProfileResponse> => {
    return authService.updateProfile(profileData, avatarFile);
};

export const logoutUser = (): Promise<void> => {
    return authService.logout();
};

export const getCurrentUser = (): User | null => {
    return authService.getCurrentUser();
};

export const isAuthenticated = (): boolean => {
    return authService.isAuthenticated();
};

export const getAuthToken = (): string | null => {
    return authService.getAuthToken();
};

export const isAdmin = (): boolean => {
    return authService.isAdmin();
};

export type { User, LoginResponse, UpdateProfileData, UpdateProfileResponse };
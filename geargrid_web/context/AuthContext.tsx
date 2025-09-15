"use client";

import { createContext, useContext, useEffect, useState, ReactNode, useCallback } from "react";
import { getCurrentUser, isAuthenticated, loginUser, logoutUser, User } from "@/lib/auth";

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  refreshAuth: () => void;
  setUser: (user: User | null) => void; // <-- new
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [auth, setAuth] = useState<boolean>(false);
  const [isLoading, setIsLoading] = useState(true);

  const updateAuthFromStorage = useCallback(() => {
    if (typeof window === "undefined") return;

    try {
      const currentUser = getCurrentUser();
      const authStatus = isAuthenticated();
      setUser(currentUser);
      setAuth(authStatus);
    } catch {
      setUser(null);
      setAuth(false);
    }
  }, []);

  useEffect(() => {
    const initialize = async () => {
      await new Promise(resolve => setTimeout(resolve, 100));
      updateAuthFromStorage();
      setIsLoading(false);
    };
    initialize();
  }, [updateAuthFromStorage]);

  const login = async (email: string, password: string) => {
    try {
      setIsLoading(true);
      const response = await loginUser(email, password);

      if (response && response.user) {
        setUser(response.user);
        setAuth(true);
      } else {
        updateAuthFromStorage();
      }

      setTimeout(() => updateAuthFromStorage(), 100);
    } catch {
      setUser(null);
      setAuth(false);
      throw new Error("Login failed");
    } finally {
      setIsLoading(false);
    }
  };

  const logout = async () => {
    try {
      setIsLoading(true);
      await logoutUser();
      setUser(null);
      setAuth(false);
    } catch {
      setUser(null);
      setAuth(false);
    } finally {
      setIsLoading(false);
    }
  };

  const refreshAuth = useCallback(() => {
    updateAuthFromStorage();
  }, [updateAuthFromStorage]);

  return (
    <AuthContext.Provider
      value={{
        user,
        isAuthenticated: auth,
        isLoading,
        login,
        logout,
        refreshAuth,
        setUser,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
};
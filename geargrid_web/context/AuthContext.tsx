"use client";

import { createContext, useContext, useEffect, useState, ReactNode, useCallback } from "react";
import { getCurrentUser, isAuthenticated, loginUser, logoutUser, User } from "@/lib/auth";

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [auth, setAuth] = useState<boolean>(false);
  const [isLoading, setIsLoading] = useState(true);
  const [forceUpdate, setForceUpdate] = useState(0);

  // Function to update auth state from localStorage
  const updateAuthFromStorage = useCallback(() => {
    console.log("🔄 Updating auth state from storage...");

    if (typeof window === 'undefined') {
      console.log("❌ Window not available");
      return;
    }

    try {
      const currentUser = getCurrentUser();
      const authStatus = isAuthenticated();

      console.log("📊 Auth data from storage:", { currentUser, authStatus });

      setUser(currentUser);
      setAuth(authStatus);

      console.log("✅ React state updated");
    } catch (error) {
      console.error("❌ Error updating auth from storage:", error);
      setUser(null);
      setAuth(false);
    }
  }, []);

  // Initialize auth state on mount
  useEffect(() => {
    console.log("🚀 AuthProvider initializing...");

    const initialize = async () => {
      // Small delay to ensure localStorage is ready
      await new Promise(resolve => setTimeout(resolve, 100));
      updateAuthFromStorage();
      setIsLoading(false);
    };

    initialize();
  }, [updateAuthFromStorage]);

  // Force update when forceUpdate counter changes
  useEffect(() => {
    if (forceUpdate > 0) {
      console.log("🔄 Force update triggered:", forceUpdate);
      updateAuthFromStorage();
    }
  }, [forceUpdate, updateAuthFromStorage]);

  const login = async (email: string, password: string) => {
    console.log("🔑 AuthContext login starting...");

    try {
      setIsLoading(true);

      // Perform login
      await loginUser(email, password);
      console.log("✅ Login successful, updating state...");

      // Multiple strategies to ensure state updates:

      // 1. Immediate update
      updateAuthFromStorage();

      // 2. Delayed update
      setTimeout(() => {
        console.log("⏰ Delayed auth state update");
        updateAuthFromStorage();
      }, 50);

      // 3. Force component re-render
      setTimeout(() => {
        console.log("🔄 Force re-render");
        setForceUpdate(prev => prev + 1);
      }, 100);

    } catch (error) {
      console.error("❌ Login error:", error);
      setUser(null);
      setAuth(false);
      throw error;
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
      console.log("👋 Logged out");
    } catch (error) {
      console.error("Logout error:", error);
      setUser(null);
      setAuth(false);
    } finally {
      setIsLoading(false);
    }
  };

  // Debug: Log state changes
  useEffect(() => {
    console.log("📈 Auth state changed:", {
      user: user?.fullName || null,
      auth,
      isLoading,
      timestamp: new Date().toISOString()
    });
  }, [user, auth, isLoading]);

  return (
    <AuthContext.Provider value={{
      user,
      isAuthenticated: auth,
      isLoading,
      login,
      logout
    }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
};
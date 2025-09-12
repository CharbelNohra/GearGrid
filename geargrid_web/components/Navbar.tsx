/* eslint-disable @typescript-eslint/no-unused-vars */
"use client";

import { LogOut, Moon, Sun, User } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from "./ui/dropdown-menu";
import { Button } from "./ui/button";
import { useTheme } from "next-themes";
import { SidebarTrigger } from "./ui/sidebar";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useAuth } from "@/context/AuthContext";

const Navbar = () => {
    const { theme, setTheme } = useTheme();
    const router = useRouter();
    const { user, isAuthenticated, isLoading, logout } = useAuth();

    const handleLogout = async () => {
        await logout();
        router.push("/auth/login");
    };

    return (
        <nav className="p-4 flex items-center justify-between sticky top-0 bg-background z-10">
            {/* LEFT */}
            <SidebarTrigger />

            {/* RIGHT */}
            <div className="flex items-center gap-4">
                {/* THEME MENU */}
                <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                        <Button variant="outline" size="icon">
                            <Sun className="h-[1.2rem] w-[1.2rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
                            <Moon className="absolute h-[1.2rem] w-[1.2rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
                            <span className="sr-only">Toggle theme</span>
                        </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent sideOffset={10} align="end">
                        <DropdownMenuItem onClick={() => setTheme("light")}>Light</DropdownMenuItem>
                        <DropdownMenuItem onClick={() => setTheme("dark")}>Dark</DropdownMenuItem>
                        <DropdownMenuItem onClick={() => setTheme("system")}>System</DropdownMenuItem>
                    </DropdownMenuContent>
                </DropdownMenu>

                {/* AUTH SECTION */}
                {isLoading ? (
                    // Show loading spinner while auth state is being determined
                    <div className="w-10 h-10 rounded-full border-2 border-primary border-t-transparent animate-spin" />
                ) : isAuthenticated && user ? (
                    <DropdownMenu>
                        <DropdownMenuTrigger>
                            <Avatar className="w-8 h-8 border-1 border-secondary">
                                <AvatarImage src={user.avatar || "https://github.com/shadcn.png"} />
                                <AvatarFallback>{user.fullName?.charAt(0) || "U"}</AvatarFallback>
                            </Avatar>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent sideOffset={10} align="end">
                            <DropdownMenuLabel>My Account</DropdownMenuLabel>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem onClick={() => router.push("/auth/profile")}>
                                <User className="mr-2" />
                                Profile
                            </DropdownMenuItem>
                            <DropdownMenuItem onClick={handleLogout}>
                                <LogOut className="mr-2" />
                                Logout
                            </DropdownMenuItem>
                        </DropdownMenuContent>
                    </DropdownMenu>
                ) : (
                    <>
                        <Link href="/auth/login">
                            <Button className="shadow-xs" style={{ borderRadius: "10px" }}>
                                Login
                            </Button>
                        </Link>
                    </>
                )}
            </div>
        </nav>
    );
};

export default Navbar;
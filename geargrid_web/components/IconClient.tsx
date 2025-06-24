// components/IconClient.tsx
"use client";
import dynamic from "next/dynamic";

export const HomeIcon = dynamic(() => import("lucide-react").then(mod => mod.Home), { ssr: false });
export const InboxIcon = dynamic(() => import("lucide-react").then(mod => mod.Inbox), { ssr: false });
export const CalendarIcon = dynamic(() => import("lucide-react").then(mod => mod.Calendar), { ssr: false });
export const SearchIcon = dynamic(() => import("lucide-react").then(mod => mod.Search), { ssr: false });
export const SettingsIcon = dynamic(() => import("lucide-react").then(mod => mod.Settings), { ssr: false });
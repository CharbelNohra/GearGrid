"use client";
import dynamic from "next/dynamic";

export const DashboardIcon = dynamic(
    () => import("lucide-react").then(mod => mod.LayoutDashboard),
    { ssr: false }
);

export const NotificationIcon = dynamic(
    () => import("lucide-react").then(mod => mod.Bell),
    { ssr: false }
);

export const AddProductIcon = dynamic(
    () => import("lucide-react").then(mod => mod.PlusCircle),
    { ssr: false }
);

export const ProductsIcon = dynamic(
    () => import("lucide-react").then(mod => mod.Package),
    { ssr: false }
);

export const UsersIcon = dynamic(
    () => import("lucide-react").then(mod => mod.Users),
    { ssr: false }
);
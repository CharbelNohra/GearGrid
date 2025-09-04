"use client";

import Link from "next/link";
import { useSidebar } from "./ui/sidebar";
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupAction,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarSeparator,
} from "./ui/sidebar";
import {
  HomeIcon,
  InboxIcon,
  CalendarIcon,
  SearchIcon,
  SettingsIcon,
} from "./IconClient";
import Image from "next/image";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "./ui/dropdown-menu";
import {
  ChevronUp,
  Plus,
  Projector,
  User2,
} from "lucide-react";

const items = [
  { title: "Dashboard", url: "/dashboard", icon: HomeIcon },
  { title: "Send Notification", url: "#", icon: InboxIcon },
  { title: "Add Product", url: "#", icon: CalendarIcon },
  { title: "View Products", url: "#", icon: SearchIcon },
  { title: "View Users", url: "#", icon: SettingsIcon },
];

const AppSidebarContent = () => {
  const { state } = useSidebar();
  const collapsed = state === "collapsed";

  // 🔐 Mock auth state (replace later with your real JWT/session check)
  const isLoggedIn = false;

  // Function to handle protected links
  const getLink = (url: string) => (isLoggedIn ? url : "/auth/login");

  return (
    <Sidebar collapsible="icon">
      {/* Header / Logo */}
      <SidebarHeader className="py-4">
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton className="justify-center" size="lg" asChild>
              <Link href="/dashboard">
                {collapsed ? (
                  <Image src="/assets/svg/launcher_icon.svg" alt="icon" width={100} height={60} />
                ) : (
                  <>
                    <Image
                      src="/assets/svg/logo.svg"
                      alt="full logo"
                      width={100}
                      height={100}
                    />
                  </>
                )}
              </Link>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>

      <SidebarSeparator />

      {/* Main Sidebar Content */}
      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupLabel>Application</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {items.map((item) => (
                <SidebarMenuItem key={item.title}>
                  <SidebarMenuButton asChild>
                    <Link href={getLink(item.url)}>
                      <item.icon />
                      <span className="font-barlow">{item.title}</span>
                    </Link>
                  </SidebarMenuButton>
                </SidebarMenuItem>
              ))}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        {/* Products Section */}
        <SidebarGroup>
          <SidebarGroupLabel>Products</SidebarGroupLabel>
          <SidebarGroupAction>
            <Plus /> <span className="sr-only">Add products</span>
          </SidebarGroupAction>
          <SidebarGroupContent>
            <SidebarMenu>
              <SidebarMenuItem>
                <SidebarMenuButton asChild>
                  <Link href={getLink("/products")}>
                    <Projector />
                    See All Products
                  </Link>
                </SidebarMenuButton>
              </SidebarMenuItem>
              <SidebarMenuItem>
                <SidebarMenuButton asChild>
                  <Link href={getLink("/products/add")}>
                    <Plus />
                    Add Product
                  </Link>
                </SidebarMenuButton>
              </SidebarMenuItem>
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>

      {/* Footer (User section) */}
      <SidebarFooter>
        <SidebarMenu>
          <SidebarMenuItem>
            {isLoggedIn ? (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <SidebarMenuButton>
                    <User2 />
                    John Doe
                    <ChevronUp className="ml-auto" />
                  </SidebarMenuButton>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end">
                  <DropdownMenuItem>Account</DropdownMenuItem>
                  <DropdownMenuItem>Settings</DropdownMenuItem>
                  <DropdownMenuItem>Sign out</DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            ) : (
              <SidebarMenuButton asChild>
                <Link href="/auth/login">
                  <User2 />
                  User Name
                </Link>
              </SidebarMenuButton>
            )}
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarFooter>
    </Sidebar>
  );
};

export default AppSidebarContent;
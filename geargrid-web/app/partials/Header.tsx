"use client";

import Image from "next/image";
import Link from "next/link";
import React, { useState } from "react";
import { FaSearch, FaBars, FaTimes } from "react-icons/fa";

const Header = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const [isLoggedIn, setIsLoggedIn] = useState(true); // Change this based on authentication state

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  const toggleDropdown = () => {
    setIsDropdownOpen(!isDropdownOpen);
  };

  return (
    <nav className="bg-indigo-900 text-white shadow-md">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between py-3">
          {/* Logo */}
          <div className="flex items-center space-x-2">
            <Link href="/">
              <Image src="/logo.png" alt="Logo" width={70} height={70} />
            </Link>
            <div>
              <h1 className="text-lg sm:text-xl font-bold">GearGrid</h1>
              <p className="text-xs sm:text-sm">Power your tech</p>
            </div>
          </div>

          {/* Search Bar */}
          <div className="hidden md:flex relative flex-1 max-w-md mx-auto">
            <input
              type="text"
              placeholder="Search..."
              className="w-full bg-indigo-950 text-white rounded-full pl-10 pr-4 py-2 focus:outline-none"
            />
            <FaSearch className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-300" />
          </div>

          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center space-x-6">
            <Link href="/" className="hover:text-purple-400">Home</Link>
            <Link href="/products" className="hover:text-purple-400">Products</Link>
            <Link href="/about" className="hover:text-purple-400">About</Link>
            <Link href="/contact" className="hover:text-purple-400">Contact</Link>

            {/* Cart Icon */}
            <Link href="/cart" className="relative cursor-pointer">
              <div className="indicator flex items-center">
                <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
                <span className="badge badge-sm bg-indigo-400 text-indigo-950 font-bold absolute -top-2 -right-2 text-xs px-1">8</span>
              </div>
            </Link>

            {/* Profile Icon with Dropdown */}
            <div className="relative">
              <button onClick={toggleDropdown} className="relative cursor-pointer focus:outline-none">
                <Image width={40} height={40} className="rounded-full" alt="Avatar" src="/logo.png" />
              </button>

              {/* Dropdown Menu */}
              {isDropdownOpen && (
                <div className="absolute right-0 mt-2 w-40 bg-indigo-500 text-black rounded-lg shadow-md">
                  <Link href="/profile" className="block px-4 py-2 hover:bg-indigo-400">Profile</Link>
                  {isLoggedIn ? (
                    <Link href="/" onClick={() => setIsLoggedIn(false)} className="block px-4 py-2 hover:bg-indigo-400">Logout</Link>
                  ) : (
                    <>
                      <Link href="/login" className="block px-4 py-2 hover:bg-indigo-400">Login</Link>
                      <Link href="/register" className="block px-4 py-2 hover:bg-indigo-400">Register</Link>
                    </>
                  )}
                </div>
              )}
            </div>
          </div>

          {/* Mobile Menu Button */}
          <button className="md:hidden cursor-pointer text-2xl" onClick={toggleMenu}>
            {isMenuOpen ? <FaTimes /> : <FaBars />}
          </button>
        </div>
      </div>

      {/* Mobile Menu */}
      <div
        className={`fixed inset-0 bg-indigo-900 transition-transform transform ${isMenuOpen ? "translate-x-0" : "-translate-x-full"
          } md:hidden flex flex-col items-center justify-center space-y-6 text-lg font-semibold z-100`}
      >
        {/* Close Button */}
        <button
          className="absolute top-4 right-4 text-white text-3xl cursor-pointer"
          onClick={toggleMenu}
        >
          <FaTimes />
        </button>
        <Link href="/" className="hover:text-purple-400" onClick={toggleMenu}>Home</Link>
        <Link href="/products" className="hover:text-purple-400" onClick={toggleMenu}>Products</Link>
        <Link href="/about" className="hover:text-purple-400" onClick={toggleMenu}>About</Link>
        <Link href="/contact" className="hover:text-purple-400" onClick={toggleMenu}>Contact</Link>
        <Link href="/cart" className="hover:text-purple-400" onClick={toggleMenu}>Cart</Link>
        <Link href="/profile" className="hover:text-purple-400" onClick={toggleMenu}>Profile</Link>
        {isLoggedIn ? (
          <Link href="/" className="hover:text-purple-400" onClick={toggleMenu}>Logout</Link>
        ) : (
          <>
            <Link href="/login" className="hover:text-purple-400" onClick={toggleMenu}>Login</Link>
            <Link href="/register" className="hover:text-purple-400" onClick={toggleMenu}>Register</Link>
          </>
        )}
      </div>
    </nav>
  );
};

export default Header;

import Image from "next/image";
import Link from "next/link";
import React from "react";
import { FaInstagram, FaLinkedin } from "react-icons/fa";

const Footer = () => {
  return (
    <footer className="bg-indigo-900 text-white py-10 px-6">
      <div className="container mx-auto flex flex-col items-center space-y-6 md:space-y-0 md:flex-row md:justify-between">
        
        {/* Logo and Branding */}
        <div className="flex flex-col items-center md:items-start">
          <Link href="/">
            <Image src="/logo.png" alt="GearGrid Logo" width={120} height={120} />
          </Link>
          <h2 className="text-xl font-bold mt-2">GearGrid</h2>
          <p className="text-sm font-semibold">Your tech partner</p>
          <p className="text-sm">Providing reliable tech since 2025</p>
        </div>

        {/* Navigation Links */}
        <nav className="text-center md:text-left">
          <ul className="flex flex-col md:flex-row space-y-2 md:space-y-0 md:space-x-6">
            <li><Link href="/" className="hover:text-purple-400 transition">Home</Link></li>
            <li><Link href="/products" className="hover:text-purple-400 transition">Products</Link></li>
            <li><Link href="/about" className="hover:text-purple-400 transition">About</Link></li>
            <li><Link href="/contact" className="hover:text-purple-400 transition">Contact</Link></li>
          </ul>
        </nav>

        {/* Social Media Links */}
        <div className="flex space-x-4">
          <a href="https://www.instagram.com/ch.nohra04" target="_blank" rel="noopener noreferrer" className="hover:text-purple-400 transition">
            <FaInstagram size={20} />
          </a>
          <a href="https://www.linkedin.com/in/charbel-nohra04" target="_blank" rel="noopener noreferrer" className="hover:text-purple-400 transition">
            <FaLinkedin size={20} />
          </a>
        </div>
      </div>

      {/* Copyright Section */}
      <div className="text-center text-sm mt-6">
        <p>© {new Date().getFullYear()} GearGrid. All rights reserved.</p>
      </div>
    </footer>
  );
};

export default Footer;

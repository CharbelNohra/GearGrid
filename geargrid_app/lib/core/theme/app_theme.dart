import 'package:flutter/material.dart';
import 'package:geargrid/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  primaryColor: const Color(0xFF8B5CF6),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF8B5CF6),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFF3F0FF),
    onSecondary: Color(0xFF4338CA),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF), // use instead of background
    onSurface: Color(0xFF312E81),
  ), // your existing setup
  textTheme: GoogleFonts.robotoTextTheme(),
  fontFamily: 'Roboto',
  useMaterial3: true,
  extensions: [
    const AppColors(
      card: Color(0xFFF3F0FF),
      cardForeground: Color(0xFF312E81),
      popover: Color(0xFFF3F0FF),
      popoverForeground: Color(0xFF312E81),
      muted: Color(0xFFE0E7FF),
      mutedForeground: Color(0xFF4338CA),
      border: Color(0xFFD1D5DB),
      input: Color(0xFFD1D5DB),
      ring: Color(0xFF8B5CF6),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      sidebarBackground: Color(0xFFFFFFFF),
      sidebarForeground: Color(0xFF0F172A),
      sidebarPrimary: Color(0xFF8B5CF6),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF4338CA),
      sidebarAccentForeground: Color(0xFFFFFFFF),
      sidebarBorder: Color(0xFFD1D5DB),
      sidebarRing: Color(0xFF8B5CF6),
    ),
  ],
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  primaryColor: const Color(0xFF8B5CF6),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF8B5CF6),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF1E1B4B),
    onSecondary: Color(0xFFE0E7FF),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFF1E1B4B), // replaces background
    onSurface: Color(0xFFE0E7FF),
  ),
  textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
  fontFamily: 'Roboto',
  useMaterial3: true,
  extensions: [
    const AppColors(
      card: Color(0xFF1E1B4B),
      cardForeground: Color(0xFFE0E7FF),
      popover: Color(0xFF1E1B4B),
      popoverForeground: Color(0xFFE0E7FF),
      muted: Color(0xFF1E1B4B),
      mutedForeground: Color(0xFFC4B5FD),
      border: Color(0xFF2E1065),
      input: Color(0xFF2E1065),
      ring: Color(0xFF8B5CF6),
      destructive: Color(0xFFEF4444),
      destructiveForeground: Color(0xFFFFFFFF),
      sidebarBackground: Color(0xFF0F172A),
      sidebarForeground: Color(0xFFE0E7FF),
      sidebarPrimary: Color(0xFF8B5CF6),
      sidebarPrimaryForeground: Color(0xFFFFFFFF),
      sidebarAccent: Color(0xFF4338CA),
      sidebarAccentForeground: Color(0xFFE0E7FF),
      sidebarBorder: Color(0xFF2E1065),
      sidebarRing: Color(0xFF8B5CF6),
    ),
  ],
);

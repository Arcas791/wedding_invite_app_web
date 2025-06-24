import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF5EBDD), // fondo suave
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.brown[800],
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.brown[700],
        ),
        bodyLarge: GoogleFonts.openSans(
          fontSize: 18,
          color: Colors.brown[900],
        ),
        bodyMedium: GoogleFonts.openSans(
          fontSize: 16,
          color: Colors.brown[800],
        ),
        labelLarge: GoogleFonts.openSans(
          fontSize: 14,
          color: Colors.brown[600],
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFFB08E8E), // acento rosa palo/marrón suave
        secondary: const Color(0xFFD9B8B8),
      ),
      useMaterial3: true,
    );
  }
}

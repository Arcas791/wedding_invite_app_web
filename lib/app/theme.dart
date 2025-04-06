import 'package:flutter/material.dart';

final ThemeData weddingTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFEFD9CE), // tono pastel rosado
    brightness: Brightness.light,
  ),
  fontFamily: 'Georgia',
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 20),
    bodyMedium: TextStyle(fontSize: 16),
  ),
  useMaterial3: true,
);

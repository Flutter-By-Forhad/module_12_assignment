import 'package:flutter/material.dart';
import 'calculator_screen.dart';   // <-- IMPORT THE SCREEN

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool _isDark = false;          // <-- simple in-memory flag

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: CalculatorScreen(onThemeToggle: _toggleTheme),
    );
  }
}
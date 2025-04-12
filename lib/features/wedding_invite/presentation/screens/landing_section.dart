import 'package:flutter/material.dart';
import 'dart:async';

class LandingSection extends StatefulWidget {
  const LandingSection({super.key});

  @override
  State<LandingSection> createState() => _LandingSectionState();
}

class _LandingSectionState extends State<LandingSection> {
  late Duration _remaining;
  late Timer _timer;

  final DateTime weddingDate =
      DateTime(2025, 9, 19, 18, 0); // 29 junio 2025 a las 18:00

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    final now = DateTime.now();
    setState(() {
      _remaining = weddingDate.difference(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    return '$days días, $hours h, $minutes m, $seconds s';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/novios.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Belén & Dani',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                '19 • Septiembre • 2025',
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              const SizedBox(height: 30),
              Text(
                _format(_remaining),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}

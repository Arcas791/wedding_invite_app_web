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
      DateTime(2025, 9, 19, 18, 0); // 19 sept 2025 a las 18:00

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
    final double sectionHeight = MediaQuery.of(context).size.height * 0.95;

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: sectionHeight,
          child: Image.asset(
            'assets/images/novios.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: sectionHeight,
          color: Colors.black.withOpacity(0.3),
        ),
        SizedBox(
          height: sectionHeight,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¡Nos casamos!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  _format(_remaining),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

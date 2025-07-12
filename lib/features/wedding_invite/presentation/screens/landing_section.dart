import 'package:flutter/material.dart';
import 'dart:async';

class LandingSection extends StatefulWidget {
  final VoidCallback onMusicaConsentida;

  const LandingSection({super.key, required this.onMusicaConsentida});

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mostrarPopupMusica();
    });
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

  Future<void> _mostrarPopupMusica() async {
    final activar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        //title: const Text('¿Activar música de fondo?'),
        content: const Text(
          '¿Quieres ver la invitación con buena música? ^^',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sí'),
          ),
        ],
      ),
    );

    if (activar == true) {
      widget.onMusicaConsentida();
    }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Column(
                    children: [
                      Text(
                        '¡Nos casamos!',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _format(_remaining),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              fontSize: 24,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

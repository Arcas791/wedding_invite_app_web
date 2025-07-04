import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'landing_section.dart';
import 'story_section.dart';
import 'wedding_plan_section.dart';
import 'venue_section.dart';
import 'rsvp_section.dart';
import 'fake_credit_section.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key});

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _musicaIniciada = false;
  bool formEnviado = false;

  @override
  void initState() {
    super.initState();

    // Precarga de imágenes tras montar el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precargarImagenes();
      _iniciarMusica();
    });
  }

  void _precargarImagenes() {
    precacheImage(const AssetImage('assets/images/novios.jpg'), context);
    precacheImage(const AssetImage('assets/images/historia1.jpg'), context);
    precacheImage(const AssetImage('assets/images/historia2.jpg'), context);
    precacheImage(const AssetImage('assets/images/masia.jpg'), context);
  }

  Future<void> _iniciarMusica() async {
    if (_musicaIniciada) return;
    await _audioPlayer.setAsset('assets/audio/entrada.mp3');
    _audioPlayer.play();
    setState(() => _musicaIniciada = true);
  }

  void onFormularioEnviado() {
    setState(() {
      formEnviado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBDD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LandingSection(),
            const StorySection(),
            const WeddingPlanSection(),
            const VenueSection(),
            RsvpSection(onConfirmado: onFormularioEnviado),
            if (formEnviado) const FakeCreditSection(),
          ],
        ),
      ),
    );
  }
}

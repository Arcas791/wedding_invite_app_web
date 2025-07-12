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

class _InvitationScreenState extends State<InvitationScreen>
    with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _musicaIniciada = false;
  bool _musicaIniciandose = false;
  bool formEnviado = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Precarga de imágenes tras montar el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precargarImagenes();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }

  void _precargarImagenes() {
    precacheImage(const AssetImage('assets/images/novios.jpg'), context);
    precacheImage(const AssetImage('assets/images/masia.jpg'), context);
  }

  Future<void> _iniciarMusica() async {
    if (_musicaIniciada || _musicaIniciandose) return;

    _musicaIniciandose = true;
    print("🎵 Intentando iniciar música...");

    try {
      await _audioPlayer.setAsset('assets/audio/entrada.mp3');
      await _audioPlayer.play();
      setState(() {
        _musicaIniciada = true;
      });
      print("🎵 Música iniciada correctamente.");
    } catch (e) {
      print('❌ Error al reproducir música: $e');
    } finally {
      _musicaIniciandose = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _audioPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (_musicaIniciada) _audioPlayer.play();
    }
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
      body: Listener(
        onPointerDown: (_) => _iniciarMusica(), // Clic/tap
        onPointerSignal: (_) => _iniciarMusica(), // Scroll de ratón
        child: NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            _iniciarMusica(); // Scroll táctil o de trackpad
            return false;
          },
          child: SingleChildScrollView(
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
        ),
      ),
    );
  }
}

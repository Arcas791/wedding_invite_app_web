import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'landing_section.dart';
import 'story_section.dart';
import 'wedding_plan_section.dart';
import 'venue_section.dart';
import 'rsvp_section.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key});

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final PageController _controller = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _musicaIniciada = false;

  final List<Widget> _pages = const [
    LandingSection(),
    StorySection(),
    WeddingPlanSection(),
    VenueSection(),
    RsvpSection(),
  ];

  @override
  void initState() {
    super.initState();

    // Precarga de imágenes tras montar el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precargarImagenes();
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

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanDown: (_) => _iniciarMusica(),
        child: PageView.builder(
          controller: _controller,
          scrollDirection: Axis.vertical,
          itemCount: _pages.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double value = 1.0;

                if (_controller.position.hasContentDimensions) {
                  value = _controller.page! - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                }

                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: _pages[index],
                  ),
                );
              },
              child: _pages[index],
            );
          },
        ),
      ),
    );
  }
}

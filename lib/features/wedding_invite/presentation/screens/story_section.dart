import 'package:flutter/material.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFF8EDEB), // fondo pastel
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Nuestra historia',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D6875),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PageView(
              children: [
                Image.asset('assets/images/historia1.jpg', fit: BoxFit.cover),
                Image.asset('assets/images/historia2.jpg', fit: BoxFit.cover),
                Image.asset('assets/images/historia3.jpg', fit: BoxFit.cover),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nos conocimos hace unos años...\nY desde entonces, cada paso nos ha traído hasta aquí.\nGracias por acompañarnos en este día tan especial.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFF444444)),
          ),
        ],
      ),
    );
  }
}

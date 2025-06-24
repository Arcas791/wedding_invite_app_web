import 'package:flutter/material.dart';

class FakeCreditSection extends StatelessWidget {
  const FakeCreditSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'By...',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/el_barto.jpg',
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'No, es broma...\nLa hice en un par de ratos, así que espero que os guste.\nY si no es así... las quejas a Belén :)',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

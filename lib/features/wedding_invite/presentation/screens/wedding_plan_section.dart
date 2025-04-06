import 'package:flutter/material.dart';

class WeddingPlanSection extends StatelessWidget {
  const WeddingPlanSection({super.key});

  @override
  Widget build(BuildContext context) {
    final eventos = [
      {'hora': '18:00', 'evento': 'Ceremonia'},
      {'hora': '19:00', 'evento': 'Cóctel'},
      {'hora': '21:00', 'evento': 'Cena'},
      {'hora': '23:00', 'evento': 'Fiesta 🎉'},
    ];

    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFFDEDEC), // fondo pastel suave
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          const Text(
            'Planning del día',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D6875),
            ),
          ),
          const SizedBox(height: 30),
          Column(
            children: eventos.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e['hora']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D6875),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        e['evento']!,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

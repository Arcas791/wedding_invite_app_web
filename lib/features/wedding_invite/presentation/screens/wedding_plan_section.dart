import 'package:flutter/material.dart';

class WeddingPlanSection extends StatefulWidget {
  const WeddingPlanSection({super.key});

  @override
  State<WeddingPlanSection> createState() => _WeddingPlanSectionState();
}

class _WeddingPlanSectionState extends State<WeddingPlanSection>
    with TickerProviderStateMixin {
  final List<_Evento> eventos = [
    _Evento('18:00', 'Ceremonia', Icons.church),
    _Evento('19:00', 'Cóctel', Icons.local_bar),
    _Evento('21:00', 'Cena', Icons.restaurant),
    _Evento('23:00', 'Fiesta 🎉', Icons.music_note),
  ];

  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _offsetAnimations = [];
  final List<bool> _activo = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < eventos.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      final animation = Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      _controllers.add(controller);
      _offsetAnimations.add(animation);
      _activo.add(false);

      Future.delayed(Duration(milliseconds: i * 500), () {
        controller.forward();
        setState(() {
          _activo[i] = true;
        });
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Text(
            'Planning del día',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Stack(
            children: [
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: Colors.grey.shade300,
                ),
              ),
              Column(
                children: List.generate(eventos.length, (index) {
                  final evento = eventos[index];
                  return SlideTransition(
                    position: _offsetAnimations[index],
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Punto animado
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _activo[index]
                                  ? primary
                                  : Colors.grey.shade400,
                              boxShadow: _activo[index]
                                  ? [
                                      BoxShadow(
                                        color: primary.withOpacity(0.4),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    evento.icono,
                                    color: primary,
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        evento.hora,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        evento.nombre,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Evento {
  final String hora;
  final String nombre;
  final IconData icono;

  _Evento(this.hora, this.nombre, this.icono);
}

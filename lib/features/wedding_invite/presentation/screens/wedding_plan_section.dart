import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WeddingPlanSection extends StatefulWidget {
  const WeddingPlanSection({super.key});

  @override
  State<WeddingPlanSection> createState() => _WeddingPlanSectionState();
}

class _WeddingPlanSectionState extends State<WeddingPlanSection>
    with TickerProviderStateMixin {
  final List<_Evento> eventos = [
    _Evento('18:00', 'Ceremonia', Icons.volunteer_activism),
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
        duration: const Duration(milliseconds: 1000),
      );
      final animation = Tween<Offset>(
        begin: const Offset(0, 0.9),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      _controllers.add(controller);
      _offsetAnimations.add(animation);
      _activo.add(false);
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
                left:
                    24, // estaba en 16, ahora centrada dentro del espacio de 48
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
                  return VisibilityDetector(
                    key: Key('evento_$index'),
                    onVisibilityChanged: (info) {
                      if (info.visibleFraction > 0.1 && !_activo[index]) {
                        _controllers[index].forward().then((_) {
                          setState(() {
                            _activo[index] = true;
                          });
                        });
                      }
                    },
                    child: SlideTransition(
                      position: _offsetAnimations[index],
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🟣 Punto animado centrado sobre la línea
                            Container(
                              width: 48,
                              alignment: Alignment.center,
                              child: AnimatedContainer(
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
                            ),
                            const SizedBox(width: 8),
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
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: Icon(
                                        evento.icono,
                                        key: ValueKey(_activo[index]),
                                        color: _activo[index]
                                            ? primary
                                            : Colors.grey.shade400,
                                      ),
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

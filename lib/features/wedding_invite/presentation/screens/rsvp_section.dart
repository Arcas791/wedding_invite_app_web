import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/rsvp.dart';
import '../../domain/usecases/confirm_rsvp.dart';
import '../../data/repositories/rsvp_repository_impl.dart';

class RsvpSection extends StatefulWidget {
  final VoidCallback onConfirmado;

  const RsvpSection({super.key, required this.onConfirmado});

  @override
  State<RsvpSection> createState() => _RsvpSectionState();
}

class _RsvpSectionState extends State<RsvpSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _songsController = TextEditingController();
  final _childrenCountController = TextEditingController();
  final _companionNameController = TextEditingController();

  bool attending = false;
  bool needsBus = false;
  String? selectedBus;
  bool hasCompanion = false;
  bool hasChildren = false;
  bool wantsTomorrowland = false;
  bool formSubmitted = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final rsvp = Rsvp(
        name: _nameController.text + " " + _surnameController.text,
        isAttending: attending,
        allergies: _allergiesController.text,
        songRequests: _songsController.text,
        children: hasChildren ? _childrenCountController.text : '',
        tomorrowland: wantsTomorrowland,
      );

      final repository = RsvpRepositoryImpl();
      final usecase = ConfirmRsvp(repository);

      await usecase.execute(rsvp);

      setState(() {
        formSubmitted = true;
      });

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('¡Gracias!'),
          content: const Text('Hemos recibido tu confirmación.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );

      widget.onConfirmado();
    }
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Divider(color: Colors.grey.shade400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Confirma tu asistencia', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Nombre y Apellidos
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Introduce tu nombre'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _surnameController,
                        decoration:
                            const InputDecoration(labelText: 'Apellidos'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Introduce tus apellidos'
                            : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Asistencia
                CheckboxListTile(
                  value: attending,
                  onChanged: (value) {
                    setState(() {
                      attending = value!;
                      if (!attending) {
                        needsBus = false;
                        selectedBus = null;
                      }
                    });
                  },
                  title: const Text('Voy a asistir'),
                ),

                if (attending)
                  CheckboxListTile(
                    value: needsBus,
                    onChanged: (value) => setState(() {
                      needsBus = value!;
                      if (!needsBus) selectedBus = null;
                    }),
                    title: const Text('Necesito autobús'),
                  ),

                if (attending && needsBus)
                  Column(
                    children: [
                      RadioListTile(
                        value: 'valencia',
                        groupValue: selectedBus,
                        onChanged: (value) =>
                            setState(() => selectedBus = value as String?),
                        title: const Text('Autobús desde Valencia'),
                      ),
                      RadioListTile(
                        value: 'viver',
                        groupValue: selectedBus,
                        onChanged: (value) =>
                            setState(() => selectedBus = value as String?),
                        title: const Text('Autobús desde Viver'),
                      ),
                    ],
                  ),

                // Acompañante
                CheckboxListTile(
                  value: hasCompanion,
                  onChanged: (value) => setState(() => hasCompanion = value!),
                  title: const Text('Voy con acompañante'),
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: hasCompanion
                      ? Padding(
                          padding: EdgeInsets.only(left: 24.0),
                          child: TextFormField(
                            controller: _companionNameController,
                            decoration: const InputDecoration(
                                labelText: 'Nombre del acompañante'),
                            validator: (value) {
                              if (hasCompanion &&
                                  (value == null || value.isEmpty)) {
                                return 'Introduce el nombre del acompañante';
                              }
                              return null;
                            },
                          ),
                        )
                      : SizedBox.shrink(),
                ),

                // Niños
                CheckboxListTile(
                  value: hasChildren,
                  onChanged: (value) => setState(() => hasChildren = value!),
                  title: const Text('Vamos con niños'),
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: hasChildren
                      ? Padding(
                          padding: EdgeInsets.only(left: 24.0),
                          child: TextFormField(
                            controller: _childrenCountController,
                            decoration: const InputDecoration(
                                labelText: '¿Cuántos niños?'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (hasChildren &&
                                  (value == null || value.isEmpty)) {
                                return 'Indica cuántos niños';
                              }
                              return null;
                            },
                          ),
                        )
                      : SizedBox.shrink(),
                ),

                const SizedBox(height: 24),

                // Alergias y canciones
                TextFormField(
                  controller: _allergiesController,
                  decoration: const InputDecoration(
                      labelText: 'Alergias o preferencias'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _songsController,
                  decoration: const InputDecoration(
                      labelText: 'Canciones que no pueden faltar'),
                ),

                const SizedBox(height: 16),
                CheckboxListTile(
                  value: wantsTomorrowland,
                  onChanged: (value) =>
                      setState(() => wantsTomorrowland = value!),
                  title: const Text('¡Me apunto a Tomorrowland!'),
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Confirmar'),
                ),
              ],
            ),
          ),
          if (formSubmitted) ...[
            const SizedBox(height: 40),
            Text(
              'Si quieres hacernos un regalito, aquí tienes nuestro número de cuenta 😉:',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            SelectableText(
              'ES12 3456 7890 1234 5678 9012',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

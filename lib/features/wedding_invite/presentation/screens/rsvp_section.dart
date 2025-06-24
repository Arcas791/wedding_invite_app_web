import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/rsvp.dart';
import '../../domain/usecases/confirm_rsvp.dart';
import '../../data/repositories/rsvp_repository_impl.dart';

class RsvpSection extends StatefulWidget {
  const RsvpSection({super.key});

  @override
  State<RsvpSection> createState() => _RsvpSectionState();
}

class _RsvpSectionState extends State<RsvpSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _songsController = TextEditingController();
  final _childrenController = TextEditingController();
  bool attending = true;
  bool wantsTomorrowland = false;
  bool formSubmitted = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final rsvp = Rsvp(
        name: _nameController.text,
        isAttending: attending,
        allergies: _allergiesController.text,
        songRequests: _songsController.text,
        children: _childrenController.text,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Confirma tu asistencia',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Por favor, introduce tu nombre'
                      : null,
                ),
                const SizedBox(height: 16),
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
                TextFormField(
                  controller: _childrenController,
                  decoration:
                      const InputDecoration(labelText: 'Número de niños'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: attending,
                  onChanged: (value) => setState(() => attending = value!),
                  title: const Text('Voy a asistir'),
                ),
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Confirmar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

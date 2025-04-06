import 'package:flutter/material.dart';
import '../../domain/entities/rsvp.dart';
import '../../domain/usecases/confirm_rsvp.dart';
import '../../data/repositories/fake_rsvp_repository.dart';


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
  bool attending = true;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final rsvp = Rsvp(
        name: _nameController.text,
        isAttending: attending,
        allergies: _allergiesController.text,
        songRequests: _songsController.text,
      );

      final repository = FakeRsvpRepository();
      final usecase = ConfirmRsvp(repository);

      await usecase.execute(rsvp);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('¡Gracias!'),
          content: const Text('Tu respuesta ha sido registrada 🥰'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );

      _formKey.currentState!.reset();
      _nameController.clear();
      _allergiesController.clear();
      _songsController.clear();
      setState(() => attending = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFF6F2EB),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                '¿Vendrás a celebrarlo con nosotros?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D6875),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tu nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Por favor, escribe tu nombre' : null,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('¿Asistirás?'),
              value: attending,
              onChanged: (value) => setState(() => attending = value),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _allergiesController,
              decoration: const InputDecoration(
                labelText: 'Alergias o intolerancias',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _songsController,
              decoration: const InputDecoration(
                labelText: 'Peticiones musicales',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Confirmar asistencia'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

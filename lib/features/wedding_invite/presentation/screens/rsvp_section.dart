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
          tomorrowland: wantsTomorrowland
          // puedes añadir los nuevos campos en la entidad si quieres persistirlos
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
      _childrenController.clear();
      setState(() {
        attending = true;
        wantsTomorrowland = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Container(
      width: double.infinity,
      color: const Color(0xFFF6F2EB),
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: isWide ? 100 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _childrenController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: '¿Cuántos niños asistirán?',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text(
                      '¿Te apuntarías el año que viene al Tomorrowland?'),
                  value: wantsTomorrowland,
                  onChanged: (value) =>
                      setState(() => wantsTomorrowland = value ?? false),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Confirmar asistencia'),
                  ),
                ),
                const SizedBox(height: 30),
                if (formSubmitted)
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text('Número de cuenta para regalito 💌:'),
                        SizedBox(height: 8),
                        SelectableText(
                          'ES76 1234 5678 9012 3456 7890',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

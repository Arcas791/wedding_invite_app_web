import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../domain/entities/rsvp.dart';
import '../../domain/usecases/confirm_rsvp.dart';
import '../../data/repositories/rsvp_repository_impl.dart';

class RsvpSection extends StatefulWidget {
  final VoidCallback onConfirmado;

  const RsvpSection({super.key, required this.onConfirmado});

  @override
  State<RsvpSection> createState() => _RsvpSectionState();
}

class _RsvpSectionState extends State<RsvpSection>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _songsController = TextEditingController();
  final _childrenCountController = TextEditingController();
  final _companionNameController = TextEditingController();
  List<TextEditingController> _childNameControllers = [];
  List<TextEditingController> _childAgeControllers = [];

  bool attending = false;
  bool needsBus = false;
  String? selectedBus;
  bool hasCompanion = false;
  bool hasChildren = false;
  bool wantsTomorrowland = false;
  bool formSubmitted = false;
  bool isSubmitting = false;
  bool _visible = false;

  late final AnimationController _submitAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _submitAnimationController.dispose();
    _controller.dispose();
    for (var c in _childNameControllers) {
      c.dispose();
    }
    for (var c in _childAgeControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
        _submitAnimationController.repeat();
      });

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
        isSubmitting = false;
        _submitAnimationController.stop();
        _currentStep = 3;
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

  void _handleStepContinue() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep == 1 && !attending) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('¿Seguro que no podrás asistir? :('),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _submitForm();
                },
                child: const Text('Sí, confirmar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Volver'),
              ),
            ],
          ),
        );
      } else {
        setState(() => _currentStep += 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VisibilityDetector(
            key: const Key('rsvp_section_intro'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.1 && !_visible) {
                _controller.forward();
                setState(() => _visible = true);
              }
            },
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Confirma tu asistencia 💌',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Si quieres hacernos un regalito, aquí tienes nuestro número de cuenta 😉:',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      'ES12 3456 7890 1234 5678 9012',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: _handleStepContinue,
              onStepCancel: () {
                if (_currentStep > 0 && !formSubmitted) {
                  setState(() => _currentStep -= 1);
                }
              },
              steps: getSteps(),
              controlsBuilder: (context, details) => Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0 && !formSubmitted)
                      ElevatedButton(
                        onPressed: details.onStepCancel,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Text('Atrás'),
                      )
                    else
                      const SizedBox(),
                    if (_currentStep < getSteps().length - 1 && !formSubmitted)
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text('Continuar'),
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Step> getSteps() {
    int childCount = int.tryParse(_childrenCountController.text) ?? 0;
    if (childCount > 3) childCount = 3;

    if (_childNameControllers.length != childCount) {
      _childNameControllers =
          List.generate(childCount, (_) => TextEditingController());
      _childAgeControllers =
          List.generate(childCount, (_) => TextEditingController());
    }

    return [
      Step(
        title: Row(
          children: const [
            Icon(Icons.person),
            SizedBox(width: 8),
            Text('Datos personales')
          ],
        ),
        content: Row(
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
                decoration: const InputDecoration(labelText: 'Apellidos'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Introduce tus apellidos'
                    : null,
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Row(
          children: const [
            Icon(Icons.event_available),
            SizedBox(width: 8),
            Text('Asistencia y transporte')
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: needsBus,
                      onChanged: (value) => setState(() {
                        needsBus = value!;
                        if (!needsBus) selectedBus = null;
                      }),
                      title: const Text('Necesito autobús'),
                    ),
                    if (needsBus)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Column(
                          children: [
                            RadioListTile(
                              value: 'valencia',
                              groupValue: selectedBus,
                              onChanged: (value) => setState(
                                  () => selectedBus = value as String?),
                              title: const Text('Autobús desde Valencia'),
                            ),
                            RadioListTile(
                              value: 'viver',
                              groupValue: selectedBus,
                              onChanged: (value) => setState(
                                  () => selectedBus = value as String?),
                              title: const Text('Autobús desde Viver'),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Row(
          children: const [
            Icon(Icons.family_restroom),
            SizedBox(width: 8),
            Text('Acompañante y niños')
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              value: hasCompanion,
              onChanged: (value) => setState(() => hasCompanion = value!),
              title: const Text('Voy con acompañante'),
            ),
            if (hasCompanion)
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: TextFormField(
                  controller: _companionNameController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre del acompañante'),
                  validator: (value) {
                    if (hasCompanion && (value == null || value.isEmpty)) {
                      return 'Introduce el nombre del acompañante';
                    }
                    return null;
                  },
                ),
              ),
            CheckboxListTile(
              value: hasChildren,
              onChanged: (value) => setState(() => hasChildren = value!),
              title: const Text('Vamos con niños'),
            ),
            if (hasChildren)
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _childrenCountController,
                      decoration: const InputDecoration(
                          labelText: '¿Cuántos niños? (máx. 3)'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (hasChildren && (value == null || value.isEmpty)) {
                          return 'Indica cuántos niños';
                        }
                        if (int.tryParse(value!) != null &&
                            int.parse(value) > 3) {
                          return 'Máximo 3 niños';
                        }
                        return null;
                      },
                    ),
                    for (int i = 0; i < childCount; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _childNameControllers[i],
                                decoration: InputDecoration(
                                    labelText: 'Nombre niño/a ${i + 1}'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 80,
                              child: TextFormField(
                                controller: _childAgeControllers[i],
                                decoration:
                                    const InputDecoration(labelText: 'Edad'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Row(
          children: const [
            Icon(Icons.music_note),
            SizedBox(width: 8),
            Text('Extras')
          ],
        ),
        content: formSubmitted
            ? const SizedBox.shrink()
            : Column(
                children: [
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
                    onPressed: isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                              valueColor: _submitAnimationController.drive(
                                ColorTween(
                                    begin: Colors.white38, end: Colors.white),
                              ),
                            ),
                          )
                        : const Text('Confirmar'),
                  ),
                ],
              ),
        isActive: _currentStep >= 3,
        state: formSubmitted ? StepState.complete : StepState.indexed,
      ),
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formRegisterKey = GlobalKey<FormState>();
  final TextEditingController _dateBirth = TextEditingController();
  final TextEditingController _names = TextEditingController();
  final TextEditingController _surnames = TextEditingController();
  bool _canContinue = false;
  bool _isFormValid() {
    return _names.text.isNotEmpty &&
        _surnames.text.isNotEmpty &&
        _dateBirth.text.isNotEmpty;
  }

  List<Step> stepList() => [
        Step(
            state:
                _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 0,
            title: const Text('PASO 1'),
            content: Form(
              key: _formRegisterKey,
              child: Column(children: [
                const Text('Datos personales',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _names,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Campo requerido.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _canContinue = _isFormValid();
                    });
                  },
                  decoration: InputDecoration(
                      icon: const Icon(Icons.person_outline_sharp),
                      hintText: 'Nombres',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _surnames,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Campo requerido.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _canContinue = _isFormValid();
                    });
                  },
                  decoration: InputDecoration(
                      icon: const Icon(Icons.person_outline_sharp),
                      hintText: 'Apellidos',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateBirth,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Campo requerido.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _canContinue = _isFormValid();
                    });
                  },
                  decoration: InputDecoration(
                      icon: const Icon(Icons.date_range),
                      hintText: 'Fecha de nacimiento',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onTap: () async {
                    DateTime? pickDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                    );
                    if (pickDate != null) {
                      setState(() {
                        _dateBirth.text =
                            DateFormat('dd/MM/yyyy').format(pickDate);
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
              ]),
            )),
        Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text('PASO 2'),
          content: Column(children: const [
            Text('¿Cual es tu correo electrónico?',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                //controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Correo',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
          ]),
        ),
        Step(
          state: _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: const Text('PASO 3'),
          content: Column(children: const [
            Text('Crea tu contraseña',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            SizedBox(height: 20),
            Text('Debe contener al menos 6 caracteres.'),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                //controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
          ]),
        )
      ];
  int _activeStepIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Registrate'),
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: Stepper(
        controlsBuilder:
            (BuildContext context, ControlsDetails controlsDetails) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: controlsDetails.onStepContinue,
                child: const Text('Continuar'),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: controlsDetails.onStepCancel,
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.grey)),
              ),
            ],
          );
        },
        steps: stepList(),
        type: StepperType.horizontal,
        currentStep: _activeStepIndex,
        onStepContinue: _canContinue
            ? () {
                if (_activeStepIndex < (stepList().length - 1)) {
                  _activeStepIndex += 1;
                }
                setState(() {
                  if (_activeStepIndex == 0 && !_isFormValid()) {
                    return;
                  }
                });
              }
            : null,
        onStepCancel: () {
          if (_activeStepIndex == 0) {
            return;
          }
          _activeStepIndex -= 1;
          setState(() {});
        },
      ),
    );
  }
}

import 'package:addmental/ui/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:addmental/model/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  //final Usuario _user = Usuario();
  final _formStepOneKey = GlobalKey<FormState>();
  final _formStepTwoKey = GlobalKey<FormState>();
  final _formStepThreeKey = GlobalKey<FormState>();
  final TextEditingController _birthDate = TextEditingController();
  final TextEditingController _names = TextEditingController();
  final TextEditingController _surnames = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscureText = true;
  bool _isChecked = false;

  List<Step> stepList() => [
        Step(
            state:
                _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
            isActive: _activeStepIndex >= 0,
            title: const Text('PASO 1'),
            content: Form(
              key: _formStepOneKey,
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
                  decoration: InputDecoration(
                      icon: const Icon(Icons.person_outline_sharp),
                      labelText: 'Nombres',
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
                  decoration: InputDecoration(
                      icon: const Icon(Icons.person_outline_sharp),
                      labelText: 'Apellidos',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _birthDate,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '*Campo requerido.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      icon: const Icon(Icons.date_range),
                      labelText: 'Fecha de nacimiento',
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
                        _birthDate.text =
                            DateFormat('dd/MM/yyyy').format(pickDate);
                      });
                    }
                  },
                ),
                const SizedBox(height: 40),
              ]),
            )),
        Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text('PASO 2'),
          content: Form(
            key: _formStepTwoKey,
            child: Column(children: [
              const Text('¿Cual es tu correo electrónico?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
              const SizedBox(height: 20),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Campo requerido.';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Por favor, introduce un correo electrónico válido.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    icon: const Icon(Icons.email_outlined),
                    hintText: 'Correo electrónico',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ),
        Step(
          state: _activeStepIndex <= 2 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 2,
          title: const Text('PASO 3'),
          content: Form(
            key: _formStepThreeKey,
            child: Column(children: [
              const Text('Crea tu contraseña',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
              const SizedBox(height: 20),
              const Text(
                'Debe contener al menos 6 caracteres.',
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _password,
                obscureText: _obscureText,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Campo requerido.';
                  }
                  if (value.length < 6) {
                    return '*Contraseña invalida.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    hintText: 'Contraseña',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 160,
                height: 60,
                child: GestureDetector(
                  //onTap: signIn,
                  child: ElevatedButton(
                      onPressed: () {
                        _showDialog(context);
                      },
                      child: const Text(
                        'Políticas de privacidad \nY\n Términos de servicio',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      )),
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        )
      ];
  int _activeStepIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Registrate'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
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
                      child: const Text('Cancelar'),
                    ),
                  ],
                );
              },
              steps: stepList(),
              type: StepperType.horizontal,
              currentStep: _activeStepIndex,
              onStepContinue: () {
                setState(() {
                  if (_activeStepIndex < (stepList().length)) {
                    switch (_activeStepIndex) {
                      case 0:
                        if (!_formStepOneKey.currentState!.validate()) {
                          return;
                        } else {
                          _activeStepIndex += 1;
                        }
                        break;
                      case 1:
                        if (!_formStepTwoKey.currentState!.validate()) {
                          return;
                        } else {
                          _activeStepIndex += 1;
                        }
                        break;
                      case 2:
                        if (!_formStepThreeKey.currentState!.validate() ||
                            _isChecked == false) {
                          if (_isChecked == false) {
                            setState(() {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Debes aceptar los terminos y condiciones.'),
                                  duration: Duration(seconds: 2),
                                ));
                              });
                            });
                          }
                          return;
                        } else {
                          registerUser();
                        }
                        break;
                      default:
                        return;
                    }
                  }
                });
              },
              onStepCancel: () {
                if (_activeStepIndex == 0) {
                  return;
                }
                _activeStepIndex -= 1;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Usuario setUser() {
    return Usuario(
        name: _names.text.trim(),
        surname: _surnames.text.trim(),
        email: _email.text.trim(),
        birthDate: _birthDate.text.trim());
  }

  void registerUser() async {
    try {
      var user = setUser();
      var userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      final String uid = userCredential.user!.uid;

      await db.collection('users').doc(uid).set({
        'name': user.name,
        'surname': user.surname,
        'email': user.email,
        'birthDate': user.birthDate,
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario registrado exitosamente.'),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La contraseña es demasiada corta.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ya existe una cuenta con ese correo.'),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Póliticas de privacidad',
            textAlign: TextAlign.center,
          ),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 350,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text(
                        ' Políticas de Privacidad de "ADDMENTAL"\n1.	IntroducciónEsta política de privacidad describe cómo la aplicación móvil " ADDMENTAL " recopila y utiliza la información personal de los usuarios de la aplicación. Al utilizar la aplicación, el usuario acepta las prácticas descritas en esta política de privacidad.\n2.	Información que recopilamosLa Aplicación puede recopilar información personal del usuario, incluyendo:\n•	Información de contacto, como nombre y dirección de correo electrónico.\n•	Información demográfica, como edad, género y ubicación geográfica.\n•	Información de salud, como los síntomas de depresión y ansiedad que el usuario experimenta.\n•	Además, la aplicación puede recopilar información no personal sobre el uso de la aplicación, incluyendo datos de uso, registros de errores y otros datos de diagnóstico. Esta información se utiliza para mejorar la calidad de la aplicación y el servicio que ofrecemos.\n3.	Uso de la informaciónLa aplicación utiliza la información personal del usuario para los siguientes fines:\n•	Proporcionar un diagnóstico de depresión y ansiedad.\n•	Proporcionar información personalizada y consejos sobre la gestión de la depresión y ansiedad.\n•	Mejorar la calidad de la Aplicación y el servicio que ofrecemos.\n•	Enviar información sobre actualizaciones de la aplicación o nuevos servicios que puedan ser de interés para el usuario.\n•	La aplicación no vende ni comparte la información personal del usuario con terceros sin el consentimiento explícito del usuario.\n4.	Seguridad de la información\nLa aplicación se compromete a proteger la información personal del usuario y utiliza medidas de seguridad razonables para proteger la información de accesos no autorizados o uso indebido. Sin embargo, ninguna medida de seguridad es completamente infalible y la aplicación no puede garantizar la seguridad completa de la información del usuario.\n5.	Cambios a esta política de privacidad\nLa aplicación puede actualizar esta política de privacidad de vez en cuando. En caso de cambios significativos en las prácticas de privacidad de la aplicación, se informará al usuario mediante una notificación dentro de la aplicación o mediante correo electrónico.\n6.	Contacto\nSi el usuario tiene alguna pregunta o inquietud s0obre esta política de privacidad o el uso de la aplicación, puede ponerse en contacto con nosotros en cualquier momento mediante el correo electrónico proporcionado en la aplicación.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: const Text(
                    'Aceptar nuestras Políticas de privacidad y términos de servicio',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 10),
                  ),
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
              ],
            );
          }),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                setState(() {
                  _isChecked = false;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                setState(() {
                  _isChecked = _isChecked;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

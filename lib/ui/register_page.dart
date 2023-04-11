import 'package:addmental/ui/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                  decoration: InputDecoration(
                      icon: const Icon(Icons.person_outline_sharp),
                      hintText: 'Apellidos',
                      hintStyle: const TextStyle(color: Colors.grey),
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
                        _birthDate.text =
                            DateFormat('dd/MM/yyyy').format(pickDate);
                      });
                    }
                  },
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
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Registrate'),
        centerTitle: true,
        foregroundColor: Colors.black,
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
                      child: const Text('Cancelar',
                          style: TextStyle(color: Colors.grey)),
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
                        if (!_formStepOneKey.currentState!.validate() ||
                            _isChecked == false) {
                          if (_isChecked == false) {
                            setState(() {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Debes aceptar los terminos y condiciones.'),
                                  duration: Duration(seconds: 2),
                                ));
                              });
                            });
                          }
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
                        if (!_formStepThreeKey.currentState!.validate()) {
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
      var userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
          content: Text('Usuario registrado.'),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La contraseña es demasiada corta.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ya existe una cuenta con ese correo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
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
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque libero ac sapien eleifend, eget tincidunt augue iaculis. Sed tincidunt turpis sed venenatis vestibulum. Sed ac magna ut lacus bibendum iaculis. Integer accumsan malesuada velit, sed laoreet enim bibendum id. Nunc ut nisi ipsum. Maecenas nec mi euismod, imperdiet arcu at, finibus augue. Aliquam erat volutpat. Sed tincidunt eget augue vitae sollicitudin. Pellentesque sed metus vel velit sollicitudin commodo. Nulla malesuada euismod elit in interdum. Pellentesque commodo tincidunt felis eget pharetra. Sed porttitor imperdiet augue euismod lobortis. Nam auctor orci vitae elit bibendum, eu malesuada sapien sagittis.' +
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque libero ac sapien eleifend, eget tincidunt augue iaculis. Sed tincidunt turpis sed venenatis vestibulum. Sed ac magna ut lacus bibendum iaculis. Integer accumsan malesuada velit, sed laoreet enim bibendum id. Nunc ut nisi ipsum. Maecenas nec mi euismod, imperdiet arcu at, finibus augue. Aliquam erat volutpat. Sed tincidunt eget augue vitae sollicitudin. Pellentesque sed metus vel velit sollicitudin commodo. Nulla malesuada euismod elit in interdum. Pellentesque commodo tincidunt felis eget pharetra. Sed porttitor imperdiet augue euismod lobortis. Nam auctor orci vitae elit bibendum, eu malesuada sapien sagittis.',
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

import 'package:addmental/model/question.dart';
import 'package:addmental/ui/views/result_view.dart';
import 'package:addmental/ui/views/test_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DepressionView extends StatefulWidget {
  const DepressionView({super.key});

  @override
  State<DepressionView> createState() => _DepressionViewState();
}

class _DepressionViewState extends State<DepressionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const QuesionWidget(),
      appBar: AppBar(title: const Text('Test de depresión')),
    );
  }
}

class QuesionWidget extends StatefulWidget {
  const QuesionWidget({super.key});

  @override
  State<StatefulWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuesionWidget> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late PageController _controller;
  int _questionNumber = 1;
  int _score = 0;
  List<int> scoreQuestion = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            height: 32,
          ),
          Text('Pregunta $_questionNumber/${depressionQuestions.length}'),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Expanded(
              child: PageView.builder(
            itemCount: depressionQuestions.length,
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final question = depressionQuestions[index];
              return buildQuestion(question);
            },
          )),
          buildElevatenButton(),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  ElevatedButton buildElevatenButton() {
    return ElevatedButton(
        onPressed: () async {
          if (_questionNumber < depressionQuestions.length) {
            _controller.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInExpo,
            );
            setState(() {
              _questionNumber++;
            });
          } else {
            if (FirebaseAuth.instance.currentUser != null) {
              final Map<String, dynamic> datos = {
                "date": DateFormat('yyyy/MM/dd').format(DateTime.now()),
                "score": scoreQuestion.reduce((valorAnterior, valorActual) =>
                    valorAnterior + valorActual),
              };
              print('USUARIO: ${FirebaseAuth.instance.currentUser?.uid}');
              final String userId = FirebaseAuth.instance.currentUser!.uid;
              final String fechaFormateada =
                  DateFormat('yyyyMMddhhmmss').format(DateTime.now());
              await db
                  .collection("depressiontest")
                  .doc(userId)
                  .collection(fechaFormateada)
                  .doc()
                  .set(datos);
            }
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ResultPage(
                          score: _score,
                          scoreQuestion: scoreQuestion,
                        )));
          }
        },
        child:
            Text(_questionNumber < depressionQuestions.length ? 'Siguiente' : 'Enviar'));
  }

  Column buildQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 32,
        ),
        Text(
          question.text,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(
          height: 32,
        ),
        Expanded(
            child: OptionWidget(
                question: question,
                onClikedOption: (option) {
                  setState(() {
                    question.selectedOption = option;
                    scoreQuestion[question.index] = option.value!;
                  });
                }))
      ],
    );
  }
}

// ignore: must_be_immutable
class ResultPage extends StatelessWidget {
  ResultPage({super.key, required this.score, required this.scoreQuestion});
  final int score;
  List<int> scoreQuestion = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¡Gracias por completar el test!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text('Tu puntaje es: ${scoreTotal()}'),
          const SizedBox(height: 30),
          SizedBox(
            width: 310,
            child: GestureDetector(
              //onTap: signIn,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const DepressionView(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child;
                        },
                      ),
                    );
                  },
                  child: const Text('Realizar otro test')),
            ),
          ),
          SizedBox(
            width: 310,
            child: GestureDetector(
              //onTap: signIn,
              child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   PageRouteBuilder(
                    //     pageBuilder: (context, animation, secondaryAnimation) =>
                    //         const ResultView(),
                    //     transitionsBuilder:
                    //         (context, animation, secondaryAnimation, child) {
                    //       return child;
                    //     },
                    //   ),
                    // );
                  },
                  child: const Text('Ver resultados')),
            ),
          ),
        ],
      )),
    );
  }

  scoreTotal() {
    return scoreQuestion
        .reduce((valorAnterior, valorActual) => valorAnterior + valorActual);
  }
}

class OptionWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<Option> onClikedOption;

  const OptionWidget(
      {Key? key, required this.question, required this.onClikedOption})
      : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: question.options
              //.map((option) => buildOption(context, option))
              .map((option) => RadioListTile<Option>(
                    title: Text(option.text),
                    value: option,
                    groupValue: question.selectedOption,
                    onChanged: (option) => onClikedOption(option!),
                  ))
              .toList(),
        ),
      );

  Widget buildOption(BuildContext context, Option option) {
    return GestureDetector(
      onTap: () => onClikedOption(option),
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option.text,
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}

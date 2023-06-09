import 'package:addmental/model/question.dart';
import 'package:addmental/ui/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnxietyView extends StatefulWidget {
  static String id = "anxiety_view";
  const AnxietyView({super.key});

  @override
  State<AnxietyView> createState() => _AnxietyViewState();
}

class _AnxietyViewState extends State<AnxietyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const QuesionWidget(),
      appBar: AppBar(title: const Text('Test de ansiedad')),
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
  static List<Question> _cleanQuestions = anxietyQuestions;

  @override
  void initState() {
    super.initState();
    _questionNumber = 1;
    scoreQuestion = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    _controller = PageController(initialPage: 0);
    _cleanQuestions = List.from(_cleanQuestions);
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
          Text('Pregunta $_questionNumber/${_cleanQuestions.length}'),
          const Divider(
            thickness: 1,
          ),
          Expanded(
              child: PageView.builder(
            itemCount: _cleanQuestions.length,
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final question = _cleanQuestions[index];
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
          if (_questionNumber < _cleanQuestions.length) {
            _controller.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInExpo,
            );
            setState(() {
              _questionNumber++;
            });
          } else {
            final formatter = DateFormat("yyyy-MM-ddTHH:mm:ss");
            if (FirebaseAuth.instance.currentUser != null) {
              final Map<String, dynamic> datos = {
                "date": formatter.format(DateTime.now()),
                "score": scoreQuestion.reduce((valorAnterior, valorActual) =>
                    valorAnterior + valorActual),
              };
              final String userId = FirebaseAuth.instance.currentUser!.uid;
              DocumentReference userRef =
                  db.collection('anxietytest').doc(userId);
              await userRef.collection('history').add(datos);
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
        child: Text(
            _questionNumber < _cleanQuestions.length ? 'Siguiente' : 'Enviar'));
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
          Text(resultTest()),
          const SizedBox(height: 30),
          SizedBox(
            width: 310,
            child: GestureDetector(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  child: const Text('Salir')),
            ),
          ),
          // SizedBox(
          //   width: 310,
          //   child: GestureDetector(
          //     child: ElevatedButton(
          //         onPressed: () {
          //           Navigator.of(context).pushNamedAndRemoveUntil(
          //             ResultView.id,
          //             ModalRoute.withName(HomeView.id),
          //           );
          //         },
          //         child: const Text('Ver resultados')),
          //   ),
          // ),
        ],
      )),
    );
  }

  String resultTest() {
    String response = '';
    var score = scoreQuestion
        .reduce((valorAnterior, valorActual) => valorAnterior + valorActual);
    if (score >= 0 && score <= 4) {
      response = 'Ausencia de ansiedad o síntomas minimos';
    } else if (score >= 5 && score <= 9) {
      response = 'Ansiedad leve';
    } else if (score >= 10 && score <= 14) {
      response = 'Ansiedad moderada';
    } else if (score >= 15 && score <= 21) {
      response = 'Ansiedad severa';
    }
    return response;
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
          borderRadius: BorderRadius.circular(16),
        ),
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

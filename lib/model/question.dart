
class Question {
  final String text;
  final List<Option> options;
  bool isLoked;
  Option? selectedOption;
  int index;

  Question(
      {required this.text,
      required this.options,
      required this.index,
      this.isLoked = false,
      this.selectedOption});
}

class Option {
  final String text;
  final bool? isCorrect;
  final int? value;
  const Option({required this.text, this.isCorrect, this.value});
}

final depressionQuestions = [
  Question(text: 'Poco interés o placer en hacer cosas', options: [
    const Option(text: 'Ningún día', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'Más de la mitad de los días', value: 2),
    const Option(text: 'Casi todos los días', value: 3),
  ], index: 0),
  Question(text: 'Se ha sentido decaído(a), deprimido(a) o sin esperanzas', options: [
    const Option(text: 'Ningún día', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'Más de la mitad de los días', value: 2),
    const Option(text: 'Casi todos los días', value: 3),
  ], index: 1),
  Question(text: 'Ha tenido dificultad para quedarse o permanecer dormido(a), o ha dormido demasiado', options: [
    const Option(text: 'Ningún día', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'Más de la mitad de los días', value: 2),
    const Option(text: 'Casi todos los días', value: 3),
  ], index: 2),
  Question(text: 'Se ha sentido cansado(a) o con poca energía', options: [
    const Option(text: 'Ningún día', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'Más de la mitad de los días', value: 2),
    const Option(text: 'Casi todos los días', value: 3),
  ], index: 3),
  Question(text: 'Sin apetito o ha comido en exceso', options: [
    const Option(text: 'Ningún día', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'Más de la mitad de los días', value: 2),
    const Option(text: 'Casi todos los días', value: 3),
  ], index: 4),
  Question(text: 'Se ha sentido mal con usted mismo(a) o que es un fracaso o que ha quedado mal con usted mismo(a) o con su familia', options: [
    const Option(text: 'Ningún día', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'Más de la mitad de los días', value: 2),
    const Option(text: 'Casi todos los días', value: 3),
  ], index: 5),
  Question(text: 'Ha tenido dificultad para concentrarse en ciertas actividades, tales como leer el periódico o ver la televisión', options: [
    const Option(text: 'Ningún día', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'Más de la mitad de los días', value: 2),
    const Option(text: 'Casi todos los días', value: 3),
  ], index: 6),
  Question(text: ' ¿Se ha movido o hablado tan lento que otras personas podrían haberlo notado? o lo contrario - muy inquieto(a) o agitado(a) que ha estado moviéndose mucho más de lo normal ', options: [
    const Option(text: 'Ningún día', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'Más de la mitad de los días', value: 2),
    const Option(text: 'Casi todos los días', value: 3),
  ], index: 7),
  Question(text: 'Pensamientos de que estaría mejor muerto(a) o de lastimarse de alguna manera ', options: [
    const Option(text: 'Ningún día', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'Más de la mitad de los días', value: 2),
    const Option(text: 'Casi todos los días', value: 3),
  ], index: 8),
];

final anxietyQuestions = [
  Question(text: 'Sentirse nervioso, ansioso, notar que se le ponen los nervios de punta.', options: [
    const Option(text: 'Nunca', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'La mitad de los días', value: 2),
    const Option(text: 'Casi cada día', value: 3),
  ], index: 0),
  Question(text: 'No ser capaz de parar o controlar sus preocupaciones.', options: [
    const Option(text: 'Nunca', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'La mitad de los días', value: 2),
    const Option(text: 'Casi cada día', value: 3),
  ], index: 1),
  Question(text: 'Preocuparse demasiado sobre diferentes cosas.', options: [
    const Option(text: 'Nunca', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'La mitad de los días', value: 2),
    const Option(text: 'Casi cada día', value: 3),
  ], index: 2),
  Question(text: 'Dificultad para relajarse.', options: [
    const Option(text: 'Nunca', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'La mitad de los días', value: 2),
    const Option(text: 'Casi cada día', value: 3),
  ], index: 3),
  Question(text: 'Estar tan desasosegado que le resulta difícil parar quieto.', options: [
    const Option(text: 'Nunca', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'La mitad de los días', value: 2),
    const Option(text: 'Casi cada día', value: 3),
  ], index: 4),
  Question(text: 'Sentirse fácilmente disgustado o irritable.', options: [
    const Option(text: 'Nunca', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'La mitad de los días', value: 2),
    const Option(text: 'Casi cada día', value: 3),
  ], index: 5),
  Question(text: 'Sentirse asustado como si algo horrible pudiese pasar.', options: [
    const Option(text: 'Nunca', value: 0),
    const Option(text: 'Varios días', value: 1),
    const Option(text: 'La mitad de los días', value: 2),
    const Option(text: 'Casi cada día', value: 3),
  ], index: 6),
];

import 'game_answer.dart';

class GameQuestions {
  final String question;
  final List<GameAnswer> answers;
  late bool isLocked;

  GameQuestions({
    required this.question,
    required this.answers,
    this.isLocked = false,
  });
}
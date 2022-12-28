import 'game_answer.dart';

class GameQuestions {
  final String question;
  final List<GameAnswer> answers;

  const GameQuestions({
    required this.question,
    required this.answers,
  });
}
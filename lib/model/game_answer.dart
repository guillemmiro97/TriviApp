
import 'package:flutter/material.dart';

class GameAnswer {
  final String answer;
  final bool isCorrect;
  late Color colorOfAnswer;

  GameAnswer({
    required this.answer,
    required this.isCorrect,
    this.colorOfAnswer = Colors.white60,
  });
}
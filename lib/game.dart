import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:triviapp/model/question.dart';

import 'model/game_answer.dart';
import 'model/game_questions.dart';

Future<List<GameQuestions>> fetchQuestions() async {
  final response = await http.get(Uri.parse(
      'https://the-trivia-api.com/api/questions?limit=20&difficulty=medium'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    List<Question> questions = [];
    List<GameQuestions> gameQuestions = [];
    List<GameAnswer> gameAnswers = [];
    for (int i = 0; i < jsonResponse.length; i++) {
      Question question = Question.fromJson(jsonResponse[i]);
      gameAnswers
          .add(GameAnswer(answer: question.correctAnswer, isCorrect: true));
      gameAnswers.add(
          GameAnswer(answer: question.incorrectAnswers[0], isCorrect: false));
      gameAnswers.add(
          GameAnswer(answer: question.incorrectAnswers[1], isCorrect: false));
      gameAnswers.add(
          GameAnswer(answer: question.incorrectAnswers[2], isCorrect: false));

      gameAnswers.shuffle();

      gameQuestions.add(
          GameQuestions(question: question.question, answers: gameAnswers));

      gameAnswers = [];
    }

    return gameQuestions;
  } else {
    throw Exception('Failed to load questions data');
  }
}

class GameWidgetState extends StatefulWidget {
  const GameWidgetState({Key? key}) : super(key: key);

  @override
  _GameWidget createState() => _GameWidget();
}

class _GameWidget extends State<GameWidgetState> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  late Future<List<GameQuestions>> _questions;
  @override
  void initState() {
    super.initState();

    _questions = fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game On!'),
      ),
      body: FutureBuilder<List<GameQuestions>>(
        future: _questions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<GameQuestions>? data = snapshot.data;
            return Container(
              //container with the question and the answers
              padding: const EdgeInsets.all(10),
              width: 400,
              height: 390,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: .5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Question: ${_currentQuestionIndex + 1}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(//TODO: Change style of score
                    "Score: $_score",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Container(
                    //container with the question
                    padding: const EdgeInsets.all(10),
                    width: 400,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: AutoSizeText(
                      data![_currentQuestionIndex].question,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Column(
                    children: data[_currentQuestionIndex]
                        .answers
                        .map((answer) => SizedBox(
                            width: 400,
                            height: 50,
                            child: GestureDetector(
                              onTap: () {
                                if (!data[_currentQuestionIndex].isLocked) {
                                  if (answer.isCorrect) {
                                    print("Correct");
                                    setState(() {
                                      _score++;
                                      answer.colorOfAnswer = Colors.lightGreen;
                                    });
                                  } else {
                                    print("Wrong");
                                    setState(() {
                                      answer.colorOfAnswer = Colors.redAccent;
                                    });
                                  }
                                  data[_currentQuestionIndex].isLocked = true;
                                  setState(() {
                                    if (_currentQuestionIndex < 19) {
                                      Future.delayed(
                                          const Duration(seconds: 2), () {
                                        setState(() {
                                          _currentQuestionIndex++;
                                        });
                                      });
                                    }
                                  });
                                  if (_currentQuestionIndex == 19) {
                                    //TODO: Handle End of Game maybe show the score on alert, and then go back to the main menu
                                    print("Game Over");
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(top: 10),
                                width: 400,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: answer.colorOfAnswer,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: AutoSizeText(
                                    answer.answer,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                            )))
                        .toList(),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

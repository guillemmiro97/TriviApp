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
  late DateTime _startTime, _endTime;

  late Future<List<GameQuestions>> _questions;

  @override
  void initState() {
    super.initState();

    _questions = fetchQuestions();
    _startTime = DateTime.now();
    print(_startTime);
  }

  int calTotalTime(DateTime startTime, DateTime endTime) {
    int totalTime =
        (endTime.minute * 60 + endTime.hour * 3600 + endTime.second) -
            (startTime.minute * 60 + startTime.hour * 3600 + startTime.second);
    return totalTime;
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
            return Align(
              alignment: Alignment.topCenter,
              child: Container(
                //container with the question and the answers
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                width: 400,
                height: double.maxFinite,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Question ${_currentQuestionIndex + 1} of 20",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(
                            "Score: $_score",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                        //container with the question
                        width: 400,
                        height: 80,
                        decoration: BoxDecoration(
                          //color: Colors.white,
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
                            .map(
                              (answer) => buildBoxOfAnswer(data, answer, context),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
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

  SizedBox buildBoxOfAnswer(List<GameQuestions> data, GameAnswer answer, BuildContext context) {
    return SizedBox(
      width: 400,
      height: 110,
      child: GestureDetector(
        onTap: () {
          if (!data[_currentQuestionIndex].isLocked) {
            handleAnswer(answer, data);
            data[_currentQuestionIndex].isLocked = true;
            setState(() {
              if (_currentQuestionIndex < 19) {
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    _currentQuestionIndex++;
                  });
                });
              }
            });
            if (_currentQuestionIndex == 19) {
              print("Game Over");
              _endTime = DateTime.now();

              int time = calTotalTime(_startTime, _endTime);
              int finalScore = _score - time;

              //TODO: update the score in the database

              processEndGame(context, time, finalScore);
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 10),
          width: 400,
          height: 110,
          decoration: BoxDecoration(
            color: answer.colorOfAnswer,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                answer.answer,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleAnswer(GameAnswer answer, List<GameQuestions> data) {
    if (answer.isCorrect) {
      setState(() {
        _score += 100;
        answer.colorOfAnswer = Colors.lightGreen;
      });
    } else {
      setState(() {
        answer.colorOfAnswer = Colors.redAccent;
        //paint the correct answer green
        data[_currentQuestionIndex]
            .answers
            .firstWhere((element) => element.isCorrect == true)
            .colorOfAnswer = Colors.lightGreen;
      });
    }
  }

  void processEndGame(BuildContext context, int time, int finalScore) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Well Done!"),
            content: Text("Your score is $_score.\n"
                "You spent $time seconds in the game.\n\n"
                "Your final score is $finalScore 🎉\n\n"
                "Correct answers: ${_score ~/ 100}\n"
                "Wrong answers: ${20 - (_score ~/ 100)}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        });
  }
}

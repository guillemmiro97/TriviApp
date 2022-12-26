import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:triviapp/game_answer.dart';
import 'package:triviapp/question.dart';

import 'game_questions.dart';

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

class GameWidget extends StatelessWidget {
  GameWidget({super.key});

  late Future<List<GameQuestions>> gameQuestions;

  void initState() {
    gameQuestions = fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game On!'),
      ),
      body: FutureBuilder<List<GameQuestions>>(
        future: fetchQuestions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<GameQuestions>? data = snapshot.data;
            return ListView.separated(
              shrinkWrap: true,
              itemCount: data!.length,
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              itemBuilder: (BuildContext context, int index) {
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
                        "Question: ${index + 1}",
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
                        child: Text(
                          data[index].question,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      InkWell(
                        onTap: () {
                          if (data[index].answers[0].isCorrect) {
                            print("Correct");
                          } else {
                            print("Wrong");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(data[index].answers[0].answer),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        onTap: () {
                          if (data[index].answers[1].isCorrect) {
                            print("Correct");
                          } else {
                            print("Wrong");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(data[index].answers[1].answer),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        onTap: () {
                          if (data[index].answers[2].isCorrect) {
                            print("Correct");
                          } else {
                            print("Wrong");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(data[index].answers[2].answer),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        onTap: () {
                          if (data[index].answers[3].isCorrect) {
                            print("Correct");
                          } else {
                            print("Wrong");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(data[index].answers[3].answer),
                        ),
                      ),
                    ],
                  ),
                );
              },
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

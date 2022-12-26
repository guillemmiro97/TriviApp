import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:triviapp/question.dart';

Future<List<Question>> fetchQuestions() async {
  final response = await http.get(Uri.parse(
      'https://the-trivia-api.com/api/questions?limit=20&difficulty=medium'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    List<Question> questions = [];
    for (int i = 0; i < jsonResponse.length; i++) {
      Question question = Question.fromJson(jsonResponse[i]);
      questions.add(question);
    }

    return questions;
  } else {
    throw Exception('Failed to load questions data');
  }
}

class GameWidget extends StatelessWidget {
  GameWidget({super.key});

  late Future<List<Question>> questions;

  void initState() {
    questions = fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Question>>(
        future: fetchQuestions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Question>? data = snapshot.data;
            return ListView.separated(
              shrinkWrap: true,
              itemCount: data!.length,
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(),
              padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  //container with the question and the answers
                  padding: const EdgeInsets.all(10),
                  width: 400,
                  height: 380,
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
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(data[index].question),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      InkWell(
                        onTap: () {
                          print("taped correct");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(data[index].correctAnswer),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        onTap: () {
                          print("taped incorrect 0");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(data[index].incorrectAnswers[0]),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        onTap: () {
                          print("taped incorrect 1");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(data[index].incorrectAnswers[1]),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        onTap: () {
                          print("taped incorrect 2");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 400,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(data[index].incorrectAnswers[2]),
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

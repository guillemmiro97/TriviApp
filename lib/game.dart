import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:triviapp/question.dart';

Future<List<Question>> fetchQuestions() async {
  final response = await http.
  get(Uri.parse('https://the-trivia-api.com/api/questions?limit=20&difficulty=medium'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    List<Question> questions = [];
    for (int i=0 ; i < jsonResponse.length ; i++) {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<Question>>(
                future: fetchQuestions(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Question>? data = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(data[index].question);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo.png'),
              const Padding(padding: EdgeInsets.only(top: 30.0)),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Username',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              TextFormField(
                controller: repeatPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  hintText: 'Repeat Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.white),
                onPressed: () {
                  //implement the signup logic
                },
                child: const Text('Sign Up',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail_outline_rounded),
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
                  icon: Icon(Icons.lock_outline),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter email and password'),
                      ),
                    );
                    return;
                  }

                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim())
                      .then((value) => Navigator.pushNamed(context, "/startPage"));

                },
                child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              Text("Not registered yet?",
                style: Theme.of(context).textTheme.bodyText2
              ),
              const Padding(padding: EdgeInsets.only(top: 7.0)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
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

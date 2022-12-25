import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:triviapp/widgets/landing_widget.dart';
import 'package:triviapp/widgets/login_widget.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            /*return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  }, child: const Text('Sign Out')),
                ],
              ),
            );*/
            return const LandingWidget();
          } else {
            return const LoginWidget();
          }
        },
      ),
    );
  }
}

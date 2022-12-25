import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingWidget extends StatelessWidget {
  const LandingWidget({super.key});

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
            ElevatedButton.icon(
              icon: const Icon(Icons.play_circle, color: Colors.white),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {},
              label: Text("Let's Play",
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              label: Text("Sign Out",
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        ),
      ),
    ));
  }
}

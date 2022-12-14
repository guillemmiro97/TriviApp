import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:triviapp/game.dart';
import 'package:triviapp/widgets/landing_widget.dart';
import 'package:triviapp/widgets/login_widget.dart';
import 'package:triviapp/widgets/signup_widget.dart';
import 'auth_gate.dart';
import 'firebase_options.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: const Color(0xFFFFE082),
        primarySwatch: Colors.orange,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            fontSize: 20.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          headline4: TextStyle(
            fontSize: 14.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),
          headline6: TextStyle(
            fontSize: 24.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Hind',
            color: Colors.white
          ),
          bodyText2: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Hind',
              color: Colors.black
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginWidget(),
        '/signup': (context) => const SignUpWidget(),
        '/startPage': (context) => LandingWidget(),
        '/play_game': (context) => const GameWidgetState(),
      },
      home: const AuthGate(),
    );
  }
}


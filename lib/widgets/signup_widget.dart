import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final db = FirebaseFirestore.instance;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  Future<String> locationService() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionLocation;
    LocationData _locData;

    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return "error";
      }
    }

    _permissionLocation = await location.hasPermission();
    if(_permissionLocation == PermissionStatus.denied) {
      _permissionLocation = await location.requestPermission();
      if(_permissionLocation != PermissionStatus.granted) {
        return "error";
      }
    }

    _locData = await location.getLocation();

    List<Placemark> placemark = await placemarkFromCoordinates(_locData.latitude!, _locData.longitude!);

    var countryCode = placemark[0].isoCountryCode!;

    return countryCode;
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
                onPressed: () async {
                  if (passwordController.text.trim() ==
                      repeatPasswordController.text.trim()
                      && emailController.text.trim().isNotEmpty
                  && usernameController.text.trim().isNotEmpty) {
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());

                    //TODO: check if user mail has already been used.

                    var countryCode = await locationService();
                    print(countryCode);

                    //TODO: insertar en la bbdd el usuario, countrycode y un score inicializado a cero
                    final user = <String, dynamic>{
                      'username': usernameController.text.trim(),
                      'countryCode': countryCode,
                      'score': 0,
                    };

                    await db
                        .collection('userData')
                        .doc(usernameController.text.trim())
                        .set(user)
                        .then((value) => print("User Added"))
                        .catchError((error) => print("Error: $error"));

                    await FirebaseAuth.instance.currentUser!
                        .updateDisplayName(usernameController.text.trim())
                        .then((value) => Navigator.pushNamed(context, '/startPage'));

                  } else if (emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter an email')));
                  } else if (usernameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter an username')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')));
                  }
                }, child: const Text('Sign Up',
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

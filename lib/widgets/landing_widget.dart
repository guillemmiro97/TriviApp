import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/user_data.dart';

class LandingWidget extends StatefulWidget {
  LandingWidget({super.key});

  @override
  State<LandingWidget> createState() => _LandingWidgetState();
}

class _LandingWidgetState extends State<LandingWidget> {
  final db = FirebaseFirestore.instance;

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('userData');

  late Future<List<UserData>> _userData;

  @override
  void initState() {
    super.initState();
    _userData = getData();
    setState(() {});
  }

  Future<List<UserData>> getData() async {
    List<UserData> allUsers = [];
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    for (var doc in querySnapshot.docs) {
      UserData userData = UserData.fromJson(doc.data() as Map<String, dynamic>);
      allUsers.add(userData);
    }

    //order all users by score descending
    allUsers.sort((a, b) => b.score.compareTo(a.score));

    return allUsers;
  }

  Future<void> _refreshData() async {
    setState(() {
      _userData = getData();
    });
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
            TextButton.icon(
              icon: const Icon(Icons.logout, color: Colors.black54),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                alignment: Alignment.centerRight,
              ),
              onPressed: () async {
                await FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.pushNamed(context, '/login'));
              },
              label: Text("Sign Out",
                  style: Theme.of(context).textTheme.bodyText2),
            ),
            Image.asset('assets/images/logo.png'),
            const Padding(padding: EdgeInsets.only(top: 30.0)),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_circle, color: Colors.white),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/play_game');
              },
              label: Text("Let's Play",
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Ranking ",
                          style: Theme.of(context).textTheme.headline3),
                      Icon(Icons.leaderboard_rounded),
                    ],
                  ),
                  ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: _userData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<UserData>? data = snapshot.data;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data![index]
                                      .countryCode
                                      .toUpperCase()
                                      .replaceAllMapped(
                                          RegExp(r'[A-Z]'),
                                          (match) => String.fromCharCode(
                                              match.group(0)!.codeUnitAt(0) +
                                                  127397)),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  data![index].username,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Text(
                                  "${data[index].score}",
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ],
                            );
                          } else {
                            return const Text("Loading...");
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            //add simple refresh button with only text and refresh icon
            TextButton.icon(
              icon: const Icon(Icons.refresh, color: Colors.black54),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                _refreshData();
              },
              label: Text(
                  "Refresh",
                  style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

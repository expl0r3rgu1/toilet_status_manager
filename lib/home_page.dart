import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toilet_status_manager/firebase/firestore_services.dart';
import 'package:toilet_status_manager/model/toilet.dart';
import 'package:toilet_status_manager/pages/create_toilet_page.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage(this.user, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreServices _firestoreServices = FirestoreServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Toilet?>(
            future: _firestoreServices.getToilet(widget.user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return Center(
                  child: Column(
                    children: [],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateToiletPage(widget.user)));
                          },
                          child: Text(
                            "Create Toilet",
                            style: Theme.of(context).textTheme.headline3,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Join Toilet",
                            style: Theme.of(context).textTheme.headline3,
                          )),
                    ],
                  ),
                );
              }
            }));
  }
}

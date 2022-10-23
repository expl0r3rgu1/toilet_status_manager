import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toilet_status_manager/firebase/firestore_services.dart';
import 'package:toilet_status_manager/home_page.dart';

class CreateToiletPage extends StatefulWidget {
  final User user;
  const CreateToiletPage(this.user, {super.key});

  @override
  State<CreateToiletPage> createState() => _CreateToiletPageState();
}

class _CreateToiletPageState extends State<CreateToiletPage> {
  final _toiletNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Toilet Name",
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _toiletNameController,
                      decoration: InputDecoration(
                        hintText: "Toilet Name",
                        hintStyle: Theme.of(context).textTheme.bodyText1,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        FirestoreServices firestoreServices =
                            FirestoreServices();
                        await firestoreServices
                            .createToilet(widget.user.uid,
                                _toiletNameController.text.trim())
                            .then((value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(widget.user))));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Create",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyText1,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

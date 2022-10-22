import 'package:auto_size_text/auto_size_text.dart';
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
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: FutureBuilder<Toilet?>(
          future: _firestoreServices.getToilet(widget.user.uid),
          builder: (context, toiletSnapshot) {
            if (toiletSnapshot.hasData && toiletSnapshot.data != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () async {
                          await _firestoreServices
                              .leaveToilet(
                                  widget.user.uid, toiletSnapshot.data!.id)
                              .then((value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(widget.user),
                                  )));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.exit_to_app_rounded,
                                size: MediaQuery.of(context).size.width * 0.05,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Text("Leave Toilet",
                                  style: Theme.of(context).textTheme.headline6),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AutoSizeText(
                      toiletSnapshot.data!.nickname,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    StreamBuilder<String>(
                      stream: _firestoreServices
                          .getLastUserInside(toiletSnapshot.data!.id),
                      builder: (context, lastUserInsideSnapshot) {
                        if (lastUserInsideSnapshot.hasData &&
                            lastUserInsideSnapshot.data != null) {
                          if (lastUserInsideSnapshot.data!.isNotEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Status:",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        "BUSY",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                  ],
                                ),
                                lastUserInsideSnapshot.data! == widget.user.uid
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await _firestoreServices
                                                  .releaseToilet(
                                                      toiletSnapshot.data!.id);
                                            },
                                            style: ButtonStyle(
                                              minimumSize:
                                                  MaterialStateProperty.all(
                                                      Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.2)),
                                            ),
                                            child: Text(
                                              "Done",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container()
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Status:",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        "FREE",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await _firestoreServices.bookToilet(
                                        toiletSnapshot.data!.id,
                                        widget.user.uid);
                                  },
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(
                                        MediaQuery.of(context).size.width * 0.8,
                                        MediaQuery.of(context).size.height *
                                            0.2)),
                                  ),
                                  child: Text(
                                    "Book",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ],
                            );
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateToiletPage(widget.user)));
                        },
                        child: Text(
                          "Create Toilet",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Join Toilet",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        )),
                  ],
                ),
              );
            }
          }),
    ));
  }
}

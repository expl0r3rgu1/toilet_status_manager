import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toilet_status_manager/firebase/firebase_authentication_services.dart';
import 'package:toilet_status_manager/firebase/firestore_services.dart';
import 'package:toilet_status_manager/login_page.dart';
import 'package:toilet_status_manager/model/toilet.dart';
import 'package:toilet_status_manager/pages/create_toilet_page.dart';
import 'package:toilet_status_manager/pages/join_toilet_page.dart';

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
            if (toiletSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (toiletSnapshot.connectionState == ConnectionState.done &&
                toiletSnapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await _firestoreServices
                                .leaveToilet(
                                    widget.user.uid, toiletSnapshot.data!.id)
                                .then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(widget.user),
                                    )));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).focusColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.exit_to_app_rounded,
                                  size:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Text("Leave Toilet",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                              iconSize: MediaQuery.of(context).size.width * 0.1,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    actionsPadding: const EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Text(
                                      "Tap Join Toilet and scan this QR code",
                                      textAlign: TextAlign.center,
                                    ),
                                    titleTextStyle:
                                        Theme.of(context).textTheme.headline5,
                                    contentPadding: const EdgeInsets.only(
                                        top: 15, left: 15, right: 15),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: QrImage(
                                        data: toiletSnapshot.data!.id,
                                        version: QrVersions.auto,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Close",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary)),
                                      ),
                                    ],
                                    actionsAlignment: MainAxisAlignment.center,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.qr_code_rounded,
                              )),
                        )
                      ],
                    ),
                    AutoSizeText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Would you like to..."),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel")),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await _firestoreServices
                                            .deleteUser(widget.user.uid)
                                            .then((value) async {
                                          await FirebaseAuthenticationServices
                                                  .deleteUser()
                                              .then((value) {
                                            Fluttertoast.showToast(
                                                msg: "Account Deleted",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage(
                                                    key: widget.key,
                                                  ),
                                                ));
                                          });
                                        });
                                      } on Exception {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Login Again to Delete Account",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        await FirebaseAuthenticationServices
                                            .auth
                                            .signOut()
                                            .then((value) =>
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage(
                                                        key: widget.key,
                                                      ),
                                                    )));
                                      }
                                    },
                                    child: Text(
                                      "Delete account",
                                      style: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(color: Colors.red),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await FirebaseAuthenticationServices.auth
                                          .signOut()
                                          .then((value) =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage(
                                                      key: widget.key,
                                                    ),
                                                  )));
                                    },
                                    child: Text(
                                      "Logout",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.logout_rounded,
                          )),
                    ),
                    Column(
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
                                  .headline3!
                                  .copyWith(color: Colors.white),
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          JoinToiletPage(widget.user)));
                            },
                            child: Text(
                              "Join Toilet",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(color: Colors.white),
                            )),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    ));
  }
}

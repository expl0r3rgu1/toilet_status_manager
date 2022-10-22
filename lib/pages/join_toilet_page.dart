import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:toilet_status_manager/firebase/firestore_services.dart';
import 'package:toilet_status_manager/home_page.dart';

class JoinToiletPage extends StatefulWidget {
  final User user;
  const JoinToiletPage(this.user, {super.key});

  @override
  State<JoinToiletPage> createState() => _JoinToiletPageState();
}

class _JoinToiletPageState extends State<JoinToiletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
              allowDuplicates: false,
              onDetect: (barcode, args) async {
                if (barcode.rawValue == null) {
                  debugPrint('Failed to scan Barcode');
                } else {
                  final String code = barcode.rawValue!;
                  debugPrint('Barcode found! $code');
                  FirestoreServices firestoreServices = FirestoreServices();
                  await firestoreServices
                      .joinToilet(widget.user.uid, code)
                      .then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    widget.user,
                                  ))));
                }
              }),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 7,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.secondary,
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.all(18)),
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(
          "Cancel",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toilet_status_manager/home_page.dart';

class FirebaseAuthenticationServices {
  static const int smsCodeTimeout = 60;

  static Future registerUser(String mobile, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: const Duration(seconds: smsCodeTimeout),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth
              .signInWithCredential(credential)
              .then((UserCredential userCredential) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(userCredential.user!)));
          }).catchError((e) {
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          TextEditingController smsCodeController = TextEditingController();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: const Text("Enter SMS Code"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: smsCodeController,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Done"),
                        onPressed: () {
                          String smsCode = smsCodeController.text.trim();

                          PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: smsCode);

                          auth
                              .signInWithCredential(phoneAuthCredential)
                              .then((UserCredential userCredential) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(userCredential.user!)));
                          }).catchError((e) {
                            print(e);
                          });
                        },
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timout");
        });
  }
}

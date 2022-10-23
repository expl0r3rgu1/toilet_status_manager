import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toilet_status_manager/firebase/firestore_services.dart';
import 'package:toilet_status_manager/home_page.dart';

class FirebaseAuthenticationServices {
  static const int smsCodeTimeout = 60;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<bool> onVerificationCompleted(
      PhoneAuthCredential credential, BuildContext context) async {
    try {
      await auth
          .signInWithCredential(credential)
          .then((UserCredential userCredential) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(userCredential.user!)));
      });
    } catch (e) {
      return false;
    }

    return true;
  }

  static Future<bool> checkSmsCodeAndSignIn(String verificationId,
      String smsCode, int? forceResendingToken, BuildContext context) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      await FirebaseAuthenticationServices.auth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential userCredential) async {
        FirestoreServices firestoreServices = FirestoreServices();
        await firestoreServices
            .checkIfUserExists(userCredential.user!.uid)
            .then((value) async {
          if (!value) {
            firestoreServices.createUser(userCredential.user!.uid);
          }

          await FirebaseAnalytics.instance.logLogin().then((value) => {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(userCredential.user!)))
              });
        });
      });
    } catch (e) {
      return false;
    }

    return true;
  }

  static Future<void> deleteUser() async {
    await auth.currentUser!.delete();
  }
}

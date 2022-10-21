import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
}

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toilet_status_manager/firebase/firebase_authentication_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();
  bool codeSent = false;
  String? verificationId;
  int? forceResendingToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            codeSent
                ? Column(
                    children: [
                      Text(
                        "Enter the code you received",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _smsCodeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "SMS Code",
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText1,
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
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                Size(
                                  MediaQuery.of(context).size.width * 0.28,
                                  MediaQuery.of(context).size.height * 0.05,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await FirebaseAuthenticationServices
                                      .checkSmsCodeAndSignIn(
                                          verificationId!,
                                          _smsCodeController.text.trim(),
                                          forceResendingToken,
                                          context)
                                  .then((value) {
                                if (value) {
                                  Fluttertoast.showToast(
                                      msg: "Login successful",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      fontSize: 16.0);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Login failed",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      fontSize: 16.0);
                                }
                              });
                            },
                            child: Text(
                              "Done",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        "Enter your phone number",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              Size(
                                MediaQuery.of(context).size.width * 0.25,
                                MediaQuery.of(context).size.height * 0.05,
                              ),
                            ),
                          ),
                          onPressed: () {
                            showCountryPicker(
                                context: context,
                                onSelect: (country) {
                                  _phoneNumberController.text =
                                      "+${country.phoneCode}";
                                });
                          },
                          child: Text(
                            "Country",
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText1,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          IconButton(
                            iconSize: MediaQuery.of(context).size.width * 0.1,
                            icon: const Icon(Icons.send_rounded),
                            onPressed: () async {
                              await registerUser(
                                  _phoneNumberController.text
                                      .replaceAll(" ", ""),
                                  context);
                            },
                          ),
                        ],
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Future registerUser(String mobile, BuildContext context) async {
    FirebaseAuthenticationServices.auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: const Duration(
            seconds: FirebaseAuthenticationServices.smsCodeTimeout),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuthenticationServices.onVerificationCompleted(
                  credential, context)
              .then((value) {
            if (value) {
              Fluttertoast.showToast(
                  msg: "Login successful",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: 16.0);
            } else {
              Fluttertoast.showToast(
                  msg: "Login failed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: 16.0);
            }
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          Fluttertoast.showToast(
              msg: authException.message!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          setState(() {
            codeSent = true;
          });
          this.verificationId = verificationId;
          this.forceResendingToken = forceResendingToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            setState(() {
              codeSent = false;
            });
          }
          Fluttertoast.showToast(
              msg: "Timeout",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        });
  }
}

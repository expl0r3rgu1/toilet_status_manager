import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:toilet_status_manager/firebase/firebase_authentication_services.dart';

class LoginPage extends StatelessWidget {
  final _phoneNumberController = TextEditingController();

  LoginPage({super.key});
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
                        _phoneNumberController.text = "+${country.phoneCode}";
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
                    decoration: InputDecoration(
                      hintText: "Phone Number",
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
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        MediaQuery.of(context).size.width * 0.28,
                        MediaQuery.of(context).size.height * 0.05,
                      ),
                    ),
                  ),
                  onPressed: () {
                    FirebaseAuthenticationServices.registerUser(
                        _phoneNumberController.text, context);
                  },
                  child: Text(
                    "Send code",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

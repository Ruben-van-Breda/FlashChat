import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registeration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                //Do something with the user input.
                setState(() {
                  email = value;
                });
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email', labelText: 'Email'),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                //Do something with the user input.
                setState(() {
                  password = value;
                });
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password', labelText: 'Password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              label: 'Register',
              color: Colors.orangeAccent,
              heroTag: 'registerBtn',
              onPressed: () async {
                print(email);
                print(password);
                // Create user
                try {
                  final userCredential =
                      await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  if (userCredential != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatScreen()));
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

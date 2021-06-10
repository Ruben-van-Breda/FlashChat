import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller; // controller for animations
  Animation animationForLogo, animationForColorTween;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this,
        upperBound: 1,
        lowerBound: 0);

    animationForLogo =
        CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animationForColorTween =
        ColorTween(begin: Colors.red, end: ACTIVE_CARD_COLOR)
            .animate(controller);

    controller.forward(); // start animation

    //   animation.addStatusListener((status) {
    //     print(status);
    //     // if (status == AnimationStatus.completed) {

    //     // }
    //   });

    controller.addListener(() {
      setState(() {});
      // print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose(); // free animation resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animationForColorTween.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animationForLogo.value * 80,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            new RoundedButton(
              label: 'Log in',
              heroTag: 'loginBtn',
              onPressed: () {
                //Go to login screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            new RoundedButton(
              heroTag: 'registerBtn',
              label: 'Register',
              color: Colors.orangeAccent,
              onPressed: () {
                //Go to login screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

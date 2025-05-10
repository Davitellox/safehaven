import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:safehaven/components/color.dart';
import 'package:safehaven/pages/logic/auth_wrapper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key,});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: Stack(
      children: [
        Container(
          decoration: bkgndcolor_grad,
        ),
        AnimatedSplashScreen(
          splash: Center(
            child: Image.asset(
                'assets/img/logo.png'), ////////////////
          ),
          nextScreen: AuthWrapper(),
          duration: 1200,
          backgroundColor: Colors.transparent,
          splashIconSize: 120,
          splashTransition: SplashTransition.fadeTransition,
        ),
      ],
    ));   
  }
}

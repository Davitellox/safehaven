import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:safehaven/components/color.dart';

class SplashScreenTo extends StatelessWidget {
  final screen;
  const SplashScreenTo({super.key, required this.screen});

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
            child: Lottie.asset(
                'assets/animation/planet.json', fit: BoxFit.cover), ////////////////
          ),
          nextScreen: screen,
          duration: 1200,
          backgroundColor: Colors.transparent,
          splashIconSize: 250,
          splashTransition: SplashTransition.fadeTransition,
        ),
      ],
    ));
  }
}

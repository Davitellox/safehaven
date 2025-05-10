import 'package:flutter/material.dart';
import 'package:safehaven/components/color.dart';
import 'dart:math';
import 'package:safehaven/components/typewriter_text.dart';
// import 'package:safehaven/pages/bintro_screen.dart';
import 'package:safehaven/pages/dhome_page.dart';

class WelcomeBackUser extends StatefulWidget {
  const WelcomeBackUser({super.key});

  @override
  State<WelcomeBackUser> createState() => _WelcomeBackUserState();
}

class _WelcomeBackUserState extends State<WelcomeBackUser> {
  // List of image assets
  final List<String> imageAssets = [
    'assets/avatars/a.jpeg',
    'assets/avatars/b.jpg',
    'assets/avatars/c.jpg',
    'assets/avatars/d.jpg',
    'assets/avatars/e.jpg',
  ];

  @override
  void initState() {
    super.initState();

    // Navigate to another screen after 3 Sec,
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    });
  }

  // Function to get a random image
  String getRandomImage() {
    final random = Random();
    return imageAssets[random.nextInt(imageAssets.length)];
  }

  @override
  Widget build(BuildContext context) {
    // Get a random image each time the widget is built
    // String randomImage = getRandomImage();
    final random = Random();
    String randomImage = imageAssets[random.nextInt(imageAssets.length)];

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            //background image
            Container(
              decoration: bkgndcolor_grad,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 9,
                  ),
                  TypewriterTextCustom(
                    textchoice: "WELCOME",
                    fontsizee: 44,
                    bold: true,
                    millisecspd: 180,
                    color: onboardingColor,
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  const TypewriterTextCustom(
                      textchoice: "BACK",
                      fontsizee: 40,
                      bold: true,
                      color: auxColor,
                      millisecspd: 180),
                  const SizedBox(
                    height: 20,
                  ),
                  ClipOval(
                      child: Image.asset(
                    randomImage,
                    width: 250.0,
                    height: 250.0,
                    fit: BoxFit.cover,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

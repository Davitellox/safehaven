import 'package:flutter/material.dart';
import 'package:safehaven/components/color.dart';
import 'package:safehaven/components/font.dart';
import 'package:safehaven/onboarding/onboardingview.dart';
import 'package:safehaven/pages/clogin_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    // checkIfAlreadySignedIn();
  }

  // Future<void> checkIfAlreadySignedIn() async {
  //   final user = FirebaseAuth.instance.currentUser;

  //   if (user != null) {
  //     final prefs = await SharedPreferences.getInstance();

  //     // Try getting name/email from prefs first (normal signup flow)
  //     String? savedName = prefs.getString('user_name');
  //     String? savedEmail = prefs.getString('user_email');

  //     if (savedName == null || savedEmail == null) {
  //       // Fall back to Google display name if prefs not set
  //       savedName = user.displayName ?? 'No Name';
  //       savedEmail = user.email ?? 'No Email';

  //       // Save it so home can use it
  //       prefs.setString('user_name', savedName);
  //       prefs.setString('user_email', savedEmail);
  //     }

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomePage()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // double screenwidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: ,
      // bottomSheet:
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: bkgndcolor_grad,
              //intro texts and subtext
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  //Top Texts and subtext
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * (20 / 800),
                        ),
                        Image.asset("assets/img/logo.png",
                            width: 130, height: 103),
                        FittedBox(
                          alignment: Alignment.center,
                          child: Center(
                            child: Image.asset("assets/img/logo_text.png",
                                width: 120, height: 48),
                          ),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * (24.4 / 800),
                        ),
                      ],
                    ),
                  ),
                  //Center button and user signup text
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      //Center button and new user text
                      children: [
                        const SizedBox(
                          height: 42,
                        ),
                        const Text(
                          "New User? Signup",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.6,
                            // fontSize: screenwidth* 0.033,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontfamlow,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                colors: [mainColor ?? Colors.black, auxColor2],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                          child: ElevatedButton(
                            //Registration Steps
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Onboardingview()));
                              // // app onboarding
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(
                                  8.0), // Remove padding if necessary
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45)),
                              elevation: 5,
                            ),
                            child: Image.asset(
                              'assets/img/signup_img.png', // Path to your GIF in assets
                              width: 250, // Adjust size as needed
                              height: 250,
                              // width: screenwidth* 0.578,
                              // height: screenHeight* 0.26,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20), right: Radius.circular(20)),
                    gradient: LinearGradient(
                        colors: [mainColor ?? Colors.black, auxColor2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15.6,
                    ),
                  ),
                  // const SizedBox(width: -3,),
                  TextButton(
                      child: const Text("Login",
                          style: TextStyle(
                              color: auxColor,
                              fontSize: 15.6,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        //Login Page
                        if (mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        }
                      }) //to login screen
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

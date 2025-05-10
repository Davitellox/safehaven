import 'package:flutter/material.dart';
import 'package:safehaven/components/color.dart';
import 'package:safehaven/pages/csignup_page.dart';
import 'package:safehaven/pages/logic/splash_screen_to.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_items.dart';

//stfl enter
class Onboardingview extends StatefulWidget {
  const Onboardingview({super.key});

  @override
  State<Onboardingview> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<Onboardingview> {
  final controller = OnboardingItems();
  final pageController = PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        // Container(decoration: bkgndcolor_grad,),
        Container(
          decoration: bkgndcolor_grad,
          // margin: const EdgeInsets.symmetric(horizontal: 15),
          child: PageView.builder(
            onPageChanged: (index) => setState(
                () => isLastPage = controller.items.length - 1 == index),
            itemCount: controller.items.length,
            controller: pageController,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(controller.items[index].image),
                  const SizedBox(height: 15),
                  Text(
                    controller.items[index].title,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    controller.items[index].description,
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: isLastPage
                ? BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20), right: Radius.circular(20)),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20), right: Radius.circular(20)),
                    gradient: LinearGradient(
                        colors: [mainColor ?? Colors.black, auxColor2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
            // color: isLastPage ? Colors.transparent : mainColor,
            padding: isLastPage
                ? EdgeInsets.symmetric(horizontal: 10, vertical: 45)
                : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: isLastPage
                ? getStarted()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //skip button
                      TextButton(
                          onPressed: () => pageController
                              .jumpToPage(controller.items.length - 1),
                          child: Text("Skip",
                              style: TextStyle(
                                color: onboardingColor,
                              ))),

                      //indicator
                      SmoothPageIndicator(
                        controller: pageController,
                        count: controller.items.length,
                        onDotClicked: (index) => pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeIn),
                        effect: WormEffect(
                          dotHeight: 12,
                          dotWidth: 12,
                          activeDotColor: auxColor2,
                        ),
                      ),

                      //next button
                      TextButton(
                          onPressed: () => pageController.nextPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeIn),
                          child: const Text("Next",
                              style: TextStyle(
                                color: onboardingColor,
                              ))),
                    ],
                  ),
          ),
        )
      ],
    ));
  }

  Widget getStarted() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          gradient: LinearGradient(
              colors: [Colors.blueGrey, auxColor2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextButton(
          onPressed: () async {
            final preff = await SharedPreferences.getInstance();
            preff.setBool("onboardin", true);

            if (!mounted) return;

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SplashScreenTo(
                          screen: SignupPage(),
                        )));
          },
          child: const Text(
            "Get started",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}

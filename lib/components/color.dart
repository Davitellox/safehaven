import 'package:flutter/material.dart';

// const primaryColor = Color(0xff7357ac);
Color? mainColor = Colors.blueGrey.shade600;
const onboardingColorDark = Colors.blueGrey;
const onboardingColor = Colors.white;
const auxColor = Colors.deepOrange;
const auxColor2 = Color.fromRGBO(11, 81, 110, 1);
const auxColor3 = Colors.lightBlue;

const bottomsheetbkgndcolor = BoxDecoration(
    borderRadius: BorderRadius.horizontal(
        left: Radius.circular(20), right: Radius.circular(20)),
    gradient: LinearGradient(
        colors: [Colors.blueGrey, auxColor2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight));

const bkgndcolor_grad = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Colors.black, Color.fromRGBO(37, 37, 37, 1)],
  ),
);

var style_container = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  gradient: LinearGradient(
      colors: [mainColor ?? Colors.black, auxColor2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight),
);

const form_bgGrad = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Colors.black, Color.fromRGBO(20, 20, 20, 1)],
  ),
);

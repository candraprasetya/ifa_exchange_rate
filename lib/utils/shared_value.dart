import 'package:flutter/material.dart';

mixin myColors {
  static const Color textBlack = Color(0xFF14142B);
  static const Color primary = Color(0xFF2e86de);
  static const Color bg = Color(0xFFFCFBFF);
}

const titleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    color: myColors.textBlack,
    fontWeight: FontWeight.w600);

const titleStyleThin = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 20,
  color: myColors.textBlack,
);

const countryStyle = TextStyle(
    fontFamily: 'Poppins',
    color: myColors.textBlack,
    fontSize: 14,
    fontWeight: FontWeight.w600);

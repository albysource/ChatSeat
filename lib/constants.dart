// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';

// --------------All color palettes are here --------------
// --------------------------------------------------------
const Color scaffold_color = Color(0xffF6F6F6);
const Color sub_heading_color = Color.fromRGBO(50, 17, 83, 0.6);
const Color text_field_color = Color(0xff822FAF);
const Color heading_color = Color(0xff973AA8);
const Color accent_pink = Color(0xffEA698B);
const Color dark_accent = Color(0xff6D23B6);
const Color nav_secondary = Color(0xff4F6266);

// ---------------- Gradients -----------------------------
// --------------------------------------------------------
final Shader headingGradient = const LinearGradient(colors: [
  Color(0xffD55D92),
  Color(0xffea698b),
  Color(0xff822faf),
  Color(0xffea698b),
  Color(0xffD55D92)
]).createShader(
  const Rect.fromLTWH(0.0, 0.0, 450.0, 70.0),
);

dynamic button_gradient = const LinearGradient(colors: [
  Color(0xffea698b),
  Color(0xff822faf),
]);

Gradient messageBoxGradient = const LinearGradient(colors: [
  Color(0xff9E46CD),
  Color(0xffB283E2),
]);

final Shader nameHeadingGradient = const LinearGradient(colors: [
  Color(0xffBA8CE9),
  Color(0xffCE78B0),
]).createShader(
  const Rect.fromLTWH(0.0, 0.0, 250.0, 70.0),
);

// -------------- Fonts -----------------------------------
// --------------------------------------------------------
const String FontFamily_main = 'Nunito';

// -------------------- TextStyles---------------------------
// ----------------------------------------------------------
TextStyle form_heading = const TextStyle(
  fontFamily: FontFamily_main,
  fontWeight: FontWeight.normal,
  fontSize: 15,
  color: const Color(0xff949494),
);

TextStyle messageTimeStyle = const TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 12,
  color: const Color(0xff808080),
);

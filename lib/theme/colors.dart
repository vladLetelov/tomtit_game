import 'dart:ui';

import 'package:flutter/cupertino.dart';

const Color deepDarkPurple = Color(0xFF1A002D);
const Color darkPurpleWithBlue = Color(0xFF1A0071);
const LinearGradient backgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    deepDarkPurple,
    darkPurpleWithBlue,
  ],
);
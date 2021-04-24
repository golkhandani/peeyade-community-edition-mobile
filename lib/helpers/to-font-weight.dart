import 'package:flutter/material.dart';

FontWeight toFontWeight(String str) {
  switch (str) {
    case 'light':
      return FontWeight.w300;
    case 'regular':
      return FontWeight.normal;
    case 'bold':
      return FontWeight.bold;
    default:
      return FontWeight.normal;
  }
}

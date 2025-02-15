
import 'package:flutter/material.dart';
import 'package:second_car_parking/app/utils/responsive_utils.dart';

class TextStyles {
  static TextStyle titleText(BuildContext context, {Color? color}) {
    return TextStyle(
        fontSize: calculateResponsiveValue(context, 35, false),
        color: color);
  }

  static TextStyle tinyText(BuildContext context, {Color? color}) {
    return TextStyle(
        fontSize: calculateResponsiveValue(context, 16, false),
        color: color);
  }

  static TextStyle errorText(BuildContext context, {Color? color}) {
    return TextStyle(
        fontSize: calculateResponsiveValue(context, 17, false),
        color: color);
  }
}

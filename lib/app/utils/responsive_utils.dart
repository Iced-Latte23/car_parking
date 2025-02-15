import 'package:flutter/widgets.dart';

double calculateResponsiveValues(
    BuildContext context,
    double targetValue,
    bool useWidth,
    bool responsiveProperties,
    ) {
  double screenSize = useWidth
      ? MediaQuery.of(context).size.width
      : MediaQuery.of(context).size.height;

  if (responsiveProperties) {
    // Calculate the multiplier to reach the target value
    double multiplier = targetValue / screenSize;
    return screenSize * multiplier;
  } else {
    // Calculate the responsive value directly
    return screenSize * targetValue;
  }
}

double calculateResponsiveValue(
    BuildContext context,
    double targetValue,
    bool useWidth,
    ) {
  double screenSize = useWidth
      ? MediaQuery.of(context).size.width
      : MediaQuery.of(context).size.height;

  double multiplier = targetValue / screenSize;
  return screenSize * multiplier;
}


import 'package:flutter/material.dart';

class Responsive {
  static const double mobile = 768;
  static const double tablet = 1024;

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isMobile(BuildContext context) {
    return width(context) < mobile;
  }

  static bool isTablet(BuildContext context) {
    return width(context) >= mobile &&
        width(context) < tablet;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= tablet;
  }

  static double loginWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 450;
    }

    if (isTablet(context)) {
      return 400;
    }

    return width(context) * .90;
  }
}
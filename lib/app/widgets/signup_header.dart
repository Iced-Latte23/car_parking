import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class SignUpHeader extends StatelessWidget {
  final Size screenSize;

  const SignUpHeader({Key? key, required this.screenSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize.width,
      height: calculateResponsiveValue(context, screenSize.height / 3, false),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'images/sign_up.jpg',
              width: calculateResponsiveValue(context, 220, true),
            ),
          ),
          Positioned(
            top: calculateResponsiveValue(context, 100, false),
            left: calculateResponsiveValue(context, 35, true),
            child: const Text(
              'Sign Up now!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

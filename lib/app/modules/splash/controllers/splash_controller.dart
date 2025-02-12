import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("SplashController Initialized"); // Check if this prints
    _navigateToHome();
  }

  void _navigateToHome() async {
    print("Navigating to login..."); // Check if this prints
    await Future.delayed(Duration(seconds: 3));
    print("Now navigating...");
    Get.offAllNamed('/login');
  }
}

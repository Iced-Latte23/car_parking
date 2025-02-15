import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController lottieController;
  var showName = false.obs; // Observable for brand name visibility

  @override
  void onInit() {
    super.onInit();
    lottieController = AnimationController(vsync: this);
    Future.delayed(const Duration(microseconds: 1500), () {
      showName.value = true;
    });
    _navigateToNextScreen();
  }

  @override
  void onClose() {
    lottieController.dispose();
    super.onClose();
  }

  Future<Map<String, dynamic>> _getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('userId'),
      'phoneNumber': prefs.getString('phoneNumber'),
    };
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Ensure splash completes
    final session = await _getUserSession();

    if (session['userId'] != null) {
      Get.offNamed('/home', arguments: session['userId']);
    } else {
      Get.offAllNamed('/login');
    }
  }
}

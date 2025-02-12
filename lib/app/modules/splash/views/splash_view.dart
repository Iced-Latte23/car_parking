import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  final SplashController _controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation
            Lottie.asset(
              "assets/json/car_parking_logo.json",
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.contain,
              controller: _controller.lottieController,
              onLoaded: (composition) {
                _controller.lottieController
                  ..duration = composition.duration
                  ..forward();
              },
            ),
            const SizedBox(height: 20),

            // Show brand name with fade-in effect
            Obx(() => AnimatedOpacity(
              opacity: _controller.showName.value ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

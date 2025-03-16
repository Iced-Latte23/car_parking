import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/signup_form.dart';
import '../../../widgets/signup_header.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  SignupView({super.key});

  final SignupController controller = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(children: [
          Column(
            children: [
              SignUpHeader(screenSize: screenSize),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SignupForm(),
              ),
            ],
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          })
        ]),
      ),
    );
  }
}

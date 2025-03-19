import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/firebase_controller.dart';
import '../../../widgets/show_dialog.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ShowDialog dialog = ShowDialog();
  final FirebaseController firebaseController = FirebaseController();
  final formKey = GlobalKey<FormState>();
  var errorMessage = ''.obs;
  var showPass = true.obs;
  var isLoading = false.obs; // Observable for loading state

  @override
  void onInit() {
    super.onInit();
    determineNextScreen();
  }

  @override
  void onClose() {
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login(BuildContext context) async {
    isLoading.value = true;

    try {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }
      formKey.currentState!.save();

      // Check if fields are empty
      final phone = phoneNumberController.text.trim();
      final password = passwordController.text.trim();

      if (phone.isEmpty || password.isEmpty) {
        Get.snackbar('Error', 'Please fill in all fields.');
        return;
      }

      final cleanPhoneNumber = phone.replaceAll(' ', '');

      // Authenticate user
      final userCredential = await firebaseController.loginWithPhoneAndPassword(
          context, cleanPhoneNumber, password);
      if (userCredential == null || userCredential.user == null) {
        return;
      }

      // Save session and navigate
      await saveUserSession(userCredential.user!.uid, phone);
      print("------- UID: $userCredential.user!.uid");
      Get.offAllNamed('/home', arguments: userCredential.user!.uid);
    } catch (error) {
      Get.snackbar('Error', 'An error occurred: ${error.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveUserSession(String userId, String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('phoneNumber', phoneNumber);
  }

  Future<void> sendMagicLink(String email) async {
    try {
      await firebaseController.sendMagicLink(email);
      Get.snackbar('Email Sent', 'Check your email for the validation link.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      errorMessage.value = 'Error sending email. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final phoneNumber = prefs.getString('phoneNumber');
    return {'userId': userId, 'phoneNumber': phoneNumber};
  }

  Future<void> determineNextScreen() async {
    final session = await getUserSession();
    if (session['userId'] != null) {
      Get.offNamed('/home', arguments: session['userId']);
    } else {
      Get.offAll('/login');
    }
  }
}

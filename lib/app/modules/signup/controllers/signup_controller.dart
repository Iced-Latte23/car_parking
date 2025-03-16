import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/firebase_controller.dart';
import '../../../widgets/show_dialog.dart';

class SignupController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseController firebaseController = Get.put(FirebaseController());
  final ShowDialog dialog = ShowDialog();

  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;
  RxBool isLoading = false.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? password;
  String? confirmPassword;

  GlobalKey<FormState> get formKey => _formKey;

  void toggleShowPassword() => showPassword.value = !showPassword.value;

  void toggleShowConfirmPassword() => showConfirmPassword.value = !showConfirmPassword.value;

  Future<bool> _checkExistingUser(BuildContext context, String email, String phoneNumber) async {
    try {
      final emailCheckResponse = await _firestore.collection(
          FirestoreCollections.users).where('email', isEqualTo: email).get();

      // Check if phone number exists in Firestore
      final phoneCheckResponse = await _firestore
          .collection(FirestoreCollections.users)
          .where('phone', isEqualTo: phoneNumber.replaceAll(' ', ''))
          .get();

      if (phoneCheckResponse.docs.isNotEmpty) {
        dialog.error(context, 'Phone number already exists! Try login.');
        return false;
      }

      if (emailCheckResponse.docs.isNotEmpty) {
        dialog.error(context, 'Email already exists! Try login.');
        return false;
      }

      return true;
    } catch (e, stackTrace) {
      debugPrint("🚨 Error checking existing user: $e");
      debugPrint(stackTrace.toString()); // Prints detailed error stack trace
      dialog.error(context, 'An error occurred while checking user existence.');
      return false;
    }
  }

  Future<bool> _validateInputs(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return false;
    _formKey.currentState!.save();

    // Validate password match
    if (confirmPassword != password) {
      dialog.error(context, 'Passwords do not match!');
      return false;
    }

    return true;
  }

  Future<void> registerUser(BuildContext context) async {
    isLoading.value = true;
    if (!await _validateInputs(context)) {
      isLoading.value = false;
      return;
    }
    if (!await _checkExistingUser(context, email!, phoneNumber!)) {
      isLoading.value = false;
      return;
    }

    try {
      await firebaseController.register(
          context, email!, password!, firstName!, lastName!,
          phoneNumber!.replaceAll(' ', ''));

      // Reset form and state after the dialog closes
      _formKey.currentState?.reset();
      firstName = null;
      lastName = null;
      email = null;
      phoneNumber = null;
      password = null;
      confirmPassword = null;
    } catch (e) {
      debugPrint("--- Error: $e");
      dialog.error(context, 'An unexpected error occurred. Try again later.');
    } finally {
      isLoading.value = false;
    }
  }
}

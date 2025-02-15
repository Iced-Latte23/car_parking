import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/firebase_controller.dart';
import '../../../utils/text_format.dart';

class ProfileController extends GetxController {
  final FirebaseController firebaseController = Get.put(FirebaseController());
  final String userId = Get.arguments?['userId'] ?? 'Unknown';
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  RxString email = ''.obs;
  RxString emailStatus = ''.obs;
  RxString profileImage = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Fetch user data from Firestore
  Future<void> fetchUserData() async {
    if (userId.isEmpty) {
      return;
    }

    isLoading.value = true;
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userData.exists) {
        profileImage.value = userData['image']?.isNotEmpty == true ? userData['image'] : 'assets/images/default_profile.jpg';
        firstNameController.text = userData['first_name'] ?? '';
        lastNameController.text = userData['last_name'] ?? '';
        email.value = userData['email'] ?? '';
        emailStatus.value = userData['email_verified'] == true ? 'Verified' : 'Unverified';
        phoneController.text = PhoneNumberFormatter().formatPhoneNumber(userData['phone']);

        print("----------- Fetched profile image URL: ${profileImage.value}");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user data in Firestore
  Future<void> updateProfile() async {
    if (userId.isEmpty) {
      print("User ID is missing.");
      return;
    }

    isUpdating.value = true;
    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'phone': phoneController.text,
        'image': profileImage.value,
      });

      Get.snackbar("Success", "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("Error updating user data: $e");
      Get.snackbar("Error", "Failed to update profile!",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUpdating.value = false;
    }
  }
}

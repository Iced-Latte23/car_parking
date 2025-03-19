import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_car_parking/app/widgets/show_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/firebase_controller.dart';
import '../../../widgets/reservation_confirm.dart';

class ReservedController extends GetxController {
  final slots = <Map<String, dynamic>>[].obs;
  final ShowDialog dialog = ShowDialog();
  final FirebaseController firebaseController = FirebaseController();
  var selectedSlot = RxInt(-1);

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  var selectedTime = Rxn<TimeOfDay>();

  @override
  void onInit() {
    super.onInit();
    loadSlots();
  }

  Future<void> loadSlots() async {
    try {
      QuerySnapshot snapshot = await firebaseController.fetchSlots();
      slots.value = snapshot.docs.map((doc) {
        return {'id': doc.id, 'status': doc['status']};
      }).toList();
    } catch (e) {
      print('Error loading slots: $e');
    }
  }

  void selectSlot(int index) {
    final slotStatus = slots[index]['status'];
    if (slotStatus == 'occupied') {
      dialog.showOccupiedDialog();
      return;
    }

    if (selectedSlot == index) {
      selectedSlot.value = -1;
      return;
    }

    selectedSlot.value = index;
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedPhoneNumber = prefs.getString('phoneNumber');
    String? storeUserId = prefs.getString('userId');

    if (storedPhoneNumber != null) {
      phoneNumberController.text = storedPhoneNumber;
    }
    try {
      DocumentSnapshot userDoc =
          await firebaseController.fetchUserData(storeUserId);
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        firstNameController.text = userData['first_name'] ?? '';
        lastNameController.text = userData['last_name'] ?? '';
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void confirmSelection() async {
    if (selectedSlot.value != -1) {
      final index = selectedSlot.value;
      final slot = slots[index];
      await loadUserData();

      // Show the bottom sheet for confirmation
      Get.bottomSheet(
          ReservationBottomSheet(
              firstNameController: firstNameController,
              lastNameController: lastNameController,
              plateNumberController: plateNumberController,
              phoneNumberController: phoneNumberController,
              slotId: slot['id'].toString(),
              onConfirm: () async {
                if (selectedTime.value == null ||
                    firstNameController.text.isEmpty ||
                    lastNameController.text.isEmpty ||
                    plateNumberController.text.isEmpty ||
                    phoneNumberController.text.isEmpty) {
                  Get.snackbar('Error', 'Please fill in all fields.',
                      backgroundColor: Colors.red, colorText: Colors.white);
                  return;
                }

                await firebaseController.addReservation(
                    firstNameController.text,
                    lastNameController.text,
                    plateNumberController.text,
                    phoneNumberController.text,
                    slot['id'],
                    "${selectedTime.value!.hour}:${selectedTime.value!.minute}");

                // Update slot status in Firestore
                await firebaseController.updateSlotStatus(
                    slot['id'], slot['status']);

                // Update the slot's local status
                slots[index] = {
                  'id': slot['id'],
                  'status': slot['status'] == 'free' ? 'occupied' : 'free'
                };

                clearFields();
                dialog.showSuccessReservation();
              }),
          isScrollControlled: true);
    }
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    plateNumberController.clear();
    phoneNumberController.clear();
    selectedSlot.value = -1;
    selectedTime.value = null;
    Get.back();
  }

  void cancelSelection() {
    selectedSlot.value = -1;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/text_styles.dart';

class ShowDialog {
  void error(BuildContext context, String message) {
    Get.dialog(
      AlertDialog(
        title: Text('Error', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message,
            style: TextStyles.errorText(context, color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Center(
                child: Text("Close", style: TextStyle(color: Colors.red))),
          ),
        ],
      ),
    );
  }

  void showOccupiedDialog() {
    Get.defaultDialog(
        title: "Error",
        content: Text("This slot is occupied",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        barrierDismissible: false,
        radius: 10,
        actions: [
          ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text('OK'))
        ]);
  }

  void success(BuildContext context, String message) {
    Get.dialog(
      AlertDialog(
        title: Text('Success', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'Registration successful. Please login to continue.',
          style: TextStyle(color: Colors.green),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.grey)),
            onPressed: () {
              Get.back(); // Close dialog
              Get.offAllNamed('/login'); // Redirect to login
            },
            child: Center(
                child: Text("Close", style: TextStyle(color: Colors.black))),
          ),
        ],
      ),
    );
  }

  void showSuccessReservation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        title: Center(
          child: Text(
            'Success Reservation',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Adjust font size for clarity
              color: Colors.green, // Green for success
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60, // Slightly bigger icon
            ),
            SizedBox(height: 15),
            Text(
              'Your reservation has been successfully confirmed!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16, // Consistent font size
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false, // Prevents closing when tapping outside the dialog
    );
  }

}

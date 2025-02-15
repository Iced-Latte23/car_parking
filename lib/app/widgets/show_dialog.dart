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
              backgroundColor: WidgetStatePropertyAll(Colors.grey)
            ),
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
}
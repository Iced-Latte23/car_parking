import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs; // Observable for loading state

  void login(String username, String password) async {
    isLoading.value = true;

    await Future.delayed(Duration(seconds: 2)); // Simulating API call

    if (username == "admin" && password == "1234") {
      Get.offAllNamed('/home'); // Navigate to home
    } else {
      Get.snackbar("Error", "Invalid username or password");
    }

    isLoading.value = false;
  }
}

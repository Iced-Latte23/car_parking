import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart'; // Update with your path

class LoginView extends StatelessWidget {
  final LoginController controller = Get.put(LoginController()); // Inject controller
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                controller.login(
                  usernameController.text,
                  passwordController.text,
                );
              },
              child: Text("Login"),
            )),
          ],
        ),
      ),
    );
  }
}

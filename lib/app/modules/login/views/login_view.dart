import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_utils.dart';
import '../../../utils/text_format.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/forgot_dialong.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          padding: EdgeInsets.symmetric(
              horizontal: calculateResponsiveValue(context, 25, true)),
          child: Column(
            children: [
              _buildHeader(context),
              _buildLoginForm(context, controller, screenSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.3,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/images/login_pic.jpg',
              width: calculateResponsiveValue(context, 370, true),
            ),
          ),
          Positioned(
            top: calculateResponsiveValue(context, 120, false),
            left: 25,
            child: Text(
              'Welcome back!\nLogin to continue',
              style: TextStyle(
                fontSize: calculateResponsiveValue(context, 30, false),
                fontFamily: 'Parkinsans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(
      BuildContext context, LoginController controller, Size screenSize) {
    return Expanded(
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildPhoneField(context, controller),
            SizedBox(height: 20),
            _buildPasswordField(controller),
            SizedBox(height: 3),
            _buildForgotPassword(context),
            SizedBox(height: 35),
            _buildLoginButton(context, controller, screenSize),
            SizedBox(height: 15),
            _buildSignUpLink(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context, LoginController controller) {
    return TextFormField(
      controller: controller.phoneNumberController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        PhoneNumberFormatter(),
        LengthLimitingTextInputFormatter(12),
      ],
      decoration: _buildInputDecoration(
        context,
        icon: Icons.phone,
        hintText: "Phone Number",
      ),
    );
  }

  Widget _buildPasswordField(LoginController controller) {
    return Obx(() => TextFormField(
      controller: controller.passwordController,
      obscureText: controller.showPass.value,
      decoration: _buildInputDecoration(
        null,
        icon: Icons.password,
        hintText: "Password",
        suffixIcon: IconButton(
          onPressed: () => controller.showPass.toggle(),
          icon: Icon(
              controller.showPass.value ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    ));
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => ForgotPasswordDialog(),
          );
        },
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Text(
          'Forgot Password?',
          style: TextStyles.tinyText(context, color: Colors.blue[600]),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
      BuildContext context, LoginController controller, Size screenSize) {
    return Obx(() => ElevatedButton(
      onPressed: controller.isLoading.value
          ? null
          : () async {
        controller.isLoading.value = true;
        await controller.login(context);
        controller.isLoading.value = false;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        fixedSize: Size(
          calculateResponsiveValue(context, screenSize.width, true),
          calculateResponsiveValue(context, 50, false),
        ),
      ),
      child: controller.isLoading.value
          ? CircularProgressIndicator(color: Colors.white)
          : Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: calculateResponsiveValue(context, 20, false),
        ),
      ),
    ));
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyles.tinyText(context, color: Colors.black),
        ),
        TextButton(
          onPressed: () => Get.offNamed('/signup'),
          child: Text(
            'Sign up',
            style: TextStyles.tinyText(context, color: Colors.green[600]),
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(BuildContext? context,
      {required IconData icon, required String hintText, Widget? suffixIcon}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.black54),
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: TextStyle(
        color: Color.fromARGB(255, 197, 195, 195),
        fontSize: context != null ? calculateResponsiveValue(context, 20, false) : 16,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.5),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
    );
  }
}

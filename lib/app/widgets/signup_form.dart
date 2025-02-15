import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../modules/signup/controllers/signup_controller.dart';
import '../utils/responsive_utils.dart';
import '../utils/text_format.dart';
import '../utils/text_styles.dart';

class SignupForm extends StatelessWidget {
  final SignupController controller = Get.find<SignupController>();

  // Check password format
  bool isValid(String value) {
    return RegExp(r'[a-zA-Z]').hasMatch(value) && // Contains letters
        RegExp(r'[0-9]').hasMatch(value) && // Contains numbers
        RegExp(r'[^a-zA-Z0-9]').hasMatch(value); // Contains special characters
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: calculateResponsiveValue(context, 25, true)),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            _buildNameField(),
            const SizedBox(height: 20),
            _buildEmailField(),
            const SizedBox(height: 20),
            _buildPhoneNumberField(),
            const SizedBox(height: 20),
            _buildPasswordField(),
            const SizedBox(height: 20),
            _buildConfirmPasswordField(),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () async {
                await controller.registerUser(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
                fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width, calculateResponsiveValue(context, 50, false))),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white, fontSize: calculateResponsiveValue(context, 18, false)),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?', style: TextStyles.tinyText(context)),
                TextButton(
                  onPressed: () {
                    Get.offNamed('/login');
                  },
                  child: Text('Login', style: TextStyles.tinyText(context, color: Colors.green[600])),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => controller.email = value,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email';
        if (!isValid(value)) return 'Invalid email format';
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email, color: Colors.black54),
        hintText: 'Email',
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.5)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
      ),
    );
  }

  Widget _buildNameField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onSaved: (value) => controller.firstName = value,
            validator: (value) => value == null || value.isEmpty ? 'Please enter your first name' : null,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person, color: Colors.black54),
              hintText: 'First name',
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.5)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            onSaved: (value) => controller.lastName = value,
            validator: (value) => value == null || value.isEmpty ? 'Please enter your last name' : null,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person, color: Colors.black54),
              hintText: 'Last name',
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.5)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (value) => controller.phoneNumber = value,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter phone number';
        if (value.trim().length < 11 ) return 'Invalid phone number';
        return null;
      },
      inputFormatters: [
        PhoneNumberFormatter(),
        LengthLimitingTextInputFormatter(12)
      ],
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone_android, color: Colors.black54),
        hintText: 'Phone Number',
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.5)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() {
      return TextFormField(
        obscureText: !controller.showPassword.value,
        onSaved: (value) => controller.password = value,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter password';
          if (value.length < 6) return 'Password must be at least 6 characters';
          if (!isValid(value)) return 'Password should contain letters, numbers, and special characters';
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock, color: Colors.black54),
          hintText: 'Password',
          suffixIcon: IconButton(
            onPressed: controller.toggleShowPassword,
            icon: Icon(controller.showPassword.value ? Icons.visibility : Icons.visibility_off, color: Colors.black54),
          ),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.5)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
        ),
      );
    });
  }

  Widget _buildConfirmPasswordField() {
    return Obx(() {
      return TextFormField(
        obscureText: !controller.showConfirmPassword.value,
        onSaved: (value) => controller.confirmPassword = value,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter confirm password';
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock, color: Colors.black54),
          hintText: 'Confirm Password',
          suffixIcon: IconButton(
            onPressed: controller.toggleShowConfirmPassword,
            icon: Icon(controller.showConfirmPassword.value ? Icons.visibility : Icons.visibility_off, color: Colors.black54),
          ),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.5)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
        ),
      );
    });
  }
}




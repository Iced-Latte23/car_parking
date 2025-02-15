import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/text_format.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile Picture
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image with Floating Button
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            // Making it circular
                            child: Container(
                              color: Colors.grey[200],
                              child: SizedBox(
                                height: 170,
                                width: 170,
                                child:
                                    controller.profileImage.value.isNotEmpty &&
                                            Uri.tryParse(controller
                                                        .profileImage.value)
                                                    ?.hasAbsolutePath ==
                                                true
                                        ? Image.network(
                                            controller.profileImage.value,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            controller.profileImage.value,
                                            // Correct way to load asset
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                          // Floating Button for Change Profile
                          Padding(
                            padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
                            child: FloatingActionButton(
                              onPressed: () {}, // Implement Image Picker Here
                              backgroundColor: Colors.transparent,
                              elevation: 5,
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                /// First Name & Last Name Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// First Name Input
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('First Name',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: controller.firstNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Spacing between first & last name

                    /// Last Name Input
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last Name',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextField(
                            controller: controller.lastNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                /// Email Field
                Text('Email',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  controller:
                      TextEditingController(text: controller.email.value),
                  enabled: false, // Email should not be editable
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    suffixIcon: controller.emailStatus.value == "Verified"
                        ? Icon(Icons.verified, color: Colors.green)
                        : Icon(Icons.warning, color: Colors.red),
                  ),
                ),
                SizedBox(height: 20),

                /// Phone Field
                Text('Phone',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  controller: controller.phoneController,
                  inputFormatters: [
                    PhoneNumberFormatter(),
                    LengthLimitingTextInputFormatter(12)
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  ),
                ),
                SizedBox(height: 30),

                /// Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Obx(() => controller.isUpdating.value
                        ? CircularProgressIndicator()
                        : Text("Save Changes", style: TextStyle(fontSize: 16))),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

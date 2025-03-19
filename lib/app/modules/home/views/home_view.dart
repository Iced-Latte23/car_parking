import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_car_parking/app/controller/firebase_controller.dart';
import 'package:second_car_parking/app/modules/home/controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final String id = Get.arguments ?? '';

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final FirebaseController firebaseController = Get.put(FirebaseController());

    return Scaffold(
      drawer: _buildDrawer(controller, firebaseController),
      appBar: _buildAppBar(context),
      body: _buildBody(controller),
    );
  }

  Widget _buildDrawer(
      HomeController controller, FirebaseController firebaseController) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade600],
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                  controller.profileImagePath.value.isNotEmpty && Uri.tryParse(controller.profileImagePath.value)?.hasAbsolutePath == true
                      ? NetworkImage(
                      controller.profileImagePath.value) // Load from network
                      : AssetImage(controller.profileImagePath.value)
                  as ImageProvider,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Text(
                        'Loading...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      );
                    }

                    // Ensure firstName and lastName are not empty before displaying
                    String fullName =
                        '${controller.firstName.value} ${controller.lastName.value}'
                            .trim();

                    // Fallback if both firstName and lastName are empty
                    return Text(
                      fullName.isNotEmpty ? 'Hello, $fullName' : 'Hello, Guest',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blue.shade800),
            title: Text('Home'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue.shade800),
            title: Text('Profile'),
            onTap: () {
              Get.toNamed('/profile', arguments: {'userId': id});
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue.shade800),
            title: Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blue.shade800),
            title: Text('Settings'),
            onTap: () {
              Get.toNamed('/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.support_agent, color: Colors.blue.shade800),
            title: Text('Support/Help'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade800),
            title: Text('Logout'),
            onTap: firebaseController.logout,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      backgroundColor: Colors.blue.shade800,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.only(top: 25),
        child: Text(
          'University Parking',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      leading: Builder(
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(top: 25),
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu, size: 30, color: Colors.white),
            ),
          );
        },
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(top: 25, right: 20),
          child: Badge.count(
            count: 3, // Example notification count
            child: Icon(Icons.notifications, size: 30, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(HomeController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildProfile(controller),
            SizedBox(height: 20),
            _buildAvailableSpotCard(),
            SizedBox(height: 20),
            _buildParkingStatusCard(),
            SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(HomeController controller) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Obx(() {
            return SizedBox(
              height: 50,
              width: 50,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: controller.profileImagePath.value.isNotEmpty && Uri.tryParse(controller.profileImagePath.value)?.hasAbsolutePath == true
                    ? NetworkImage(
                        controller.profileImagePath.value) // Load from network
                    : AssetImage(controller.profileImagePath.value)
                        as ImageProvider, // Load from assets
              ),
            );
          }),
          SizedBox(width: 12),
          // User Name
          Obx(() {
            return Text(
              'Hello, ${controller.firstName.value} ${controller.lastName.value}',
              // Replace with dynamic data
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAvailableSpotCard() {
    return Container(
      padding: EdgeInsets.all(18),
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_parking, size: 30, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Available Spots',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              '30',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Colors.green.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingStatusCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(18),
        width: double.infinity,
        height: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade800],
          ),
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                'Current Parking Status',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.white),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildParkingInfoColumn(Icons.local_parking, 'Slot 1'),
                _buildParkingInfoColumn(Icons.access_time, '10:30 AM'),
                _buildParkingInfoColumn(Icons.timer, '2 hours'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParkingInfoColumn(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.white),
        SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButtonContainer('assets/icons/reserved.png', 'Reserve', () {
          Get.toNamed('/reserved');
        }),
        _buildButtonContainer('assets/icons/history.png', 'History', () {}),
      ],
    );
  }

  Widget _buildButtonContainer(
      String imgPath, String title, VoidCallback onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed, // This will trigger the action
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.red.shade800, Colors.orange.shade600],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  child: Image.asset(imgPath),
                ),
                SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class HomeController extends GetxController {
  late String id;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var profileImagePath = ''.obs;
  var isLoading = true.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments ?? '';

    // Debugging
    print("------- Get.arguments: ${Get.arguments}");
    print("------- Assigned ID: $id");
    fetchUserData();
  }

  // Fetch user data and update the reactive variables
  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;

      // 🔴 Check if ID is empty before making Firestore request
      if (id.isEmpty) {
        print("------- Error: ID is empty!");
        isLoading.value = false;
        return;
      } else {
        print("------- Fetching user with ID: $id"); // Debugging log
      }

      // Fetch user by document ID
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(id).get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;

        // Debugging: Print fetched data
        print("------- User Data: $userData");

        // Update reactive variables
        firstName.value = userData['first_name'] ?? 'No first name';
        lastName.value = userData['last_name'] ?? 'No last name';
        profileImagePath.value = userData['image'] ?? 'No image';

        isLoading.value = false;
      } else {
        print("------- No user found with ID: $id");
        isLoading.value = false;
      }
    } catch (e) {
      print("------- Error fetching user data: $e");
      isLoading.value = false;
    }
  }
}

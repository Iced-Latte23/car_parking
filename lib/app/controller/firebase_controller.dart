import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/show_dialog.dart';

class FirebaseController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ShowDialog dialog = ShowDialog();

  var user = Rxn<User>();
  var isSignUp = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    handleAuthState();
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<void> handleAuthState() async {
    _auth.authStateChanges().listen((User? user) async {
      if (isSignUp.value) {
        return;
      }
    });
  }

  Future<User?> register(BuildContext context, String email, String password,
      String firstName, String lastName, String phoneNumber) async {
    try {
      isSignUp.value = true;

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userCredential.user!.uid)
          .set({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phoneNumber,
        'email_verified': false,
        'role': 'user',
        'status': 'active',
        'image': '',
        'register_date': DateTime.now().toIso8601String(),
      });

      await _auth.signOut();

      await Get.dialog(
        AlertDialog(
          title: Text('Success', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
            'Registration successful. Please login to continue.',
            style: TextStyle(color: Colors.green),
          ),
          actions: [
            TextButton(
              onPressed: () {
                isSignUp.value = false;
                Get.offAllNamed('/login'); // Redirect to login
              },
              child: Center(
                  child: Text("Close", style: TextStyle(color: Colors.grey))),
            ),
          ],
        ),
      );
      return userCredential.user;
    } catch (e) {
      // dialog.error(context, e.toString());
      isSignUp.value = false;
      return null;
    }
  }

  Future<void> logout() async {
    try {
      // Show confirmation dialog
      Get.defaultDialog(
        title: "Logout",
        middleText: "Are you sure you want to logout?",
        textConfirm: "Yes",
        textCancel: "No",
        onConfirm: () async {
          Get.back();

          // Firebase sign-out
          if (_auth.currentUser != null) {
            await _auth.signOut();
          }

          // Clear SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          // Navigate to login screen
          Get.offAllNamed('/login');
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out');
    }
  }

  Future<DocumentSnapshot?> getUserData({String? phone, String? uid}) async {
    try {
      if (uid != null) {
        // Fetch user by UID
        return await _firestore
            .collection(FirestoreCollections.users)
            .doc(uid)
            .get();
      } else if (phone != null) {
        // Fetch user where phone matches
        QuerySnapshot querySnapshot = await _firestore
            .collection(FirestoreCollections.users)
            .where('phone', isEqualTo: phone)
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first;
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }

  Future<void> saveUserSession(String userId, String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('phoneNumber', phoneNumber);
  }

  Future<void> sendMagicLink(String email) async {
    await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
            url: "URL",
            handleCodeInApp: true,
            androidPackageName: 'com.example.car_parking'));
  }

  Future<UserCredential?> loginWithPhoneAndPassword(
      BuildContext context, String phone, String password) async {
    final userDoc = await _firestore
        .collection(FirestoreCollections.users)
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();

    if (userDoc.docs.isEmpty) {
      dialog.error(context, "This phone number is not registered.");
      return null;
    }

    final userData = userDoc.docs.first.data();
    final email = userData['email'];

    try {
      // Authenticate using Firebase Authentication
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      dialog.error(context, 'Invalid phone number or password.');
      return null;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    if (user.value != null) {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.value!.uid)
          .update(updatedData);
    }
  }
}

class FirestoreCollections {
  static const String users = 'users';
}

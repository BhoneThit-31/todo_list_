import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    // No navigation here
  }

  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Registration Error', e.message ?? 'Unknown error');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.back(); // Close loading dialog
    } on FirebaseAuthException catch (e) {
      Get.back(); // Ensure dialog closes on error
      Get.snackbar('Login Error', e.message ?? 'Unknown error');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String get userId => firebaseUser.value?.uid ?? '';
}

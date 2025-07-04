import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../configs/routes/route.dart';
import '../../../utils/services/firestore_service.dart';
import '../models/user_model.dart';

class LandingController extends GetxController {
  static LandingController get to => Get.find();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Stream<User?> get streamAuth => auth.authStateChanges();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final usernameTextController = TextEditingController();
  final isPassword = true.obs;
  final isLoading = false.obs;
  final GoogleSignIn signIn = GoogleSignIn.instance;

  @override
  void onClose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    usernameTextController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPassword.toggle();
  }

  bool get isFormValid =>
      emailTextController.text.isNotEmpty ||
      passwordTextController.text.isNotEmpty;

  Future<void> login(String email, String pass) async {
    isLoading.value = true;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);
      Get.offAllNamed(Routes.homeRoute);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'Login failed: ${e.message}';
      }
      _showErrorDialog(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      await signIn.signOut();
      await signIn.disconnect();
      Get.offAllNamed(Routes.landingRoute);
    } catch (e) {
      _showErrorDialog('Logout failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      _showErrorDialog('Please enter a valid email address');
      return;
    }

    isLoading.value = true;
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.defaultDialog(
        title: "Success".tr,
        middleText: "We've sent a password reset link to: $email".tr,
        onConfirm: () {
          Get.back();
          Get.back();
        },
        textConfirm: "OK".tr,
      );
    } catch (e) {
      _showErrorDialog('Password reset failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup(String email, String pass) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);

      if (userCredential.user != null) {
        UserModel newUser = UserModel(
          username: usernameTextController.text,
          email: userCredential.user!.email!,
        );
        await _firestoreService.addUser(newUser.toMap());
      }

      Get.offAllNamed(Routes.landingRoute);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'Registration failed: ${e.message}';
      }
      _showErrorDialog(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSignIn() async {
    isLoading.value = true;
    try {

      final GoogleSignInAccount gUser = await signIn.authenticate();

      final GoogleSignInAuthentication gAuth = gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.idToken,
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final isEmailExists =
            await _firestoreService.isEmailExists(user.email!);
        if (!isEmailExists) {
          UserModel newUser = UserModel(
            username: user.displayName ?? '',
            email: user.email!,
            photoUrl: user.photoURL,
            phoneNumber: user.phoneNumber,
          );

          await _firestoreService.addUser(newUser.toMap());
        }
      }

      Get.offAllNamed(Routes.homeRoute);
    } catch (e) {
      _showErrorDialog('Google sign in failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorDialog(String message) {
    Get.defaultDialog(
      title: "Error".tr,
      middleText: message.tr,
      textConfirm: "OK".tr,
      onConfirm: () => Get.back(),
    );
  }
}

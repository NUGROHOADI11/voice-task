import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../note/repositories/note_repository.dart';
import '../../../configs/routes/route.dart';
import '../../../utils/services/firestore_service.dart';
import '../../task/repositories/task_repository.dart';
import '../models/user_model.dart';
import '../repositories/landing_repository.dart';

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
  final landingRepository = LandingRepository();
  String? clientId;
  String? serverClientId = dotenv.env['SERVER_CLIENT_ID']!;
  GoogleSignInAccount? currentUser;
  bool isAuthorized = false;
  String errorMessage = '';

  @override
  void onInit() {
    super.onInit();
    unawaited(signIn
        .initialize(clientId: clientId, serverClientId: serverClientId)
        .then((_) {
      signIn.authenticationEvents
          .listen(_handleAuthenticationEvent)
          .onError(_handleAuthenticationError);
      // signIn.attemptLightweightAuthentication();
    }));
  }

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
      final userCredential =
          await auth.signInWithEmailAndPassword(email: email, password: pass);
      if (userCredential.user != null) {
        final userDoc =
            await _firestoreService.getUserDetail(userCredential.user!.uid);

        if (userDoc.exists) {
          NoteRepository().deleteAllNotes();
          TaskRepository().deleteAllTasks();
          final data = userDoc.data() as Map<String, dynamic>;
          final userModel = UserModel.fromMap(data, userDoc.id);
          await landingRepository.saveUserProfile(userModel);
        }
      }
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
      await landingRepository.deleteUserProfile();
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
      // if () {
      //   _showErrorDialog('Google sign in canceled');
      //   return;
      // }
      final GoogleSignInAuthentication gAuth = gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        UserModel userModel;

        final userDoc = await _firestoreService.getUserByEmail(user.email!);
        if (userDoc != null && userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          userModel = UserModel.fromMap(data, userDoc.id);
        } else {
          userModel = UserModel(
            username: user.displayName ?? '',
            email: user.email!,
          );
          await _firestoreService.addUser(userModel.toMap());
        }
        NoteRepository().deleteAllNotes();
        TaskRepository().deleteAllTasks();
        await landingRepository.saveUserProfile(userModel);
      }

      Get.offAllNamed(Routes.homeRoute);
    } catch (e) {
      _showErrorDialog('Google sign in failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleAuthenticationEvent(
      GoogleSignInAuthenticationEvent event) async {
    try {
      const List<String> scopes = <String>[
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
        // 'https://www.googleapis.com/auth/contacts.readonly',
        // 'https://www.googleapis.com/auth/drive.file',
        // 'https://www.googleapis.com/auth/calendar',
        // 'https://www.googleapis.com/auth/drive.photos.readonly',
        // 'https://www.googleapis.com/auth/drive.metadata.readonly',
        // 'https://www.googleapis.com/auth/drive.appdata',
        // 'https://www.googleapis.com/auth/drive',
        // 'https://www.googleapis.com/auth/drive.photos',
        // 'https://www.googleapis.com/auth/drive.scripts',
        // 'https://www.googleapis.com/auth/drive.readonly',
      ];
      final GoogleSignInAccount? user = switch (event) {
        GoogleSignInAuthenticationEventSignIn() => event.user,
        GoogleSignInAuthenticationEventSignOut() => null,
      };

      final GoogleSignInClientAuthorization? authorization =
          await user?.authorizationClient.authorizationForScopes(scopes);

      currentUser = user;
      isAuthorized = authorization != null;
      errorMessage = '';
    } catch (e) {
      await _handleAuthenticationError(e);
      _showErrorDialog(errorMessage);
    }
  }

  Future<void> _handleAuthenticationError(Object e) async {
    currentUser = null;
    isAuthorized = false;
    errorMessage = e is GoogleSignInException
        ? _errorMessageFromSignInException(e)
        : 'Unknown error: $e';
  }

  String _errorMessageFromSignInException(GoogleSignInException e) {
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Sign in canceled',
      _ => 'GoogleSignInException ${e.code}: ${e.description}',
    };
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

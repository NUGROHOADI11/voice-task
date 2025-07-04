import 'dart:developer';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final RxInt currentIndex = 0.obs;

  var isNavBarVisible = true.obs;
  Timer? _inactivityTimer;
  final Duration _inactivityTimeout = const Duration(seconds: 3);

  late stt.SpeechToText _speech;
  final RxBool isListening = false.obs;
  final RxBool isLoadingAI = false.obs;
  final RxString recognizedWords = ''.obs;
  final RxString sttStatus = 'Not Listening'.obs;
  final RxBool speechEnabled = false.obs;

  final model = FirebaseAI.googleAI(auth: FirebaseAuth.instance)
      .generativeModel(model: 'gemini-2.0-flash');

  void changePage(int index) {
    currentIndex.value = index;
    activityDetected();
  }

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null && Get.arguments is int) {
      final int initialIndex = Get.arguments;

      if (initialIndex >= 0 && initialIndex < 4) {
        currentIndex.value = initialIndex;
      }
    }

    activityDetected();
    _initSpeech();
  }

  void _initSpeech() async {
    _speech = stt.SpeechToText();
    final bool available = await _speech.initialize(
      onStatus: (val) {
        log('onStatus: $val from HomeController');
        sttStatus.value = val;
        if (val == 'notListening' || val == 'done') {
          isListening.value = false;
        } else if (val == 'listening') {
          isListening.value = true;
        }
      },
      onError: (val) {
        log('onError: $val from HomeController');
        sttStatus.value = 'Error: ${val.errorMsg}';
        isListening.value = false;
        speechEnabled.value = false;
      },
      debugLogging: true,
    );
    speechEnabled.value = available;
    if (available) {
      sttStatus.value = "Tap the microphone to speak".tr;
    } else {
      sttStatus.value =
          "Speech recognition not available or permissions denied.";
    }
  }

  void startListening() async {
    if (!speechEnabled.value) {
      log("Speech not enabled. Cannot start listening.");
      return;
    }
    if (_speech.isListening) {
      log("Attempted to start listening, but STT engine is already active.");
      return;
    }

    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        recognizedWords.value = result.recognizedWords;
        activityDetected();
        if (result.finalResult) {
          log("Final recognized words: ${result.recognizedWords}");
          firebaseAiPrompt(result.recognizedWords);
        }
      },
      localeId: 'en_US',
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 5),
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
        cancelOnError: true,
      ),
    );
    isListening.value = true;
    sttStatus.value = 'Listening...'.tr;
  }

  void stopListening() async {
    log("stopListening called from HomeController");
    if (_speech.isListening) {
      await _speech.stop();
    }

    isListening.value = false;
    sttStatus.value = 'Tap the microphone to speak'.tr;
  }

  void activityDetected() {
    if (!isNavBarVisible.value) {
      isNavBarVisible.value = true;
    }
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_inactivityTimeout, () {
      if (isNavBarVisible.value) {
        isNavBarVisible.value = false;
      }
    });
  }

  void toggleMicAndDetectActivity() {
    if (!speechEnabled.value) {
      sttStatus.value =
          "Speech recognition not available or permissions denied.";
      _initSpeech();
      return;
    }

    if (isListening.value) {
      stopListening();
    } else {
      startListening();
    }

    activityDetected();
  }

  Future<void> firebaseAiPrompt(String promptInput) async {
    try {
      isLoadingAI.value = true;

      final prompt = [
        Content.text("""
        You are a navigation assistant for a mobile application. Your job is to analyze the text from the user and determine which page they want to go to. Respond ONLY with one of the following route names:
        - '/task_add_task'
        - '/note_add_note'
        If the user text does not match any of the above destinations, respond with 'unknown'. Do not provide any explanation or additional words.
        User Text: "$promptInput"
        """)
      ];

      final response = await model.generateContent(prompt);

      final String? routeName = response.text?.trim();

      if (routeName == null || routeName.isEmpty) {
        log('Response from AI is null or empty for input: $promptInput');
        sttStatus.value = 'I did not understand. Please try again.';
      } else if (routeName.toLowerCase() == 'unknown') {
        log('No matching route found for input: $promptInput');
        sttStatus.value = 'Command not recognized.';
      } else {
        Navigator.pop(Get.context!);
        isListening.value = false;
        recognizedWords.value = '';
        // if (routeName == 'profile') {
        //   changePage(3);
        // } else if (routeName == 'task_view') {
        //   changePage(2);
        // } else if (routeName == 'note_view') {
        //   changePage(1);
        // } else {
        // }
          Get.toNamed(routeName); 
      }
      sttStatus.value = 'Navigating to: $routeName';
    } catch (e) {
      log('Error generating content: $e');
      log('Prompt input was: $promptInput');
      sttStatus.value = 'Error: ${e.toString()}';
    } finally {
      isLoadingAI.value = false;
    }
  }

  @override
  void onClose() {
    _inactivityTimer?.cancel();
    _speech.stop();
    super.onClose();
  }
}

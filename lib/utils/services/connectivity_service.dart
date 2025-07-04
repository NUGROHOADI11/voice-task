// import 'dart:async';
// import 'dart:developer';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:isar/isar.dart';
// import 'package:voice_task/features/note/sub_features/add_note/models/isar_note.dart';
// import 'package:voice_task/utils/services/firestore_service.dart';

// class ConnectivityService extends GetxService {
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

//   final RxBool isConnected = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     initConnectivity();
//     _connectivitySubscription =
//         _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }

//   Future<void> initConnectivity() async {
//     late List<ConnectivityResult> result;
//     try {
//       result = await _connectivity.checkConnectivity();
//     } on PlatformException catch (e) {
//       log('Couldn\'t check connectivity status: $e');
//       return;
//     }
//     return _updateConnectionStatus(result);
//   }

//   void _updateConnectionStatus(List<ConnectivityResult> result) {
//     final wasConnected = isConnected.value;
//     isConnected.value = !result.contains(ConnectivityResult.none);

//     if (!wasConnected && isConnected.value) {
//       syncPendingNotes(); // Trigger sync when regaining connection
//     }
//   }

//   Future<void> syncPendingNotes() async {
//     final isar = Isar.getInstance();
//     final notesToSync = await isar!.isarNotes.filter()
//         .pendingSyncEqualTo(true)
//         .findAll();

//     for (final note in notesToSync) {
//       try {
//         final noteMap = {
//           "title": note.title,
//           "content": note.content,
//           "createdAt": note.createdAt.toIso8601String(),
//           "updatedAt": note.updatedAt?.toIso8601String(),
//         };

//         await FirestoreService().addNote(noteMap);

//         await isar.writeTxn(() async {
//           note.pendingSync = false;
//           await isar.isarNotes.put(note);
//         });
//       } catch (e) {
//         log('Failed to sync note ${note.id}: $e');
//         Get.snackbar("Sync Error", "Failed to sync note: ${note.title}",
//             snackPosition: SnackPosition.BOTTOM);
//       }
//     }
//   }

//   @override
//   void onClose() {
//     _connectivitySubscription.cancel();
//     super.onClose();
//   }
// }

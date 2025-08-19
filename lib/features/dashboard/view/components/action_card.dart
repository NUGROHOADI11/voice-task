import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:voice_task/features/profile/controllers/profile_controller.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/controllers/global_controller.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../note/repositories/note_repository.dart';
import '../../../task/repositories/task_repository.dart';

Widget buildActionCard(context) {
  return Obx(() {
    final isOnline = GlobalController.to.isConnected.value;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircleIcon(
            Icons.notifications_outlined,
            () => Get.toNamed(Routes.notificationRoute),
            showBadge: true,
          ),
          _buildCircleIcon(
            isOnline ? Icons.cloud_upload_outlined : Icons.cloud_off_outlined,
            () async {
              try {
                if (GlobalController.to.isConnected.value) {
                  Get.defaultDialog(
                    title: 'Confirm Sync'.tr,
                    middleText:
                        'Are you sure you want to sync all your tasks and notes to the cloud?'
                            .tr,
                    textConfirm: 'Sync'.tr,
                    textCancel: 'Cancel'.tr,
                    confirmTextColor: Colors.white,
                    buttonColor: ColorStyle.secondary,
                    onConfirm: () async {
                      await TaskRepository().syncTasksToFirebase();
                      await NoteRepository().syncNotesToFirebase();
                      Get.back();
                      Get.snackbar(
                        'Sync Success'.tr,
                        'All tasks and notes synced to cloud successfully.'.tr,
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                  );
                } else {
                  Get.snackbar(
                    'No Internet Connection'.tr,
                    'Please check your internet connection and try again.'.tr,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                Get.snackbar(
                  'Sync Failed'.tr,
                  'Failed to sync tasks: ${e.toString()}'.tr,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
          ),
          _buildCircleIcon(
              Icons.visibility_off, () => _authenticateUser(context)),
        ],
      ),
    );
  });
}

Widget _buildCircleIcon(IconData iconData, Callback onTap,
    {bool showBadge = false}) {
  final icon = Icon(iconData, color: ColorStyle.white);

  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: ColorStyle.dark,
        shape: BoxShape.circle,
      ),
      child: showBadge
          ? badges.Badge(
              position: badges.BadgePosition.topEnd(top: -2, end: -2),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: ColorStyle.warning,
                padding: EdgeInsets.all(4),
                shape: badges.BadgeShape.circle,
                elevation: 0,
              ),
              child: icon,
            )
          : icon,
    ),
  );
}

Future<void> _authenticateUser(BuildContext context) async {
  final localAuth = LocalAuthentication();
  final hasPin = ProfileController.to.pin.value.isNotEmpty;

  bool biometricsAvailable = false;

  try {
    final isDeviceSupported = await localAuth.isDeviceSupported();
    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    final enrolled = await localAuth.getAvailableBiometrics();
    biometricsAvailable =
        isDeviceSupported && canCheckBiometrics && enrolled.isNotEmpty;
  } catch (e) {
    biometricsAvailable = false;
    log("Biometric capability check failed: $e");
  }
  if (!context.mounted) return;

  if (!biometricsAvailable) {
    if (hasPin) {
      _showPinVerificationDialog(context);
    } else {
      _showSetPinFirstDialog(context);
    }
    return;
  }

  try {
    final didAuthenticate = await localAuth.authenticate(
      localizedReason: 'Authenticate to view hidden tasks'.tr,
      options: const AuthenticationOptions(
        biometricOnly: true,
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );

    if (didAuthenticate) {
      Get.toNamed(Routes.hiddenRoute);
      return;
    }

    if (!context.mounted) return;

    if (biometricsAvailable) {
      _showVerificationModal(context);
    } else {
      if (hasPin) {
        _showPinVerificationDialog(context);
      } else {
        _showSetPinFirstDialog(context);
      }
    }
  } catch (e) {
    if (!context.mounted) return;
    log("Authentication error: $e");

    if (hasPin) {
      _showPinVerificationDialog(context);
    } else {
      _showSetPinFirstDialog(context);
    }
  }
}

void _showSetPinFirstDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "PIN Required".tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              "Please set your PIN first to access hidden tasks in the Profile page."
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK".tr,
                style: TextStyle(
                  color: ColorStyle.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showVerificationModal(BuildContext context) {
  final hasPin = ProfileController.to.pin.value.isNotEmpty;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Verification Required".tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(
              "Fingerprint".tr,
              style: TextStyle(color: Colors.grey, fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _authenticateUser(context);
              },
              child: Icon(Icons.fingerprint,
                  size: 100.w, color: ColorStyle.primary),
            ),
            SizedBox(height: 16.h),
            if (hasPin) ...[
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text("or".tr,
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showPinVerificationDialog(context);
                },
                child: Text(
                  "Verification Using PIN".tr,
                  style: TextStyle(
                    color: ColorStyle.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ] else ...[
              SizedBox(height: 8.h),
              Text(
                "PIN not set. Please set your PIN first in the Profile page."
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

void _showPinVerificationDialog(BuildContext context) {
  bool obscure = true;
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Verification Required".tr,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Input PIN Code".tr,
                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pinput(
                        length: 6,
                        obscureText: obscure,
                        controller: pinController,
                        focusNode: focusNode,
                        defaultPinTheme: PinTheme(
                          width: 34.w,
                          height: 34.w,
                          textStyle: TextStyle(fontSize: 20.sp),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorStyle.primary),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onCompleted: (pin) async {
                          if (pin == ProfileController.to.pin.value) {
                            Navigator.pop(context);
                            Get.toNamed(Routes.hiddenRoute);
                          } else {
                            if (context.mounted) {
                              Get.snackbar(
                                "Error".tr,
                                "Wrong PIN code".tr,
                                snackPosition: SnackPosition.TOP,
                              );
                            }
                          }
                        }),
                    IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                        size: 24.w,
                      ),
                      onPressed: () => setState(() => obscure = !obscure),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

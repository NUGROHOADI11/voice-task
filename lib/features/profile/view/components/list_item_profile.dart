import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_datepicker.dart';
import '../../../../shared/widgets/inapp_webview.dart';
import '../../../../utils/services/firestore_service.dart';
import '../../controllers/profile_controller.dart';
import 'bottom_sheet.dart';
import 'language_option.dart';
import 'profile_item.dart';

List<Widget> buildListItem(context) {
  final ProfileController controller = ProfileController.to;

  return [
    Obx(() {
      final emailText = controller.currentUser.value?.email;
      return buildProfileItem(
        icon: Icons.email_outlined,
        title: 'Email'.tr,
        subtitle: (emailText != null && emailText.isNotEmpty)
            ? emailText
            : 'No email available'.tr,
        onTap: () {
          customBottomSheet(
            title: "Edit Email",
            initialValue: controller.email.text,
            hintText: "Enter your email",
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Email cannot be empty";
              }
              if (!GetUtils.isEmail(value.trim())) {
                return "Invalid email format";
              }
              return null;
            },
            onSave: (value) {
              controller.email.text = value;
              controller.updateEmail();
            },
          );
        },
      );
    }),
    Obx(() {
      final phoneText = controller.currentUser.value?.phoneNumber;
      return buildProfileItem(
        icon: Icons.phone_android_outlined,
        title: 'Phone'.tr,
        subtitle: (phoneText != null && phoneText.isNotEmpty)
            ? phoneText
            : 'No phone number available'.tr,
        onTap: () {
          customBottomSheet(
            title: "Edit Phone Number",
            initialValue: controller.phone.text,
            hintText: "Enter your phone number",
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Phone number cannot be empty";
              }
              if (!RegExp(r'^\d{10,15}$').hasMatch(value.trim())) {
                return "Enter a valid phone number (10–15 digits)";
              }
              return null;
            },
            onSave: (value) {
              controller.phone.text = value;
              controller.updatePhone();
            },
          );
        },
      );
    }),
    Obx(() => buildProfileItem(
          icon: Icons.calendar_month_outlined,
          title: 'Birthday'.tr,
          subtitle: controller.birthDate.value.isNotEmpty
              ? controller.birthDate.value
              : 'No birthday available'.tr,
          onTap: () async {
            final birthday = await buildDatePicker(
                context: context,
                initialDate: controller.birthDate.value.isNotEmpty
                    ? DateFormat('MMMM d, yyyy')
                        .parse(controller.birthDate.value)
                    : DateTime.now(),
                maxDate: DateTime.now());

            if (birthday != null) {
              controller.birthDate.value =
                  DateFormat('MMMM d, yyyy').format(birthday);

              FirestoreService()
                  .updateUser(controller.userId.value, {
                    'birthDate': controller.birthDate.value,
                  })
                  .then(
                    (value) => Get.snackbar(
                      'Success',
                      'Birthday updated successfully'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                    ),
                  )
                  .catchError(
                    (error) => Get.snackbar(
                      'Error',
                      'Failed to update birthday: $error',
                      snackPosition: SnackPosition.BOTTOM,
                    ),
                  );
            }
          },
        )),
    Obx(
      () => buildProfileItem(
        icon: Icons.password_outlined,
        title: controller.pin.value.isEmpty ? 'Set Pin'.tr : 'Change Pin'.tr,
        subtitle: controller.pin.value.isNotEmpty ? "******" : 'No pin set'.tr,
        onTap: () {
          _showPinBottomSheet(context);
        },
      ),
    ),
    buildProfileItem(
      icon: Icons.language_outlined,
      title: 'Language'.tr,
      subtitle: ProfileController.to.selectedLanguage.value == 'id'
          ? 'Bahasa Indonesia'.tr
          : 'English'.tr,
      onTap: () {
        _showLanguageBottomSheet(context);
      },
    ),
    buildProfileItem(
      icon: Icons.help_outline,
      title: 'Help & Support'.tr,
      subtitle: 'Help center, contact us & privacy policy'.tr,
      showDivider: false,
      onTap: () {
        _launchHelpUrl();
      },
    ),
  ];
}

Future<void> _launchHelpUrl() async {
  final Uri helpAndSupportUrl =
      Uri.parse('https://www.google.com/policies/privacy/');

  try {
    Get.to(() => InAppWebViewScreen(
        url: helpAndSupportUrl.toString(), title: 'Help & Support'.tr));
  } catch (e) {
    Get.snackbar(
      'Error',
      'Could not open the page. Please try again later.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

void _showLanguageBottomSheet(BuildContext context) {
  final controller = ProfileController.to;

  showModalBottomSheet(
    backgroundColor: Colors.white,
    showDragHandle: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Change Language".tr,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeLanguage('id'),
                      child: languageOption(
                        "Indonesia".tr,
                        "🇮🇩",
                        isSelected: controller.selectedLanguage.value == 'id',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeLanguage('en'),
                      child: languageOption(
                        "English".tr,
                        "🇬🇧",
                        isSelected: controller.selectedLanguage.value == 'en',
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

void _showPinBottomSheet(BuildContext context) {
  final controller = ProfileController.to;
  final oldPinController = TextEditingController();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();

  int currentStep = controller.pin.value.isEmpty ? 1 : 0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void proceedToNextStep() {
            setState(() {
              if (currentStep < 2) {
                currentStep++;
              } else {
                if (newPinController.text == confirmPinController.text) {
                  controller.updatePin(
                      oldPinController.text, newPinController.text);
                  Get.back();
                } else {
                  Get.snackbar(
                    'Error',
                    'New PIN and Confirm PIN do not match'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                  );

                  setState(() {
                    newPinController.clear();
                    confirmPinController.clear();
                    currentStep = 1;
                  });
                }
              }
            });
          }

          TextEditingController getCurrentController() {
            if (currentStep == 0) return oldPinController;
            if (currentStep == 1) return newPinController;
            return confirmPinController;
          }

          String getTitle() {
            if (currentStep == 0) return 'Enter Old PIN'.tr;
            if (currentStep == 1) return 'Enter New PIN'.tr;
            return 'Confirm New PIN'.tr;
          }

          void handleCompletion(String pin) async {
            if (currentStep == 0) {
              final isValid = await controller.verifyOldPin(pin);
              if (isValid) {
                proceedToNextStep();
              } else {
                Get.snackbar(
                  'Error',
                  'Old PIN is incorrect'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                );
                oldPinController.clear();
              }
            } else {
              proceedToNextStep();
            }
          }

          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  getTitle(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Obx(
                      () => Pinput(
                        length: 6,
                        controller: getCurrentController(),
                        obscureText: !controller.isPinVisible.value,
                        keyboardType: TextInputType.number,
                        onCompleted: handleCompletion,
                        defaultPinTheme: PinTheme(
                          width: 45,
                          height: 45,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorStyle.primary),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: ColorStyle.primary, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        submittedPinTheme: PinTheme(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: ColorStyle.primary),
                            borderRadius: BorderRadius.circular(10),
                            color: ColorStyle.primary.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                    ),
                    Obx(() => IconButton(
                          onPressed: () {
                            controller.isPinVisible.toggle();
                          },
                          icon: Icon(
                            controller.isPinVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                if (currentStep == 2)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final currentPin = getCurrentController().text;
                        if (currentPin.length == 6) {
                          handleCompletion(currentPin);
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please enter a valid PIN'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorStyle.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Confirm'.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}

  import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/landing_controller.dart';

Widget buildSocialButton(
    String text,
    Color bgColor,
    Color textColor, {
    String? imageAsset,
    bool isIconWhite = false,
    VoidCallback? onPressed,
  }) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: LandingController.to.isLoading.value ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Colors.black12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageAsset != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ColorFiltered(
                      colorFilter: isIconWhite
                          ? const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            )
                          : const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.multiply,
                            ),
                      child: Image.asset(
                        imageAsset,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
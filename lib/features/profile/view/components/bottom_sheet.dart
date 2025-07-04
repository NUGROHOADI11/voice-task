import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void customBottomSheet({
  required String title,
  required String initialValue,
  required String hintText,
  required void Function(String) onSave,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  final TextEditingController controller =
      TextEditingController(text: initialValue);
  final formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    showDragHandle: true,
    context: Get.context!,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),
              TextFormField(
                controller: controller,
                maxLines: maxLines,
                keyboardType: keyboardType,
                validator: validator,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text("Cancel".tr),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          onSave(controller.text.trim());
                          Get.back();
                        }
                      },
                      child: Text("Save".tr),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      );
    },
  );
}

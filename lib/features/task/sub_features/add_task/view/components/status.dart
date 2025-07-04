import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../shared/styles/color_style.dart';
import '../../../../models/task_model.dart';
import '../../controllers/task_add_task_controller.dart';

Widget buildStatusRow() {
  return Row(
    children: [
      const Expanded(
        child: Text("Status",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
      ),
      Obx(() => Container(
            height: 40,
            decoration: BoxDecoration(
              color: ColorStyle.secondary,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: ColorStyle.black),
            ),
            child: TextButton(
              onPressed: () => _showBottomSheet<TaskStatus>(
                context: Get.context!,
                title: "Select Status",
                values: TaskStatus.values,
                selectedValue: TaskAddTaskController.to.selectedStatus.value,
                onSelected: (val) =>
                    TaskAddTaskController.to.selectedStatus.value = val,
              ),
              child: Text(
                TaskAddTaskController
                        .to.selectedStatus.value.name.capitalizeFirst ??
                    '',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          )),
    ],
  );
}

Widget buildPriorityRow() {
  return Row(
    children: [
      const Expanded(
        child: Text("Priority",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
      ),
      Obx(() => Container(
            height: 40,
            decoration: BoxDecoration(
              color: ColorStyle.accent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: ColorStyle.black),
            ),
            child: TextButton(
              onPressed: () => _showBottomSheet<TaskPriority>(
                context: Get.context!,
                title: "Select Priority",
                values: TaskPriority.values,
                selectedValue: TaskAddTaskController.to.selectedPriority.value,
                onSelected: (val) =>
                    TaskAddTaskController.to.selectedPriority.value = val,
              ),
              child: Text(
                TaskAddTaskController
                        .to.selectedPriority.value.name.capitalizeFirst ??
                    '',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          )),
    ],
  );
}

void _showBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> values,
  required T selectedValue,
  required Function(T) onSelected,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final itemCount = values.length;
  final totalSeparatorWidth = (itemCount - 1) * 10;
  final itemWidth = (screenWidth - 24 - totalSeparatorWidth) / itemCount;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        height: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: 40,
                  height: 5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, index) {
                  final value = values[index];
                  final isSelected = value == selectedValue;
                  return GestureDetector(
                    onTap: () {
                      onSelected(value);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: itemWidth,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? ColorStyle.primary : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isSelected
                                ? ColorStyle.primary
                                : Colors.transparent),
                      ),
                      child: Center(
                        child: Text(
                          value.toString().split('.').last.capitalizeFirst ??
                              '',
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../task/models/task_model.dart';
import '../../controllers/detail_task_controller.dart';

Widget buildStatusRow(Task task) {
  final controller = DetailTaskController.to;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Expanded(
          child: Text("Status".tr,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
        ),
        Obx(() {
          final status = controller.status.value;
          final statusColor = _getStatusColor(status);

          return GestureDetector(
            onTap: () {
              _showBottomSheet<TaskStatus>(
                context: Get.context!,
                title: "Select Status",
                values: TaskStatus.values,
                selectedValue: status,
                onSelected: (value) => controller.status.value = value,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ColorStyle.black),
              ),
              child: Text(
                status.name.capitalize!,
                style: const TextStyle(
                  color: ColorStyle.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ],
    ),
  );
}

Widget buildPriorityRow(Task task) {
  final controller = DetailTaskController.to;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Expanded(
          child: Text("Priority".tr,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
        ),
        Obx(() {
          final priority = controller.priority.value;
          final priorityColor = _getPriorityColor(priority);

          return GestureDetector(
            onTap: () {
              _showBottomSheet<TaskPriority>(
                context: Get.context!,
                title: "Select Priority",
                values: TaskPriority.values,
                selectedValue: priority,
                onSelected: (value) => controller.priority.value = value,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ColorStyle.black),
              ),
              child: Text(
                priority.name.capitalize!,
                style: const TextStyle(
                  color: ColorStyle.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ],
    ),
  );
}

Color _getStatusColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.pending:
      return ColorStyle.grey;
    case TaskStatus.inProgress:
      return ColorStyle.info;
    case TaskStatus.completed:
      return ColorStyle.success;
    case TaskStatus.onHold:
      return ColorStyle.primary;
    case TaskStatus.outDate:
      return ColorStyle.danger;
  }
}

Color _getPriorityColor(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.low:
      return ColorStyle.accent;
    case TaskPriority.medium:
      return ColorStyle.secondary;
    case TaskPriority.high:
      return ColorStyle.primary;
  }
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_task/utils/extensions/date_formatter.dart';

import '../../../../shared/styles/color_style.dart';
import '../../../task/models/task_model.dart';
import '../../controllers/detail_task_controller.dart';

Widget buildDateRow(Task task) {
  final controller = DetailTaskController.to;

  return Row(
    children: [
      Expanded(
        child: Obx(() => _buildDateDisplayBox(
              label: "Start Date".tr,
              value: controller.startDate.value?.toFormattedString() ?? "Not Set".tr,
              iconData: Icons.calendar_today_outlined,
              onTap: () => controller.pickStartDate(Get.context!),
            )),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Obx(() => _buildDateDisplayBox(
              label: "Due Date".tr,
              value: controller.dueDate.value?.toFormattedString() ?? "Not Set".tr,
              iconData: Icons.event_available_outlined,
              onTap: () => controller.pickDueDate(Get.context!),
            )),
      ),
    ],
  );
}

Widget _buildDateDisplayBox({
  required String label,
  required String value,
  required IconData iconData,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(iconData, color: ColorStyle.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

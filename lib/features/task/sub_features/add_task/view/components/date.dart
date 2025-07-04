import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../shared/styles/color_style.dart';
import '../../controllers/task_add_task_controller.dart';

Widget buildDateRow(BuildContext context) {
  return Row(
    children: [
      Expanded(
          child: _buildDateBox("Start Date", TaskAddTaskController.to.startDate,
              () => TaskAddTaskController.to.pickStartDate(context))),
      const SizedBox(width: 10),
      Expanded(
          child: _buildDateBox("Due Date", TaskAddTaskController.to.dueDate,
              () => TaskAddTaskController.to.pickDueDate(context))),
    ],
  );
}

Widget _buildDateBox(String label, RxString value, VoidCallback onTap) {
  return Obx(() => GestureDetector(
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
              Text(label),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.edit_calendar_outlined,
                      color: ColorStyle.danger),
                  const SizedBox(width: 8),
                  Text(
                    value.value.isEmpty ? 'Select date' : value.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
}

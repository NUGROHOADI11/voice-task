import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../task/models/task_model.dart';
import '../../controllers/detail_task_controller.dart';

Widget buildDescriptionSection(Task task) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Description".tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextFormField(
          controller: DetailTaskController.to.descriptionController,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'No Description Yet'.tr,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
        ),
      ],
    ),
  );
}

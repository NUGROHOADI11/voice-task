import 'package:flutter/material.dart';
import 'package:voice_task/features/task/sub_features/add_task/controllers/task_add_task_controller.dart';

Widget buildDescriptionCard() {
  return TextFormField(
    controller: TaskAddTaskController.to.descriptionController,
    validator: (value) =>
        value == null || value.isEmpty ? 'Description is required' : null,
    decoration: InputDecoration(
      hintText: 'Enter description *',
      fillColor: Colors.grey[100],
      filled: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    ),
  );
}

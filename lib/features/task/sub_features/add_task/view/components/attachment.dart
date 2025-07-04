import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/task_add_task_controller.dart';

Widget buildAttachment() {
  return Column(
    children: [
      GestureDetector(
        onTap: TaskAddTaskController.to.pickAttachment,
        child: const Row(
          children: [
            Expanded(
              child: Text("Attachment",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
            ),
            Icon(Icons.add_rounded),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Obx(
        () => TaskAddTaskController.to.attachment.value == null
            ? Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text("No Attachment Yet",
                      style: TextStyle(color: Colors.grey)),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.attach_file),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        TaskAddTaskController.to.attachment.value!.path
                            .split('/')
                            .last,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: TaskAddTaskController.to.removeAttachment,
                    ),
                  ],
                ),
              ),
      ),
    ],
  );
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/widgets/pdf_viewer.dart';
import '../../../task/models/task_model.dart';

Widget buildAttachmentSection(Task task) {
  final hasAttachment =
      task.attachmentUrl != null && task.attachmentUrl!.isNotEmpty;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text("Attachments".tr,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
          ),
        ],
      ),
      const SizedBox(height: 8),
      if (hasAttachment)
        InkWell(
          onTap: () {
            Get.to(() => PdfViewerScreen(filePath: task.attachmentUrl!));
            log("Opening attachment: ${task.attachmentUrl}");
          },
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _extractFileName(task.attachmentUrl!),
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        )
      else
        const Text('No attachment', style: TextStyle(color: Colors.grey)),

    ],
  );
}

String _extractFileName(String url) {
  final uri = Uri.parse(url);
  final rawFileName =
      uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'Attachment';
  return Uri.decodeComponent(rawFileName);
}

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../shared/controllers/global_controller.dart';
import '../../../../../shared/widgets/custom_datepicker.dart';
import '../../../../../utils/services/firestore_service.dart';
import '../../../../offline/controllers/offline_controller.dart';
import '../../../models/task_model.dart';
import '../../../repositories/task_repository.dart';

class TaskAddTaskController extends GetxController {
  static TaskAddTaskController get to => Get.find();

  final isOnline = GlobalController.to.isConnected.value;

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> dueDate = Rx<DateTime?>(null);

  final selectedStatus = TaskStatus.pending.obs;
  final selectedPriority = TaskPriority.medium.obs;
  final isPin = false.obs;
  final isHidden = false.obs;

  final Rx<File?> attachment = Rx<File?>(null);
  String? uploadedAttachmentUrl;

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<void> pickStartDate(BuildContext context) async {
    final pickedDate = await buildDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
    );

    if (pickedDate != null) {
      startDate.value = pickedDate;
      if (dueDate.value != null && pickedDate.isAfter(dueDate.value!)) {
        dueDate.value = null;
      }
    }
  }

  Future<void> pickDueDate(BuildContext context) async {
    final pickedDate = await buildDatePicker(
      context: context,
      initialDate: dueDate.value ?? startDate.value ?? DateTime.now(),
      minDate: startDate.value,
    );

    if (pickedDate != null) {
      dueDate.value = pickedDate;
    }
  }

  Future<void> pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;

        final fileSizeKB = file.size / 1024;
        if (fileSizeKB > 5120) {
          Get.snackbar(
            'File too large',
            'Max file size is 5MB',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }

        attachment.value = File(file.path!);
      }
    } catch (e) {
      log('Error picking file: $e', error: e);
      Get.snackbar('Error', 'Failed to pick file: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void removeAttachment() {
    attachment.value = null;
    uploadedAttachmentUrl = null;
  }

  void resetForm() {
    titleController.clear();
    subtitleController.clear();
    descriptionController.clear();
    startDate.value = null;
    dueDate.value = null;
    selectedStatus.value = TaskStatus.pending;
    selectedPriority.value = TaskPriority.medium;
    isPin.value = false;
    isHidden.value = false;
    attachment.value = null;
    uploadedAttachmentUrl = null;
  }

  Future<void> submitTask() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    uploadedAttachmentUrl = null;

    try {
      if (attachment.value != null) {
        final file = attachment.value!;
        final fileName = file.path.split('/').last;
        final fileBytes = await file.readAsBytes();

        final storageResponse = await Supabase.instance.client.storage
            .from(dotenv.env['SUPABASE_BUCKET_NAME']!)
            .uploadBinary(
              'attachments_task/$fileName',
              fileBytes,
              fileOptions: const FileOptions(upsert: true),
            );
        log('Storage response: $storageResponse');

        uploadedAttachmentUrl = Supabase.instance.client.storage
            .from(dotenv.env['SUPABASE_BUCKET_NAME']!)
            .getPublicUrl('attachments_task/$fileName');
      }

      final task = Task(
        title: titleController.text.trim(),
        subtitle: subtitleController.text.trim().isEmpty
            ? null
            : subtitleController.text.trim(),
        description: descriptionController.text.trim(),
        status: selectedStatus.value,
        startDate: startDate.value,
        dueDate: dueDate.value,
        priority: selectedPriority.value,
        isPin: isPin.value,
        isHidden: isHidden.value,
        attachmentUrl: uploadedAttachmentUrl,
      );

      if (isOnline) {
        await FirestoreService().addTask(task.toMap());
        log('Submitting task to Firestore: ${task.toMap()}');
      } else {
        TaskRepository().addTask(task);
        OfflineController.to.refreshTasks();
        log('Saving task offline: ${task.toMap()}');
      }

      resetForm();
      Get.back();
      Get.snackbar('Success', 'Task successfully added');
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit task: $e');
      log('Error submitting task: $e', error: e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    subtitleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}

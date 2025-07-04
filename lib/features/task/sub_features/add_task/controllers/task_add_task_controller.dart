import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../shared/widgets/custom_datepicker.dart';
import '../../../../../utils/services/firestore_service.dart';
import '../../../models/task_model.dart';

class TaskAddTaskController extends GetxController {
  static TaskAddTaskController get to => Get.find();

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxString startDate = ''.obs;
  final RxString dueDate = ''.obs;

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
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      startDate.value = _formatDate(pickedDate);

      if (dueDate.value.isNotEmpty) {
        final due = DateTime.tryParse(dueDate.value);
        if (due != null && pickedDate.isAfter(due)) {
          dueDate.value = '';
        }
      }
    }
  }

  Future<void> pickDueDate(BuildContext context) async {
    DateTime initial = DateTime.now();

    if (startDate.value.isNotEmpty) {
      final start = DateTime.tryParse(startDate.value);
      if (start != null && initial.isBefore(start)) {
        initial = start;
      }
    }

    final pickedDate = await buildDatePicker(
      context: context,
      initialDate: initial,
      minDate: startDate.value.isNotEmpty
          ? DateTime.tryParse(startDate.value)
          : DateTime(2000),
    );

    if (pickedDate != null) {
      final start = DateTime.tryParse(startDate.value);
      if (start != null && pickedDate.isBefore(start)) {
        Get.snackbar('Invalid Date', 'Due date cannot be before start date.');
        return;
      }
      dueDate.value = _formatDate(pickedDate);
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

  String _formatDate(DateTime date) => date.toIso8601String().split('T').first;

  void resetForm() {
    titleController.clear();
    subtitleController.clear();
    descriptionController.clear();
    startDate.value = '';
    dueDate.value = '';
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
        startDate: startDate.value.isEmpty ? null : startDate.value,
        dueDate: dueDate.value.isEmpty ? null : dueDate.value,
        priority: selectedPriority.value,
        isPin: isPin.value,
        isHidden: isHidden.value,
        attachmentUrl: uploadedAttachmentUrl,
      );

      await FirestoreService().addTask(task.toMap());

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

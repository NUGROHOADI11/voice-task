import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:voice_task/features/task/controllers/task_controller.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_appbar.dart';

import '../../controllers/detail_task_controller.dart';
import '../components/attachment.dart';
import '../components/date.dart';
import '../components/description.dart';
import '../components/status.dart';
import '../components/title.dart';

extension StringExtension on String {
  String? get capitalizeFirst {
    if (isEmpty) return this;

    if (length == 1) return toUpperCase();
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

class DetailTaskScreen extends StatelessWidget {
  DetailTaskScreen({super.key});

  final controller = Get.put(DetailTaskController());

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};
    final String taskId = arguments['taskId'] ?? "";
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: Text("Detail Task".tr),
          action: Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: ColorStyle.black),
                ),
              );
            }
            if (controller.task.value == null) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.delete_outline, color: ColorStyle.black),
              onPressed: () {
                TaskController.to.deleteTask(taskId);
              },
            );
          }),
          action2: Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: ColorStyle.black),
                ),
              );
            }
            if (controller.task.value == null) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.check, color: ColorStyle.black),
              onPressed: () {
                DetailTaskController.to.updateTask();
              },
            );
          }),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.task.value == null) {
            return Center(
              child: Text(
                "Task not found or failed to load.".tr,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final task = controller.task.value!;
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitleSection(task),
                const SizedBox(height: 10),
                buildDescriptionSection(task),
                const SizedBox(height: 10),
                buildDateRow(task),
                const Divider(),
                buildStatusRow(task),
                buildPriorityRow(task),
                const Divider(),
                buildAttachmentSection(task),
              ],
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {},
            child: Obx(
              () => SpeedDial(
                elevation: 0,
                backgroundColor: controller.selectedColor.value != null
                    ? Color(controller.selectedColor.value!)
                    : ColorStyle.grey,
                direction: SpeedDialDirection.left,
                icon: Icons.color_lens_outlined,
                foregroundColor: Colors.white,
                spaceBetweenChildren: 10,
                overlayOpacity: 0,
                children: [
                  SpeedDialChild(
                    child: const Icon(Icons.invert_colors_on),
                    backgroundColor: ColorStyle.primary,
                    elevation: 0,
                    onTap: () {
                      controller.selectedColor.value =
                          ColorStyle.primary.toARGB32();
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.invert_colors_on),
                    backgroundColor: ColorStyle.secondary,
                    elevation: 0,
                    onTap: () {
                      controller.selectedColor.value =
                          ColorStyle.secondary.toARGB32();
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.invert_colors_on),
                    backgroundColor: ColorStyle.accent,
                    elevation: 0,
                    onTap: () {
                      controller.selectedColor.value =
                          ColorStyle.accent.toARGB32();
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.invert_colors_on),
                    backgroundColor: ColorStyle.grey,
                    elevation: 0,
                    onTap: () {
                      controller.selectedColor.value =
                          ColorStyle.grey.toARGB32();
                    },
                  ),
                ],
              ),
            )));
  }
}

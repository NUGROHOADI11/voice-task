import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../shared/styles/color_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../constants/task_assets_constant.dart';
import '../../controllers/task_add_task_controller.dart';
import '../components/attachment.dart';
import '../components/date.dart';
import '../components/description.dart';
import '../components/status.dart';
import '../components/title.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final controller = TaskAddTaskController.to;
  final assetsConstant = TaskAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: const Text("Add task"),
        action: Obx(() => controller.isLoading.value
            ? const Padding(
                padding: EdgeInsets.only(right: 12),
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : IconButton(
                onPressed: controller.submitTask,
                icon: const Icon(Icons.check, color: ColorStyle.black),
              )),
      ),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              spacing: 10,
              children: [
                buildTitleTile(
                    titleController: controller.titleController,
                    subtitleController: controller.subtitleController),
                buildDescriptionCard(),
                buildDateRow(context),
                const Divider(),
                buildStatusRow(),
                buildPriorityRow(),
                const Divider(),
                buildAttachment(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

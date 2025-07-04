import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';
import '../../controllers/task_controller.dart';

Widget buildSpeedDial() {
  return SpeedDial(
    backgroundColor: ColorStyle.white,
    overlayOpacity: 0,
    elevation: 0,
    icon: Icons.more_vert,
    spaceBetweenChildren: 1,
    direction: SpeedDialDirection.down,
    foregroundColor: Colors.black,
    spacing: 10,
    children: [
      SpeedDialChild(
        child: const Icon(Icons.add),
        backgroundColor: ColorStyle.secondary,
        label: "Add data".tr,
        onTap: () {
          Get.toNamed(Routes.taskAddTaskRoute);
        },
      ),
      SpeedDialChild(
        child: const Icon(Icons.search),
        backgroundColor: ColorStyle.accent,
        label: "Search data".tr,
        onTap: TaskController.to.toggleSearch,
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_task/features/note/controllers/note_controller.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/widgets/custom_appbar.dart';

import '../../constants/note_assets_constant.dart';
import '../components/item.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});

  final controller = NoteController.to;
  final assetsConstant = NoteAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: Text('Note'.tr),
            isSearch: controller.isSearching.value ? true : false,
            onSearchChanged: controller.isSearching.value
                ? (value) => controller.searchQuery.value = value
                : null,
            action: !controller.isSearching.value
                ? IconButton(
                    onPressed: controller.toggleSearch,
                    icon: const Icon(Icons.search))
                : IconButton(
                    onPressed: () {
                      controller.toggleSearch();
                    },
                    icon: const Icon(Icons.close),
                  ),
            action2: !controller.isSearching.value
                ? IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.noteAddNoteRoute);
                    },
                    icon: const Icon(Icons.add))
                : null,
          ),
          body: buildBody(context),
        ));
  }
}

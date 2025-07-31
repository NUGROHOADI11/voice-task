import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:voice_task/features/detail_note/controllers/detail_note_controller.dart';
import 'package:voice_task/shared/widgets/custom_appbar.dart';

import '../../../../shared/styles/color_style.dart';
import '../../constants/detail_note_assets_constant.dart';

class DetailNoteScreen extends StatelessWidget {
  DetailNoteScreen({super.key});

  final assetsConstant = DetailNoteAssetsConstant();
  final controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.white,
      appBar: CustomAppBar(
        title: Text("Detail Note".tr),
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
          if (controller.note.value == null) return const SizedBox.shrink();
          return IconButton(
            icon: const Icon(Icons.check, color: ColorStyle.black),
            onPressed: () {
              controller.updateNote();
            },
          );
        }),
        action: IconButton(
          onPressed: () {
            controller.confirmDeleteNote();
          },
          icon: const Icon(Icons.delete_outline),
          color: ColorStyle.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd MMMM yyyy hh:mm a').format(controller.date),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ColorStyle.grey,
              ),
            ),
            TextFormField(
              controller: controller.titleController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Enter Title *'.tr,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: QuillEditor.basic(
                controller: controller.quillController,
                focusNode: controller.quillFocusNode,
                config: const QuillEditorConfig(),
              ),
            ),
            Obx(() {
              if (!controller.isQuillFocused.value) {
                return const SizedBox.shrink();
              }
              return Obx(() {
                if (controller.isToolbarExpanded.value) {
                  return QuillSimpleToolbar(
                    controller: controller.quillController,
                    config: QuillSimpleToolbarConfig(
                      showSearchButton: false,
                      customButtons: [
                        QuillToolbarCustomButtonOptions(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          onPressed: () => controller.toggleToolbarExpansion(),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      children: [
                        QuillSimpleToolbar(
                          controller: controller.quillController,
                          config: const QuillSimpleToolbarConfig(
                            showSearchButton: false,
                            showAlignmentButtons: false,
                            showLink: false,
                            showUndo: false,
                            showRedo: false,
                            showColorButton: false,
                            showBackgroundColorButton: false,
                            showListCheck: false,
                            showCodeBlock: false,
                            showQuote: false,
                            showIndent: false,
                            showSuperscript: false,
                            showSubscript: false,
                            showClearFormat: false,
                            showSmallButton: false,
                            showInlineCode: false,
                            showFontFamily: false,
                            showFontSize: false,
                            showLeftAlignment: false,
                            showCenterAlignment: false,
                            showRightAlignment: false,
                            showJustifyAlignment: false,
                            showStrikeThrough: false,
                            showHeaderStyle: false,
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: 'Show More',
                            onPressed: () =>
                                controller.toggleToolbarExpansion(),
                            icon: const Icon(Icons.keyboard_arrow_up, size: 20),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              });
            }),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => controller.isQuillFocused.value
            ? const SizedBox.shrink()
            : SpeedDial(
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
                    onTap: () => controller.selectedColor.value =
                        ColorStyle.primary.toARGB32(),
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.invert_colors_on),
                    backgroundColor: ColorStyle.secondary,
                    elevation: 0,
                    onTap: () => controller.selectedColor.value =
                        ColorStyle.secondary.toARGB32(),
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.invert_colors_on),
                    backgroundColor: ColorStyle.accent,
                    elevation: 0,
                    onTap: () => controller.selectedColor.value =
                        ColorStyle.accent.toARGB32(),
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.invert_colors_on),
                    backgroundColor: ColorStyle.grey,
                    elevation: 0,
                    onTap: () => controller.selectedColor.value =
                        ColorStyle.grey.toARGB32(),
                  ),
                ],
              ),
      ),
    );
  }
}

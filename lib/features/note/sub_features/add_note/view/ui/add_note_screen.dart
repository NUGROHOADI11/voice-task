import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/styles/color_style.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../constants/note_assets_constant.dart';
import '../../controllers/note_add_note_controller.dart';

class AddNoteScreen extends StatelessWidget {
  AddNoteScreen({super.key});
  final controller = Get.find<NoteAddNoteController>();
  final assetsConstant = NoteAssetsConstant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.white,
      appBar: CustomAppBar(
        title: Text("Add Note".tr),
        action: Obx(() {
          return controller.isLoading.value
              ? Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () => controller.saveNote(),
                  icon: const Icon(Icons.check),
                );
        }),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.titleController,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter Title *',
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(DateFormat('dd MMMM yyyy').format(DateTime.now())),
                const SizedBox(width: 12),
                Obx(() => Text("Character: ${controller.characterCount}")),
              ],
            ),
            SizedBox(height: 10.h),
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
    );
  }
}

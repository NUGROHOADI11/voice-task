import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../note/controllers/note_controller.dart';
import '../../../note/view/components/note_card.dart';
import '../../controllers/offline_controller.dart';

Widget buildOfflineNote(BuildContext context) {
  final controller = OfflineController.to;
  return Scaffold(
    backgroundColor: Colors.white,
    body: Obx(() {
      final allNotes = controller.notes;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: allNotes.isEmpty
            ? Center(
                child: Text(
                  'No offline notes found.',
                  style: TextStyle(fontSize: 16.sp),
                ),
              )
            : MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allNotes.length,
                itemBuilder: (context, index) {
                  final note = allNotes[index];
                  final noteId = note.id ?? 'No ID';
                  final formattedDate =
                      DateFormat('dd MMM yyyy').format(note.createdAt);
                  final formattedTime =
                      DateFormat('hh:mm a').format(note.createdAt);
                  final backgroundColor = note.colorValue != null
                      ? Color(note.colorValue!)
                      : Colors.grey.shade200;

                  return Column(
                    children: [
                      buildNoteCard(
                        title: note.title,
                        content: note.content,
                        time: formattedTime,
                        date: formattedDate,
                        backgroundColor: backgroundColor,
                        showPinButton: false,
                        onTap: () => Get.toNamed(
                          Routes.detailNoteRoute,
                          arguments: {'noteId': noteId},
                        ),
                        onPinButtonPressed: () {
                          NoteController.to.togglePin(noteId, note);
                        },
                        isPinned: note.isPin,
                      ),
                    ],
                  );
                },
              ),
      );
    }),
    floatingActionButton: FloatingActionButton(
      backgroundColor: ColorStyle.primary,
      onPressed: () {
        Get.toNamed(Routes.noteAddNoteRoute);
      },
      child: Icon(Icons.add, size: 30.sp, color: Colors.white),
    ),
  );
}

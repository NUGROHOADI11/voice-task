import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../configs/routes/route.dart';
import '../../controllers/note_controller.dart';
import 'note_card.dart';

Widget buildBody(BuildContext context) {
  final noteController = NoteController.to;

  return Obx(() {
    final allNotes = noteController.notes
        .where((note) => !note.isDeleted)
        .where((note) => note.title
            .toLowerCase()
            .contains(noteController.searchQuery.value.toLowerCase()))
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
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
                      onTap: () => Get.toNamed(
                        Routes.detailNoteRoute,
                        arguments: {'noteId': noteId},
                      ),
                      onPinButtonPressed: () {
                        noteController.togglePin(noteId, note);
                      },
                      isPinned: note.isPin,
                    ),
                  ],
                );
              },
            ),
    );
  });
}

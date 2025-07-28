import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../configs/routes/route.dart';
import '../../../note/controllers/note_controller.dart';
import '../../../note/sub_features/add_note/models/note_model.dart';
import '../../../note/view/components/note_card.dart';
import 'action_card.dart';

Widget buildPinList() {
  final noteC = NoteController.to;
  return Obx(() {
    final pinnedNotes =
        noteC.notes.where((note) => note.isPin == true).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: pinnedNotes.length + 1,
        itemBuilder: (context, index) {
          if (index == pinnedNotes.length) {
            return buildActionCard(context);
          }
          final Note note = pinnedNotes[index];
          final noteId = note.id ?? 'No ID';
          final formattedDate =
              DateFormat('dd MMM yyyy').format(note.createdAt);
          final formattedTime = DateFormat('hh:mm a').format(note.createdAt);
          final backgroundColor = note.colorValue != null
              ? Color(note.colorValue!)
              : Colors.grey.shade200;

          return buildNoteCard(
            title: note.title,
            content: note.content,
            time: formattedTime,
            date: formattedDate,
            backgroundColor: backgroundColor,
            onTap: () => Get.toNamed(Routes.detailNoteRoute,
                arguments: {'noteId': noteId}),
            onPinButtonPressed: () {
              NoteController.to.togglePin(
                noteId,
                note,
              );
            },
            isPinned: note.isPin,
          );
        },
      ),
    );
  });
}

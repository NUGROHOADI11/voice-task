import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:voice_task/utils/services/firestore_service.dart';

import '../../../../configs/routes/route.dart';
import '../../../note/controllers/note_controller.dart';
import '../../../note/sub_features/add_note/models/note_model.dart';
import '../../../note/view/components/note_card.dart';
import 'action_card.dart';

Widget buildPinList() {
  return StreamBuilder<QuerySnapshot<Object?>>(
    stream: FirestoreService().getDataNotes(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        var listData = snapshot.data!.docs;

        final pinnedNotes =
            NoteController.to.notes.where((note) => note.isPin).toList();

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
              final String noteId = listData
                  .where((doc) =>
                      NoteController.to.notes.any((note) => note.isPin))
                  .elementAt(index)
                  .id;

              final Note note = pinnedNotes[index];

              String formattedDate =
                  DateFormat('dd MMM yyyy').format(note.createdAt);
              String formattedTime =
                  DateFormat('hh:mm a').format(note.createdAt);
              Color backgroundColor = note.colorValue != null
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
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
}
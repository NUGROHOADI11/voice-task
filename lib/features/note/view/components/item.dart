import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../configs/routes/route.dart';
import '../../../../utils/services/firestore_service.dart';
import '../../controllers/note_controller.dart';
import '../../sub_features/add_note/models/note_model.dart';
import 'note_card.dart';

Widget buildBody(BuildContext context) {
  final FirestoreService firestoreService = FirestoreService();

  if (NoteController.to.isLoading.value) {
    return const Center(child: CircularProgressIndicator());
  }

  if (NoteController.to.filteredNotes.isEmpty) {
    return Center(
      child: Text(
        NoteController.to.searchQuery.isEmpty
            ? 'No notes yet. Add one!'.tr
            : 'No notes found for your search.'.tr,
        style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600),
      ),
    );
  }

  return StreamBuilder<QuerySnapshot<Object?>>(
      stream: FirestoreService().getDataNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var listData = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemCount: NoteController.to.filteredNotes.length,
              itemBuilder: (context, index) {
                final String noteId = listData[index].id;
                final Note note = NoteController.to.filteredNotes[index];

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
                  date: formattedDate,
                  time: formattedTime,
                  backgroundColor: backgroundColor,
                  isPinned: note.isPin,
                  onTap: () {
                    Get.toNamed(Routes.detailNoteRoute,
                        arguments: {'noteId': noteId});
                  },
                  onPinButtonPressed: () {
                    firestoreService.updateNote(noteId, {
                      'isPin': !note.isPin,
                      'updatedAt': DateTime.now().toIso8601String(),
                    });
                  },
                );
              },
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      });
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:voice_task/utils/services/firestore_service.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../note/controllers/note_controller.dart';
import '../../../note/sub_features/add_note/models/note_model.dart';
import '../../../../shared/widgets/quill_viewer.dart';
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

              return buildPinCard(
                title: note.title,
                content: note.content,
                time: formattedTime,
                date: formattedDate,
                backgroundColor: backgroundColor,
                onTap: () => Get.toNamed(Routes.detailNoteRoute,
                    arguments: {'noteId': noteId}),
              );
            },
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    },
  );
}

Widget buildPinCard({
  required String title,
  required String content,
  required String time,
  required String date,
  required Color backgroundColor,
  required VoidCallback onTap,
}) {
  final bool isDark = backgroundColor == ColorStyle.primary ||
      backgroundColor == ColorStyle.dark ||
      backgroundColor == Colors.black;

  final Color textColor = isDark ? Colors.white : Colors.black;
  final Color subColor = isDark ? Colors.white70 : Colors.grey.shade800;
  final Color dateColor = isDark ? Colors.white60 : Colors.black54;

  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 6),
          const SizedBox(height: 6),
          IgnorePointer(
            child: QuillViewer(
              jsonString: content,
              defaultTextStyle: TextStyle(color: textColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(time, style: TextStyle(color: subColor)),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(date,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: dateColor)),
          ),
        ],
      ),
    ),
  );
}

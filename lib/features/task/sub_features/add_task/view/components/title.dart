import 'package:flutter/material.dart';

Widget buildTitleTile({
    required TextEditingController titleController,
    required TextEditingController subtitleController,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF34C759),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          child: const Icon(
            Icons.view_agenda_outlined,
            color: Colors.black,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
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
              TextFormField(
                controller: subtitleController,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter Subtitle',
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
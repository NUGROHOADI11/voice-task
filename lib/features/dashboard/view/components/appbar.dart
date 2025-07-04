import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_task/features/dashboard/controllers/dashboard_controller.dart';

AppBar buildAppBar() {
  return AppBar(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    title: Obx(() => DashboardController.to.isSearching.value
        ? _buildSearchField()
        : _buildAppTitle()),
    actions: [_buildSearchToggle()],
  );
}

Widget _buildSearchField() {
  return TextField(
    controller: DashboardController.to.searchController,
    autofocus: true,
    decoration: InputDecoration(
      hintText: 'Search...',
      border: InputBorder.none,
      hintStyle: TextStyle(color: Colors.grey[500]),
    ),
    style: const TextStyle(fontSize: 18),
  );
}

Widget _buildAppTitle() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'VoiceTask',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
      ),
      Text(
        'Smart Voice Assistant',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    ],
  );
}

Widget _buildSearchToggle() {
  return Padding(
    padding: const EdgeInsets.only(right: 12),
    child: GestureDetector(
      onTap: DashboardController.to.toggleSearch,
      child: Obx(() => Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Icon(
              DashboardController.to.isSearching.value
                  ? Icons.close
                  : Icons.search_outlined,
              color: Colors.black,
            ),
          )),
    ),
  );
}

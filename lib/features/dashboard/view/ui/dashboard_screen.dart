import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../shared/styles/color_style.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/quill_viewer.dart';
import '../../constants/dashboard_assets_constant.dart';
import '../../controllers/dashboard_controller.dart';
import '../components/date_tab.dart';
import '../components/greeting.dart';
import '../components/task_list.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final assetsConstant = DashboardAssetsConstant();
  final controller = DashboardController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: Column(
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
          ),
          centerTitle: false,
          isSearch: controller.isSearching.value,
          onSearchChanged: controller.isSearching.value
              ? (value) => controller.searchQuery.value = value
              : null,
          action: controller.isSearching.value
              ? Obx(() => DropdownButton<String>(
                    value: controller.searchFilter.value,
                    underline: const SizedBox(),
                    onChanged: (val) {
                      if (val != null) controller.searchFilter.value = val;
                    },
                    items: ['All', 'Tasks', 'Notes']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                  ))
              : IconButton(
                  onPressed: controller.toggleSearch,
                  icon: const Icon(Icons.search),
                ),
          action2: controller.isSearching.value
              ? IconButton(
                  onPressed: controller.toggleSearch,
                  icon: const Icon(Icons.close),
                )
              : null,
        ),
        body: controller.isSearching.value
            ? Obx(() => _buildSearchResults())
            : Column(
                children: [
                  buildGreetingCard(),
                  buildDateSelector(),
                  SizedBox(height: 12.h),
                  Expanded(child: buildTaskList()),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final filter = controller.searchFilter.value;
    final tasks = controller.filteredTasks;
    final notes = controller.filteredNotes;

    if (filter == 'Tasks' && tasks.isEmpty) {
      return const Center(child: Text("No matching tasks found."));
    }
    if (filter == 'Notes' && notes.isEmpty) {
      return const Center(child: Text("No matching notes found."));
    }
    if (filter == 'All' && tasks.isEmpty && notes.isEmpty) {
      return const Center(child: Text("No matching tasks or notes found."));
    }

    return ListView(
      padding: EdgeInsets.all(12.w),
      children: [
        if (filter != 'Notes' && tasks.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Text(
              "Tasks",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
          ...tasks.map((t) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorStyle.secondary,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        t.description,
                        style: TextStyle(
                          color: Colors.grey[700],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SizedBox(height: 12.h),
        ],
        if (filter != 'Tasks' && notes.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Text(
              "Notes",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
          ...notes.map((n) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorStyle.accent,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      IgnorePointer(
                        child: QuillViewer(
                          jsonString: n.content,
                          defaultTextStyle: TextStyle(
                            color: Colors.grey[700],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ],
    );
  }
}

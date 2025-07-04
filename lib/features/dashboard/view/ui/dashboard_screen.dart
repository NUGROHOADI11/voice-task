import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../shared/widgets/custom_appbar.dart';
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
        appBar: controller.isSearching.value
            ? CustomAppBar(
                title: const Text("Search"),
                isSearch: true,
                // onSearchChanged: (value) =>
                //     controller.searchQuery.value = value,
                action: IconButton(
                  onPressed: () {
                    controller.toggleSearch();
                  },
                  icon: const Icon(Icons.close),
                ))
            : CustomAppBar(
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
                action: IconButton(
                    onPressed: controller.toggleSearch,
                    icon: const Icon(Icons.search)),
              ),
        body: Column(
          children: [
            buildGreetingCard(),
            buildDateSelector(),
            SizedBox(height: 12.h),
            Expanded(
              child: buildTaskList(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:voice_task/shared/styles/color_style.dart';

import '../../../../shared/widgets/custom_appbar.dart';
import '../../../landing/repositories/landing_repository.dart';
import '../../constants/offline_assets_constant.dart';
import '../../controllers/offline_controller.dart';
import '../components/note_offline.dart';
import '../components/task_offline.dart';

class OfflineScreen extends StatelessWidget {
  OfflineScreen({super.key});

  final assetsConstant = OfflineAssetsConstant();
  final controller = OfflineController.to;
  final user = LandingRepository().getUserProfile();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: Text(
            'Voice Task',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          action: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              controller.refreshConnection();
            },
          ),
          action2: user != null
              ? Container(
                  padding: EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: ColorStyle.secondary,
                    child: Icon(Icons.person, size: 20.sp, color: Colors.white),
                  ),
                )
              : CircleAvatar(
                  backgroundColor: ColorStyle.secondary,
                  child: Icon(Icons.not_interested,
                      size: 20.sp, color: Colors.white),
                ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Note'),
              Tab(text: 'Task'),
            ],
          ),
        ),
        body: Column(
          children: [
            Obx(() {
              if (controller.banner.value) {
                return Container(
                  width: double.infinity,
                  color: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          user != null
                              ? 'You are offline. Some features may be unavailable.'
                              : 'You are offline and not logged in. your data will not be synced.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      InkWell(
                          child: Icon(Icons.close,
                              color: Colors.white, size: 20.sp),
                          onTap: () {
                            controller.toggleBanner();
                          })
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            }),
            Expanded(
              child: TabBarView(
                children: [
                  buildOfflineNote(context),
                  buildOfflineTask(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

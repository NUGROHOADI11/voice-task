import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../shared/controllers/global_controller.dart';
import '../../controllers/home_controller.dart';
import '../../../../shared/styles/color_style.dart';
import '../components/bottom_nav_bar.dart';
import '../components/voice_action_button.dart';
import '../components/voice_command_dialog_content.dart';
import '../../../dashboard/view/ui/dashboard_screen.dart';
import '../../../note/view/ui/note_screen.dart';
import '../../../profile/view/ui/profile_screen.dart';
import '../../../task/view/ui/task_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> _screens = [
    DashboardScreen(),
    NoteScreen(),
    TaskScreen(),
    const ProfileScreen(),
  ];

  static const double _navBarHeight = 68.0;
  static const double _navBarBottomMargin = 12.0;
  static const double _navBarHiddenOffset = _navBarHeight + _navBarBottomMargin;
  static const double _initialFabBottomPosition = 45.0;
  static const double _fabHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final homeController = HomeController.to;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => homeController.activityDetected(),
        onPanDown: (_) => homeController.activityDetected(),
        behavior: HitTestBehavior.opaque,
        child: GetX<GlobalController>(
          builder: (globalController) {
            final isOnline = globalController.isConnected.value;

            return Stack(
              children: [
                Obx(() => _screens[homeController.currentIndex.value]),
                BottomNavBar(
                  controller: homeController,
                  navBarHiddenOffset: _navBarHiddenOffset,
                ),
                VoiceActionButton(
                  controller: homeController,
                  initialFabBottomPosition: _initialFabBottomPosition,
                  navBarHiddenOffset: _navBarHiddenOffset,
                  fabHeight: _fabHeight,
                  isDisabled: !isOnline,
                  onPressed: () {
                    homeController.activityDetected();
                    if (!isOnline) {
                      Get.snackbar(
                        'No Internet Connection',
                        'Please check your internet connection and try again.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: ColorStyle.danger,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    _showVoiceCommandDialog(context, homeController);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void _showVoiceCommandDialog(BuildContext context, HomeController controller) {
  Get.dialog(
    Dialog(
      backgroundColor: ColorStyle.light,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: VoiceCommandDialogContent(controller: controller),
    ),
    barrierDismissible: true,
  ).then((_) {
    controller.activityDetected();
  });
}

import 'package:get/get.dart';
import 'package:voice_task/configs/routes/route.dart';
import 'package:voice_task/features/detail_note/bindings/detail_note_binding.dart';
import 'package:voice_task/features/detail_note/view/ui/detail_note_screen.dart';
import 'package:voice_task/features/detail_task/bindings/detail_task_binding.dart';
import 'package:voice_task/features/detail_task/view/ui/detail_task_screen.dart';
import 'package:voice_task/features/hidden/bindings/hidden_binding.dart';
import 'package:voice_task/features/hidden/view/ui/hidden_screen.dart';
import 'package:voice_task/features/home/bindings/home_binding.dart';
import 'package:voice_task/features/landing/bindings/landing_binding.dart';
import 'package:voice_task/features/landing/view/ui/landing_screen.dart';
import 'package:voice_task/features/note/sub_features/add_note/view/ui/add_note_screen.dart';
import 'package:voice_task/features/notification/bindings/notification_binding.dart';
import 'package:voice_task/features/notification/view/ui/notification_screen.dart';
import 'package:voice_task/features/on_board/bindings/on_board_binding.dart';
import 'package:voice_task/features/on_board/view/ui/on_board_screen.dart';
import 'package:voice_task/features/splash/bindings/splash_binding.dart';
import 'package:voice_task/features/splash/view/ui/splash_screen.dart';

import '../../features/home/view/ui/home_screen.dart';
import '../../features/note/bindings/note_binding.dart';
import '../../features/note/view/ui/note_screen.dart';
import '../../features/offline/bindings/offline_binding.dart';
import '../../features/offline/view/ui/offline_screen.dart';
import '../../features/task/bindings/task_binding.dart';
import '../../features/task/sub_features/add_task/view/ui/add_task_screen.dart';
import '../../features/task/view/ui/task_screen.dart';

abstract class Pages {
  static final pages = [
    GetPage(
        name: Routes.splashRoute,
        page: () => SplashScreen(),
        binding: SplashBinding()),
    GetPage(
        name: Routes.onBoardRoute,
        page: () => OnBoardScreen(),
        binding: OnBoardBinding()),
    GetPage(
        name: Routes.landingRoute,
        page: () => LandingScreen(),
        binding: LandingBinding()),
    GetPage(
        name: Routes.homeRoute,
        page: () => HomeScreen(),
        binding: HomeBinding()),
    GetPage(
        name: Routes.noteRoute,
        page: () => NoteScreen(),
        binding: NoteBinding()),
    GetPage(
        name: Routes.detailNoteRoute,
        page: () => DetailNoteScreen(),
        binding: DetailNoteBinding()),
    GetPage(
        name: Routes.noteAddNoteRoute,
        page: () => AddNoteScreen(),
        binding: NoteBinding()),
    GetPage(
        name: Routes.taskRoute,
        page: () => TaskScreen(),
        binding: TaskBinding()),
    GetPage(
        name: Routes.detailTaskRoute,
        page: () => DetailTaskScreen(),
        binding: DetailTaskBinding()),
    GetPage(
        name: Routes.taskAddTaskRoute,
        page: () => AddTaskScreen(),
        binding: TaskBinding()),
    GetPage(
        name: Routes.notificationRoute,
        page: () => NotificationScreen(),
        binding: NotificationBinding()),
    GetPage(
        name: Routes.hiddenRoute,
        page: () => HiddenScreen(),
        binding: HiddenBinding()),
    GetPage(
        name: Routes.offlineRoute,
        page: () => OfflineScreen(),
        binding: OfflineBinding()),
  ];
}

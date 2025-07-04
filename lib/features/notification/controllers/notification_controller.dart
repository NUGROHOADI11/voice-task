import 'package:get/get.dart';

import '../models/notification_model.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.put(NotificationController());

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  void addNotification(String title, String body) {
    notifications.insert(
      0,
      NotificationModel(
        title: title,
        body: body,
        timestamp: DateTime.now(),
      ),
    );
  }

  void clearAllNotifications() {
    notifications.clear();
  }
}

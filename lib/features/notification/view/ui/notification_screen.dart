import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constants/core/assets/image_constant.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../utils/services/notification_service.dart';
import '../../controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final notificationController = NotificationController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          title: Text('Notifications'.tr),
          action: IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              notificationController.clearAllNotifications();
            },
          )),
      body: Obx(() {
        if (notificationController.notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(ImageConstant.homeDecoration),
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Text(
                  'No Notifications',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: notificationController.notifications.length,
          itemBuilder: (context, index) {
            final notification = notificationController.notifications[index];
            return ListTile(
              leading:
                  const Icon(Icons.notifications_active, color: Colors.blue),
              title: Text(notification.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(notification.body),
              trailing: Text(
                DateFormat('h:mm a').format(notification.timestamp),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          },
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'fab1',
            onPressed: () {
              const title = 'Instant Notification';
              const body = 'This is an instant test notification.';

              NotificationService().showNotification(title: title, body: body);

              notificationController.addNotification(title, body);
            },
            label: const Text('Show Now'),
            icon: const Icon(Icons.notifications),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'fab2',
            onPressed: () {
              const title = 'Scheduled Notification';
              const body = 'This will appear in 10 seconds.';

              NotificationService().scheduleNotification(
                id: 1,
                title: title,
                body: body,
                scheduledTime: DateTime.now().add(const Duration(seconds: 10)),
              );
            },
            label: const Text('Schedule'),
            icon: const Icon(Icons.timer),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:steak2house/src/screens/notifications/widgets/body_notifications.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: BodyNotifications(),
      ),
    );
  }
}

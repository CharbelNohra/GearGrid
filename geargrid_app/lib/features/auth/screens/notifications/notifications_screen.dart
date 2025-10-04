import 'package:flutter/material.dart';
import 'package:geargrid/common/widgets/custom_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Text(
          'Notifications Screen',
          style: TextStyle(
            fontSize: 32,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
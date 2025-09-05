import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;
  final int notificationCount;
  final int cartCount;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.onCartTap,
    this.notificationCount = 0,
    this.cartCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // 🔹 removes back arrow
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        // 🔔 Notifications
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              ),
              onPressed: onNotificationTap,
            ),
            if (notificationCount > 0)
              Positioned(
                right: 7,
                top: 7,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  child: Text(
                    notificationCount.toString(),
                    style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
          ],
        ),

        // 🛒 Cart
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              ),
              onPressed: onCartTap,
            ),
            if (cartCount > 0)
              Positioned(
                right: 7,
                top: 7,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  child: Text(
                    cartCount.toString(),
                    style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
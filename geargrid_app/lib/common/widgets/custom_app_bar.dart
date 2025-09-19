import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;
  final int notificationCount;
  final int cartCount;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.onCartTap,
    this.notificationCount = 0,
    this.cartCount = 0,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading:
          automaticallyImplyLeading && GoRouter.of(context).canPop()
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
              : null,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        // 🔔 Notifications
        _BadgeIconButton(
          icon: Icons.notifications,
          count: notificationCount,
          onTap: onNotificationTap,
        ),

        // 🛒 Cart
        _BadgeIconButton(
          icon: Icons.shopping_cart,
          count: cartCount,
          onTap: onCartTap,
        ),
      ],
    );
  }
}

/// 🔹 Private reusable widget for icon with a badge
class _BadgeIconButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onTap;

  const _BadgeIconButton({required this.icon, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
          onPressed: onTap,
        ),
        if (count > 0)
          Positioned(
            right: 7,
            top: 7,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Theme.of(context).colorScheme.error,
              child: FittedBox(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

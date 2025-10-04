import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int notificationCount;
  final int cartCount;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.notificationCount = 3,
    this.cartCount = 3,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
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
          onTap: () {
            if (currentLocation != '/notifications') {
              context.push('/notifications');
            }
          },
        ),
        
        // 🛒 Cart
        _BadgeIconButton(
          icon: Icons.shopping_cart,
          count: cartCount,
          onTap: () {
            if (currentLocation != '/cart') {
              context.push('/cart');
            }
          },
        ),
      ],
    );
  }
}

class _BadgeIconButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onTap;

  const _BadgeIconButton({required this.icon, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: count > 0
          ? Badge.count(
              count: count,
              child: Icon(
                icon,
                size: 27,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Icon(
              icon,
              size: 27,
              color: Theme.of(context).colorScheme.primary,
            ),
      onPressed: onTap,
    );
  }
}
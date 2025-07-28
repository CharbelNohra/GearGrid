import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../features/Home/screen/home.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/search/screens/search_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Define your screens
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    NotificationsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: <Widget>[
          Icon(Icons.home, size: 30, color:Theme.of(context).colorScheme.onPrimary),
          Icon(Icons.search, size: 30, color:Theme.of(context).colorScheme.onPrimary),
          Icon(Icons.notifications, size: 30, color:Theme.of(context).colorScheme.onPrimary),
          Icon(Icons.settings, size: 30, color:Theme.of(context).colorScheme.onPrimary),
        ],
        color: Theme.of(context).colorScheme.primary,
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: _screens[_page],
    );
  }
}

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:geargrid/features/auth/screens/favorites/favorites_screen.dart';
import '../../features/auth/screens/home/home.dart';
import '../../features/auth/screens/profile/profile_screen.dart';
import '../../features/auth/screens/search/search_screen.dart';

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
    FavoritesScreen(),
    ProfileScreen(),
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
          Icon(Icons.favorite, size: 30, color:Theme.of(context).colorScheme.onPrimary),
          Icon(Icons.person, size: 30, color:Theme.of(context).colorScheme.onPrimary),
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

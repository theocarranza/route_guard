import 'package:flutter/material.dart';
import 'package:riverpod_example/core/router/route_path.dart';
import 'package:riverpod_example/features/home/home_screen.dart';
import 'package:riverpod_example/features/login/login_screen.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String _selectedPath = '/login'; // Default

  @override
  AppRoutePath get currentConfiguration => AppRoutePath(_selectedPath);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_selectedPath == '/login')
          const MaterialPage(child: LoginScreen(), key: ValueKey('login'))
        else if (_selectedPath == '/home')
          const MaterialPage(child: HomeScreen(), key: ValueKey('home'))
        else
          // Default/Fallback
          const MaterialPage(child: LoginScreen(), key: ValueKey('default')),
      ],
      onDidRemovePage: (page) {
        // Handle pop if needed (stack logic), but here we switch root pages mostly.
        // For a single page stack, usually pop isn't called unless we push.
        // If we had a stack, we'd remove from it.
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _selectedPath = configuration.location;
    notifyListeners();
  }
}

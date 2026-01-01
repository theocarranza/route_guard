import 'package:flutter/material.dart';
import 'package:riverpod_example/core/router/route_path.dart';
import 'package:riverpod_example/features/home/home_screen.dart';
import 'package:riverpod_example/features/login/login_screen.dart';
import 'package:riverpod_example/features/welcome/welcome_screen.dart';
import 'package:riverpod_example/features/error/screens/denied_screen.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String _selectedPath = '/'; // Default to Welcome

  @override
  AppRoutePath get currentConfiguration => AppRoutePath(_selectedPath);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (_selectedPath == '/')
          const MaterialPage(child: WelcomeScreen(), key: ValueKey('welcome'))
        else if (_selectedPath == '/login')
          const MaterialPage(child: LoginScreen(), key: ValueKey('login'))
        else if (_selectedPath == '/home')
          const MaterialPage(child: HomeScreen(), key: ValueKey('home'))
        else if (_selectedPath == '/denied')
          const MaterialPage(child: DeniedScreen(), key: ValueKey('denied'))
        else
          // Default/Fallback
          const MaterialPage(child: WelcomeScreen(), key: ValueKey('default')),
      ],
      onDidRemovePage: (page) {
        // Handle pop if needed (stack logic), but here we switch root pages mostly.
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _selectedPath = configuration.location;
    notifyListeners();
  }
}

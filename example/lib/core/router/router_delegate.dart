import 'package:example/features/auth/sign_in/sign_in_page_route.dart';
import 'package:example/features/auth/sign_out/sign_out_page_route.dart';
import 'package:flutter/material.dart';
import 'package:example/core/router/route_path.dart';
import 'package:example/core/state/app_state.dart';
import 'package:example/features/error/screens/denied_screen.dart';
import 'package:example/features/home/home_page_route.dart';

class MyRouterDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppState appState;

  String _selectedPath = '/';

  MyRouterDelegate(this.appState) : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  @override
  MyRoutePath get currentConfiguration => MyRoutePath(_selectedPath);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [_buildPage()],
      onDidRemovePage: (page) {
        _selectedPath = page.name ?? '/';
        notifyListeners();
      },
    );
  }

  MaterialPage<void> _buildPage() {
    return switch (_selectedPath) {
      '/sign-in' => MaterialPage<void>(
        name: '/sign-in',
        key: const ValueKey('/sign-in'),
        child: SignInPageRouteGuard(state: appState),
      ),
      '/sign-out' => MaterialPage<void>(
        name: '/sign-out',
        key: const ValueKey('/sign-out'),
        child: SignOutPageRouteGuard(state: appState),
      ),
      '/home' => MaterialPage<void>(
        name: '/home',
        key: const ValueKey('/home'),
        child: HomePageRouteGuard(appState: appState),
      ),
      '/denied' => MaterialPage<void>(
        name: '/denied',
        key: const ValueKey('/denied'),
        child: const DeniedScreen(),
      ),
      _ => MaterialPage<void>(
        name: '/sign-in',
        key: const ValueKey('/sign-in'),
        child: SignInPageRouteGuard(state: appState),
      ),
    };
  }

  /// Navigate programmatically and update the URL bar.
  void navigateTo(String path) {
    _selectedPath = path;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(MyRoutePath configuration) async {
    _selectedPath = configuration.location;
    notifyListeners();
  }
}

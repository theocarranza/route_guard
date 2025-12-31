import 'package:flutter/material.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';

void main() {
  runApp(const RouteGuardExampleApp());
}

// =============================================================================
// APP
// =============================================================================

/// A minimal example demonstrating [RouteGuard] with Navigator 2.0.
class RouteGuardExampleApp extends StatefulWidget {
  const RouteGuardExampleApp({super.key});

  @override
  State<RouteGuardExampleApp> createState() => _RouteGuardExampleAppState();
}

class _RouteGuardExampleAppState extends State<RouteGuardExampleApp> {
  final _authState = AuthState();
  late final _routerDelegate = AppRouterDelegate(_authState);
  final _routeParser = AppRouteParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Route Guard Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeParser,
    );
  }
}

// =============================================================================
// AUTH STATE
// =============================================================================

/// Simple authentication state using [ChangeNotifier].
class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

// =============================================================================
// ROUTER
// =============================================================================

/// Route configuration for Navigator 2.0.
class AppRoutePath {
  final String path;

  const AppRoutePath(this.path);

  static const home = AppRoutePath('/');
  static const login = AppRoutePath('/login');
  static const denied = AppRoutePath('/denied');
}

/// Parses URL to [AppRoutePath] and vice versa.
class AppRouteParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final path = routeInformation.uri.path;
    return AppRoutePath(path.isEmpty ? '/' : path);
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    return RouteInformation(uri: Uri.parse(configuration.path));
  }
}

/// Delegates navigation using the Pages API.
class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final AuthState authState;
  String _currentPath = '/';

  AppRouterDelegate(this.authState) {
    authState.addListener(notifyListeners);
  }

  @override
  AppRoutePath get currentConfiguration => AppRoutePath(_currentPath);

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _currentPath = configuration.path;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [_buildPage()],
      onDidRemovePage: (page) {
        _currentPath = page.name ?? '/';
        notifyListeners();
      },
    );
  }

  MaterialPage<void> _buildPage() {
    return switch (_currentPath) {
      '/login' => MaterialPage<void>(
        name: '/login',
        key: const ValueKey('/login'),
        child: LoginScreen(authState: authState),
      ),
      '/denied' => const MaterialPage<void>(
        name: '/denied',
        key: ValueKey('/denied'),
        child: DeniedScreen(),
      ),
      _ => MaterialPage<void>(
        name: '/',
        key: const ValueKey('/'),
        child: HomeScreen(authState: authState),
      ),
    };
  }
}

// =============================================================================
// SCREENS
// =============================================================================

/// Login screen shown when user is not authenticated.
class LoginScreen extends StatelessWidget {
  final AuthState authState;

  const LoginScreen({super.key, required this.authState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authState.login();
            Router.of(
              context,
            ).routerDelegate.setNewRoutePath(AppRoutePath.home);
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}

/// Protected home screen with [RouteGuard].
class HomeScreen extends StatelessWidget {
  final AuthState authState;

  const HomeScreen({super.key, required this.authState});

  @override
  Widget build(BuildContext context) {
    // RouteGuard checks auth state before showing content.
    return RouteGuard(
      state: authState.isLoggedIn
          ? const AsyncData(true)
          : const AsyncData(false),
      loadingWidget: const Center(child: CircularProgressIndicator()),
      errorWidgetBuilder: (error, _) => Center(child: Text('Error: $error')),
      onRedirect: (ctx) {
        Router.of(ctx).routerDelegate.setNewRoutePath(AppRoutePath.denied);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Home (Protected)')),
        backgroundColor: Colors.green.shade50,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 64, color: Colors.green),
              const SizedBox(height: 16),
              const Text('Welcome! You are logged in.'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  authState.logout();
                  Router.of(
                    context,
                  ).routerDelegate.setNewRoutePath(AppRoutePath.login);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Access denied screen shown when unauthorized.
class DeniedScreen extends StatelessWidget {
  const DeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access Denied')),
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.block, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('You must be logged in to access this page.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Router.of(
                  context,
                ).routerDelegate.setNewRoutePath(AppRoutePath.login);
              },
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

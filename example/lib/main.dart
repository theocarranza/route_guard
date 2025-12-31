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
      debugShowCheckedModeBanner: false,
      title: 'Route Guard Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
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

  static const welcome = AppRoutePath('/');
  static const login = AppRoutePath('/login');
  static const dashboard = AppRoutePath('/dashboard');
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
      '/dashboard' => MaterialPage<void>(
        name: '/dashboard',
        key: const ValueKey('/dashboard'),
        child: DashboardScreen(authState: authState),
      ),
      '/denied' => const MaterialPage<void>(
        name: '/denied',
        key: ValueKey('/denied'),
        child: DeniedScreen(),
      ),
      _ => const MaterialPage<void>(
        name: '/',
        key: ValueKey('/'),
        child: WelcomeScreen(),
      ),
    };
  }
}

// =============================================================================
// SCREENS
// =============================================================================

/// Welcome screen - explains what this example demonstrates.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Guard Example'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.security,
                      size: 72,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to Route Guard',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This example demonstrates how to protect routes using '
                      'the RouteGuard widget with Navigator 2.0.',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '• Try accessing /dashboard without logging in',
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• The RouteGuard will redirect you to /denied',
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Login first, then access the protected route',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            Router.of(context).routerDelegate.setNewRoutePath(
                              AppRoutePath.login,
                            );
                          },
                          icon: const Icon(Icons.login),
                          label: const Text('Go to Login'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            Router.of(context).routerDelegate.setNewRoutePath(
                              AppRoutePath.dashboard,
                            );
                          },
                          icon: const Icon(Icons.dashboard),
                          label: const Text('Try Dashboard'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Login screen - simulates authentication.
class LoginScreen extends StatelessWidget {
  final AuthState authState;

  const LoginScreen({super.key, required this.authState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Router.of(
              context,
            ).routerDelegate.setNewRoutePath(AppRoutePath.welcome);
          },
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 72,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Authentication',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This screen simulates a login flow. In a real app, '
                      'you would validate credentials here.\n\n'
                      'Click Login to set isLoggedIn = true in AuthState.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          authState.login();
                          Router.of(context).routerDelegate.setNewRoutePath(
                            AppRoutePath.dashboard,
                          );
                        },
                        icon: const Icon(Icons.login),
                        label: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Protected dashboard screen with [RouteGuard].
class DashboardScreen extends StatelessWidget {
  final AuthState authState;

  const DashboardScreen({super.key, required this.authState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // RouteGuard checks auth state before showing content.
    return RouteGuard(
      state: authState.isLoggedIn
          ? const BaseAsyncData(true)
          : const BaseAsyncData(false),
      loadingWidget: const Center(child: CircularProgressIndicator()),
      errorWidgetBuilder: (error, _) => Center(child: Text('Error: $error')),
      onRedirect: (ctx) {
        Router.of(ctx).routerDelegate.setNewRoutePath(AppRoutePath.denied);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Router.of(
                context,
              ).routerDelegate.setNewRoutePath(AppRoutePath.welcome);
            },
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                authState.logout();
                Router.of(
                  context,
                ).routerDelegate.setNewRoutePath(AppRoutePath.login);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 72,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Protected Content',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You are viewing a protected route!\n\n'
                        'The RouteGuard widget verified that isLoggedIn == true '
                        'before rendering this content. If the check fails, '
                        'onRedirect is called to navigate away.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AuthState.isLoggedIn = true',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Access denied screen - shown when attempting unauthorized access.
class DeniedScreen extends StatelessWidget {
  const DeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Denied'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Router.of(
              context,
            ).routerDelegate.setNewRoutePath(AppRoutePath.welcome);
          },
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 0,
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.gpp_bad,
                      size: 72,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Access Denied',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You tried to access a protected route without '
                      'authentication.\n\n'
                      'The RouteGuard detected isLoggedIn == false and '
                      'called onRedirect to bring you here.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () {
                        Router.of(
                          context,
                        ).routerDelegate.setNewRoutePath(AppRoutePath.login);
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Go to Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

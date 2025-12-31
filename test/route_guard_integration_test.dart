import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';

void main() {
  testWidgets('Integration: RouteGuard with Navigator 2.0', (tester) async {
    // 1. Setup RouterDelegate and Parser
    final delegate = TestRouterDelegate();
    final parser = TestRouteInformationParser();

    await tester.pumpWidget(
      MaterialApp.router(
        routerDelegate: delegate,
        routeInformationParser: parser,
      ),
    );

    // Initial state: / (Home)
    expect(find.text('Home Screen'), findsOneWidget);

    // 2. Navigate to Protected Route (Initially Loading)
    delegate.setPath('/protected');
    await tester.pumpAndSettle();
    expect(find.text('Loading...'), findsOneWidget);

    // 3. State -> False (Auth Failed)
    // Should redirect to /login
    delegate.setGuardState(const AsyncData(false));
    await tester.pumpAndSettle();
    expect(find.text('Login Screen'), findsOneWidget);
    expect(delegate.currentConfiguration.path, '/login');

    // 4. Navigate back to Protected Route, checking State -> True (Auth Success)
    // Should stay on /protected and show content
    delegate.setGuardState(const AsyncData(true));
    delegate.setPath('/protected');
    await tester.pumpAndSettle();
    expect(find.text('Protected Content'), findsOneWidget);
    expect(delegate.currentConfiguration.path, '/protected');
  });
}

// --- Test Harness Helpers ---

class Destination {
  final String path;
  Destination(this.path);
}

class TestRouteInformationParser extends RouteInformationParser<Destination> {
  @override
  Future<Destination> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return Destination(routeInformation.uri.path);
  }

  @override
  RouteInformation restoreRouteInformation(Destination configuration) {
    return RouteInformation(uri: Uri.parse(configuration.path));
  }
}

class TestRouterDelegate extends RouterDelegate<Destination>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Destination> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Destination _currentDestination = Destination('/');
  BaseAsyncValue<bool> _guardState = const AsyncLoading();

  void setPath(String path) {
    _currentDestination = Destination(path);
    notifyListeners();
  }

  void setGuardState(BaseAsyncValue<bool> state) {
    _guardState = state;
    notifyListeners();
  }

  @override
  Destination get currentConfiguration => _currentDestination;

  @override
  Future<void> setNewRoutePath(Destination configuration) async {
    _currentDestination = configuration;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: Text('Home Screen'), key: ValueKey('/')),
        if (_currentDestination.path == '/login')
          const MaterialPage(
            child: Text('Login Screen'),
            key: ValueKey('/login'),
          ),
        if (_currentDestination.path == '/protected')
          MaterialPage(
            key: const ValueKey('/protected'),
            child: RouteGuard(
              state: _guardState,
              onRedirect: (ctx) {
                setPath('/login');
              },
              loadingWidget: const Scaffold(body: Text('Loading...')),
              errorWidgetBuilder: (error, stackTrace) =>
                  Scaffold(body: Text('Error: $error')),
              child: const Scaffold(body: Text('Protected Content')),
            ),
          ),
      ],
      onDidRemovePage: (page) {
        // Handle page removal
      },
    );
  }
}

import 'package:example/core/router/route_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';
import 'package:example/core/state/app_state.dart';

class HomePageRouteGuard extends StatelessWidget {
  final AppState appState;

  const HomePageRouteGuard({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return RouteGuard(
      state: appState.isLoggedIn
          ? const AsyncData(true)
          : const AsyncData(false),
      loadingWidget: const Center(child: CircularProgressIndicator()),
      errorWidgetBuilder: (error, stackTrace) {
        return const Center(child: Text('Error'));
      },
      onRedirect: (context) {
        Router.of(
          context,
        ).routerDelegate.setNewRoutePath(MyRoutePath('/denied'));
      },
      child: HomePageWidget(appState: appState),
    );
  }
}

class HomePageRoute extends MaterialPageRoute {
  final AppState appState;

  HomePageRoute({required this.appState})
    : super(
        settings: const RouteSettings(name: '/home'),
        builder: (context) {
          return HomePageRouteGuard(appState: appState);
        },
      );
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home (/home)')),
      backgroundColor: Colors.green.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check, size: 64, color: Colors.green),
            const Text(
              'Welcome Home!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                appState.logout();
                Router.of(
                  context,
                ).routerDelegate.setNewRoutePath(MyRoutePath('/sign-out'));
              },
              child: const Text('Go to /logout'),
            ),
          ],
        ),
      ),
    );
  }
}

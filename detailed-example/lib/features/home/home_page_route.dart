import 'package:example/core/router/route_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';
import 'package:example/core/state/app_state.dart';

/// RouteGuard wrapper for home page - protects access.
class HomePageRouteGuard extends StatelessWidget {
  final AppState appState;

  const HomePageRouteGuard({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return RouteGuard(
      state: appState.isLoggedIn
          ? const BaseAsyncData(true)
          : const BaseAsyncData(false),
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

/// Home page widget - protected content with M3 layout.
class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key, required this.appState});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Router.of(context).routerDelegate.setNewRoutePath(MyRoutePath('/'));
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              appState.logout();
              Router.of(
                context,
              ).routerDelegate.setNewRoutePath(MyRoutePath('/sign-out'));
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
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
                      'HomePageRouteGuard wraps HomePageWidget using '
                      'RouteGuard. The guard checks isLoggedIn before '
                      'rendering this content.',
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
                            'AppState.isLoggedIn = true',
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
    );
  }
}

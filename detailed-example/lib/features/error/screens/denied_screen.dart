import 'package:example/core/router/route_path.dart';
import 'package:flutter/material.dart';

/// Access denied screen - shown when unauthorized access is attempted.
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
            Router.of(context).routerDelegate.setNewRoutePath(MyRoutePath('/'));
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
                      'The RouteGuard in HomePageRouteGuard detected '
                      'isLoggedIn == false and called onRedirect.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () {
                        Router.of(context).routerDelegate.setNewRoutePath(
                          MyRoutePath('/sign-in'),
                        );
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Go to Sign In'),
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

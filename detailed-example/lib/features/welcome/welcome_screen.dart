import 'package:example/core/router/route_path.dart';
import 'package:flutter/material.dart';

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
                      'This is the detailed example showing how to organize '
                      'RouteGuard in a multi-file architecture.\n\n'
                      '• Each route has its own guard file\n'
                      '• Screens are separated from guard logic\n'
                      '• Router delegate manages page navigation',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            Router.of(context).routerDelegate.setNewRoutePath(
                              MyRoutePath('/sign-in'),
                            );
                          },
                          icon: const Icon(Icons.login),
                          label: const Text('Go to Sign In'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            Router.of(context).routerDelegate.setNewRoutePath(
                              MyRoutePath('/home'),
                            );
                          },
                          icon: const Icon(Icons.home),
                          label: const Text('Try /home'),
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

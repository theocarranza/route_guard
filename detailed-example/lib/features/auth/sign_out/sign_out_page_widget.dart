import 'package:example/core/router/route_path.dart';
import 'package:flutter/material.dart';

/// Sign-out confirmation screen with M3 layout.
class SignOutPageWidget extends StatelessWidget {
  const SignOutPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signed Out'),
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
          constraints: const BoxConstraints(maxWidth: 450),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 0,
              color: theme.colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout,
                      size: 72,
                      color: theme.colorScheme.tertiary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Signed Out Successfully',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your session has ended. This screen is protected by '
                      'SignOutPageRoute which only allows access when '
                      'isLoggedIn == false.\n\n'
                      'If you were still logged in, you would be redirected '
                      'to /home.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
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
                      label: const Text('Sign In Again'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Router.of(
                          context,
                        ).routerDelegate.setNewRoutePath(MyRoutePath('/home'));
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Try /home'),
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

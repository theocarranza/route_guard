import 'package:example/core/router/route_path.dart';
import 'package:example/core/state/app_state.dart';
import 'package:flutter/material.dart';

/// Sign-in page widget - simulates authentication.
class SignInPageWidget extends StatelessWidget {
  final AppState appState;

  const SignInPageWidget({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
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
                      'This screen is wrapped in a RouteGuard that redirects '
                      'to /home if already logged in.\n\n'
                      'SignInPageRoute uses: canActivate = !isLoggedIn',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          appState.login();
                          Router.of(context).routerDelegate.setNewRoutePath(
                            MyRoutePath('/home'),
                          );
                        },
                        icon: const Icon(Icons.login),
                        label: const Text('Sign In'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        Router.of(
                          context,
                        ).routerDelegate.setNewRoutePath(MyRoutePath('/home'));
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Try /home (Unauthorized)'),
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

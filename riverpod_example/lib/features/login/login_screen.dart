import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';
import 'package:riverpod_example/core/state/auth_provider.dart';
import 'package:riverpod_example/core/utils/async_value_extension.dart';
import 'package:riverpod_example/core/router/route_path.dart';
import 'package:riverpod_example/core/widgets/route_breadcrumb.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
  
  // ... (rest of class)


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Transform auth state to guard state (canActivate).
    // Login page: canActivate if !isLoggedIn.
    final guardState = switch (authState.toBaseAsyncValue()) {
      BaseAsyncData(value: final isLoggedIn) => BaseAsyncData(!isLoggedIn),
      BaseAsyncLoading() => const BaseAsyncLoading<bool>(),
      BaseAsyncError(:final error, :final stackTrace) => BaseAsyncError<bool>(
        error: error,
        stackTrace: stackTrace,
      ),
    };

    return RouteGuard(
      state: guardState,
      onRedirect: (context) {
        // If we are logged in (guardState is false), redirect to Home.
        Router.of(
          context,
        ).routerDelegate.setNewRoutePath(AppRoutePath('/home'));
      },
      loadingWidget: const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      ),
      errorWidgetBuilder: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Router.of(
                context,
              ).routerDelegate.setNewRoutePath(AppRoutePath('/'));
            },
          ),
        ),
        bottomNavigationBar: const RouteBreadcrumb(),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Authentication',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This screen is guarded. It only allows access if you are NOT logged in.\n\n'
                        'State: ${guardState is BaseAsyncData ? "Access Granted" : "Redirecting..."}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed:
                              () => ref.read(authProvider.notifier).login(),
                          icon: const Icon(Icons.login),
                          label: const Text('Sign In'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';
import 'package:riverpod_example/core/state/auth_provider.dart';
import 'package:riverpod_example/core/utils/async_value_extension.dart';
import 'package:riverpod_example/core/router/route_path.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

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
          title: const Text('Login Page'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Router.of(
                context,
              ).routerDelegate.setNewRoutePath(AppRoutePath('/'));
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('You are NOT logged in.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(authProvider.notifier).login(),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

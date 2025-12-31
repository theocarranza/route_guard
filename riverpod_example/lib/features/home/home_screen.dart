import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';
import 'package:riverpod_example/core/state/auth_provider.dart';
import 'package:riverpod_example/core/utils/async_value_extension.dart';
import 'package:riverpod_example/core/router/route_path.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Transform auth state to guard state.
    // Home page: canActivate if isLoggedIn.
    final guardState = switch (authState.toBaseAsyncValue()) {
      BaseAsyncData(value: final isLoggedIn) => BaseAsyncData(isLoggedIn),
      BaseAsyncLoading() => const BaseAsyncLoading<bool>(),
      BaseAsyncError(:final error, :final stackTrace) => 
          BaseAsyncError<bool>(error: error, stackTrace: stackTrace),
    };

    return RouteGuard(
      state: guardState,
      onRedirect: (context) {
        Router.of(context).routerDelegate.setNewRoutePath(AppRoutePath('/login'));
      },
      loadingWidget: const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      ),
      errorWidgetBuilder: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: [
            if (authState.isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 16, 
                  height: 16, 
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                ),
              ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Welcome! You are logged in.'),
              const SizedBox(height: 8),
              const Text(
                'Try "Refresh Session". The RouteGuard should NOT show the full-screen loader,\n' 
                'because our extension maps "Loading with Data" to "Data".\n' 
                'Instead, you should see a spinner in the AppBar.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.read(authProvider.notifier).refreshCheck(),
                child: const Text('Refresh Session (Background)'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

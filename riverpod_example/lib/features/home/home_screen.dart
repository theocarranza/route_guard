import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';
import 'package:riverpod_example/core/state/auth_provider.dart';
import 'package:riverpod_example/core/utils/async_value_extension.dart';
import 'package:riverpod_example/core/router/route_path.dart';
import 'package:riverpod_example/core/widgets/route_breadcrumb.dart';

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
      BaseAsyncError(:final error, :final stackTrace) => BaseAsyncError<bool>(
        error: error,
        stackTrace: stackTrace,
      ),
    };

    return RouteGuard(
      state: guardState,
      onRedirect: (context) {
        Router.of(
          context,
        ).routerDelegate.setNewRoutePath(AppRoutePath('/login'));
      },
      loadingWidget: const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      ),
      errorWidgetBuilder: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Router.of(
                context,
              ).routerDelegate.setNewRoutePath(AppRoutePath('/'));
            },
          ),
          actions: [
            if (authState.isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
        bottomNavigationBar: const RouteBreadcrumb(),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Protected Content',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Try "Refresh Session". The RouteGuard should NOT show the full-screen loader,\n'
                        'because our extension maps "Loading with Data" to "Data".\n'
                        'Instead, you should see a spinner in the AppBar.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'DEBUG STATE INFO',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Divider(),
                              Text(
                                'Riverpod State: ${authState.isLoading ? "Loading ⏳" : "Idle ✅"}',
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                              Text(
                                'Has Data: ${authState.hasValue}',
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                              const SizedBox(height: 8),
                              const Text('⬇️ Mapped To ⬇️'),
                              const SizedBox(height: 8),
                              Text(
                                'RouteGuard State: ${guardState is BaseAsyncData ? "Data (Access Granted) 🟢" : "Loading (Blocked) 🔴"}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed:
                            () =>
                                ref.read(authProvider.notifier).refreshCheck(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Session (Background)'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed:
                            () => ref.read(authProvider.notifier).logout(),
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
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

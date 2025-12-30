import 'package:flutter/material.dart';
import '../domain/guard_async_value.dart';

/// A widget that guards a route based on the provided [state].
///
/// If [state] is [GuardAsyncData] with `false`, it redirects to [fallbackPath].
/// If [state] is [GuardAsyncData] with `true`, it ensures the user is on [destinationPath].
class RouteGuard extends StatelessWidget {
  /// The current state of the guard check.
  final GuardAsyncValue<bool> state;

  /// The route path to redirect to if access is denied.
  final String fallbackPath;

  /// The protected route path that is being guarded.
  final String destinationPath;

  /// The current route path of the application.
  final String currentPath;

  /// Callback to handle redirection.
  /// Implementations should use their router's navigation method (e.g., GoRouter's `go`).
  final void Function(BuildContext context, String path) onRedirect;

  /// Widget to display while the guard state is loading.
  final Widget? loadingWidget;

  /// Widget builder to display if the guard state encounters an error.
  final Widget Function(Object error, StackTrace? stackTrace)?
  errorWidgetBuilder;

  const RouteGuard({
    required this.state,
    required this.fallbackPath,
    required this.destinationPath,
    required this.currentPath,
    required this.onRedirect,
    this.loadingWidget,
    this.errorWidgetBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case GuardAsyncLoading():
        return loadingWidget ??
            const Center(child: CircularProgressIndicator.adaptive());

      case GuardAsyncError(error: final error, stackTrace: final st):
        return errorWidgetBuilder?.call(error, st) ??
            Center(child: Text('Error: $error'));

      case GuardAsyncData(value: final canActivate):
        _onCheck(context, canActivate);
        return const SizedBox.shrink();
    }
  }

  void _onCheck(BuildContext context, bool canActivate) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      if (!canActivate) {
        onRedirect(context, fallbackPath);
        return;
      }

      // If authorized, ensure we proceed to the destination if we aren't there already.
      // This handles cases where the guard is used as a redirector.
      // Check if current path is the destination or a sub-route.
      if (!_isOnDestinationRoute(currentPath, destinationPath)) {
        onRedirect(context, destinationPath);
      }
    });
  }

  bool _isOnDestinationRoute(String current, String dest) {
    if (current == dest) return true;
    // Handle sub-routes (e.g., /home/details is on /home)
    return current.startsWith('$dest/');
  }
}

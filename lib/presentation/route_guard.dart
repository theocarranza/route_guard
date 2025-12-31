/// This library provides the [RouteGuard] widget.
library;

import 'package:flutter/material.dart';
import '../domain/guard_async_value.dart';

/// A widget that guards a route based on the provided [state].
///
/// If [state] is [AsyncData] with `false`, it redirects to [fallbackPath].
/// If [state] is [AsyncData] with `true`, it ensures the user is on [destinationPath].
class RouteGuard extends StatelessWidget {
  /// The current state of the guard check.
  final BaseAsyncValue<bool> state;

  /// Callback to handle redirection.
  final void Function(BuildContext context) onRedirect;

  /// Widget to display while the guard state is loading.
  final Widget loadingWidget;

  /// Widget builder to display if the guard state encounters an error.
  final Widget Function(Object error, StackTrace? stackTrace)
  errorWidgetBuilder;

  /// The widget to display if access is granted.
  final Widget child;

  /// Creates a [RouteGuard].
  ///
  /// [state] is the async value determining access.
  /// [onRedirect] handles the navigation logic.
  /// [child] is the protected content.
  const RouteGuard({
    required this.state,
    required this.onRedirect,
    required this.child,
    required this.loadingWidget,
    required this.errorWidgetBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      AsyncLoading() => loadingWidget,
      AsyncError(:final error, :final stackTrace) => errorWidgetBuilder(
        error,
        stackTrace,
      ),
      AsyncData(:final value) => _onCheck(
        context,
        canActivate: value,
        child: child,
      ),
    };
  }

  Widget _onCheck(
    BuildContext context, {
    required bool canActivate,
    required Widget child,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!canActivate) {
        onRedirect(context);
      }
    });
    return child;
  }
}

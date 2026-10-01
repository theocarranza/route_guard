/// This library provides the [RouteGuard] widget.
library;

import 'package:flutter/material.dart';
import '../domain/base_async_value.dart';

/// A widget that guards a route based on the provided [state].
///
/// If [state] is [BaseAsyncData] with `false`, it redirects to [fallbackPath].
/// If [state] is [BaseAsyncData] with `true`, it ensures the user is on [destinationPath].
class RouteGuard extends StatefulWidget {
  final Object _source;

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
    required BaseAsyncValue<bool> state,
    required this.onRedirect,
    required this.child,
    required this.loadingWidget,
    required this.errorWidgetBuilder,
    super.key,
  }) : _source = state;

  /// Creates a [RouteGuard] that listens to [canActivate].
  const RouteGuard.stream({
    required Stream<bool> canActivate,
    required this.onRedirect,
    required this.child,
    required this.loadingWidget,
    required this.errorWidgetBuilder,
    super.key,
  }) : _source = canActivate;

  @override
  State<RouteGuard> createState() => _RouteGuardState();
}

class _RouteGuardState extends State<RouteGuard> {
  @override
  Widget build(BuildContext context) => switch (widget._source) {
    final BaseAsyncValue<bool> state => _buildState(context, state: state),
    final Stream<bool> canActivate => StreamBuilder<bool>(
      stream: canActivate,
      builder: (context, snapshot) => switch (snapshot) {
        AsyncSnapshot(error: final Object error, :final stackTrace) =>
          widget.errorWidgetBuilder(error, stackTrace),
        AsyncSnapshot(data: true) => widget.child,
        _ => widget.loadingWidget,
      },
    ),
    _ => const SizedBox.shrink(),
  };

  Widget _buildState(
    BuildContext context, {
    required BaseAsyncValue<bool> state,
  }) => switch (state) {
    BaseAsyncLoading() => widget.loadingWidget,
    BaseAsyncError(:final error, :final stackTrace) =>
      widget.errorWidgetBuilder(error, stackTrace),
    BaseAsyncData(:final value) => _onCheck(
      context,
      canActivate: value,
      child: widget.child,
    ),
  };

  Widget _onCheck(
    BuildContext context, {
    required bool canActivate,
    required Widget child,
  }) => switch (canActivate) {
    false => _redirectAfterBuild(context, child),
    true => child,
  };

  Widget _redirectAfterBuild(BuildContext context, Widget child) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onRedirect(context);
    });
    return child;
  }
}

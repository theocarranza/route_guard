import 'package:flutter/material.dart';
import 'package:riverpod_example/core/router/router_delegate.dart';

class RouteBreadcrumb extends StatelessWidget {
  const RouteBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    final delegate = Router.of(context).routerDelegate as AppRouterDelegate;
    final location = delegate.currentConfiguration.location;

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SafeArea(
        child: Text(
          '📍 Current Route: $location',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontFamily: 'monospace',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';

void main() {
  testWidgets('RouteGuard shows loading widget when loading', (tester) async {
    const state = BaseAsyncLoading<bool>();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RouteGuard(
          state: state,
          onRedirect: (_) {},
          loadingWidget: const Text('Loading...'),
          errorWidgetBuilder: (error, stackTrace) => Text('Error: $error'),
          child: const SizedBox(),
        ),
      ),
    );

    expect(find.text('Loading...'), findsOneWidget);
  });

  testWidgets('RouteGuard redirects to fallback when False', (tester) async {
    const state = BaseAsyncData(false);
    bool redirected = false;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RouteGuard(
          state: state,
          onRedirect: (_) {
            redirected = true;
          },
          loadingWidget: const CircularProgressIndicator(),
          errorWidgetBuilder: (error, stackTrace) => Text('Error: $error'),
          child: const SizedBox(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(redirected, isTrue);
  });

  testWidgets('RouteGuard renders child and DOES NOT redirect when True', (
    tester,
  ) async {
    const state = BaseAsyncData(true);
    bool redirected = false;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RouteGuard(
          state: state,
          onRedirect: (_) {
            redirected = true;
          },
          loadingWidget: const CircularProgressIndicator(),
          errorWidgetBuilder: (error, stackTrace) => Text('Error: $error'),
          child: const Text('Protected Content'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Protected Content'), findsOneWidget);
    expect(redirected, isFalse);
  });

  testWidgets('RouteGuard shows error widget when error occurs', (
    tester,
  ) async {
    final state = BaseAsyncError<bool>(
      error: Exception('Auth failed'),
      stackTrace: StackTrace.empty,
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RouteGuard(
          state: state,
          onRedirect: (_) {},
          loadingWidget: const CircularProgressIndicator(),
          errorWidgetBuilder: (error, stackTrace) => Text('Error: $error'),
          child: const SizedBox(),
        ),
      ),
    );

    expect(find.textContaining('Error:'), findsOneWidget);
  });

  testWidgets('RouteGuard stream mode shows loading before first decision', (
    tester,
  ) async {
    final controller = StreamController<bool>();

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RouteGuard.stream(
          canActivate: controller.stream,
          onRedirect: (_) {},
          loadingWidget: const Text('Loading stream...'),
          errorWidgetBuilder: (error, stackTrace) => Text('Error: $error'),
          child: const Text('Stream Content'),
        ),
      ),
    );

    expect(find.text('Loading stream...'), findsOneWidget);

    await controller.close();
  });

  testWidgets('RouteGuard stream mode renders child after true', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RouteGuard.stream(
          canActivate: Stream<bool>.value(true),
          onRedirect: (_) {},
          loadingWidget: const Text('Loading stream...'),
          errorWidgetBuilder: (error, stackTrace) => Text('Error: $error'),
          child: const Text('Stream Content'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Stream Content'), findsOneWidget);
  });
}

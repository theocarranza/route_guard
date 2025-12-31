import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';

void main() {
  testWidgets('RouteGuard shows loading widget when loading', (tester) async {
    const state = AsyncLoading<bool>();
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
    const state = AsyncData(false);
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
    const state = AsyncData(true);
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
    final state = AsyncError<bool>(
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
}

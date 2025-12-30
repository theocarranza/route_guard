import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_guard/route_guard.dart';

void main() {
  testWidgets('RouteGuard shows loading widget when loading', (tester) async {
    const state = GuardAsyncLoading<bool>();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RouteGuard(
          state: state,
          fallbackPath: '/login',
          destinationPath: '/home',
          currentPath: '/',
          onRedirect: (_, __) {},
          loadingWidget: const Text('Loading...'),
        ),
      ),
    );

    expect(find.text('Loading...'), findsOneWidget);
  });

  testWidgets('RouteGuard redirects to fallback when False', (tester) async {
    const state = GuardAsyncData(false);
    String? redirectedTo;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RouteGuard(
          state: state,
          fallbackPath: '/login',
          destinationPath: '/home',
          currentPath: '/',
          onRedirect: (_, path) {
            redirectedTo = path;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(redirectedTo, '/login');
  });

  testWidgets(
    'RouteGuard redirects to destination when True and not on destination',
    (tester) async {
      const state = GuardAsyncData(true);
      String? redirectedTo;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RouteGuard(
            state: state,
            fallbackPath: '/login',
            destinationPath: '/home',
            currentPath: '/',
            onRedirect: (_, path) {
              redirectedTo = path;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(redirectedTo, '/home');
    },
  );

  testWidgets(
    'RouteGuard DOES NOT redirect when True and ALREADY on destination',
    (tester) async {
      const state = GuardAsyncData(true);
      bool redirected = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: RouteGuard(
            state: state,
            fallbackPath: '/login',
            destinationPath: '/home',
            currentPath: '/home',
            onRedirect: (_, path) {
              redirected = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(redirected, isFalse);
    },
  );
}

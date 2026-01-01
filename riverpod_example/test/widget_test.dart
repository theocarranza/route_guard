// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_example/main.dart';

void main() {
  testWidgets('Riverpod RouteGuard Integration Flow', (
    WidgetTester tester,
  ) async {
    // Set a larger surface size
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;

    // 1. Build the app (Starts at / (Welcome) by default).
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Verify Initial State: Welcome Screen
    expect(find.text('Welcome to Riverpod Guard'), findsOneWidget);
    expect(find.text('Go to Sign In'), findsOneWidget);

    // 2. Navigate to Login
    await tester.tap(find.text('Go to Sign In'));
    await tester.pumpAndSettle();

    // Verify Login Screen
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Sign In')),
      findsOneWidget,
    );
    expect(find.textContaining('This screen is guarded'), findsOneWidget);

    // 3. Perform Login
    await tester.tap(find.byIcon(Icons.login));
    // Trigger the loading state (async guard)
    await tester.pump();
    // Wait for the simulated delay in AuthNotifier.login
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify Redirect to Home
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Home')),
      findsOneWidget,
    );
    expect(find.text('Protected Content'), findsOneWidget);

    // 4. Test Background Refresh (The "Soft Spot" Fix)
    // Tap Refresh Button
    await tester.tap(find.text('Refresh Session (Background)'));
    await tester.pump(); // Trigger the action

    // Check that we are STILL on Home during the "loading" phase of the refresh
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Home')),
      findsOneWidget,
    );

    // Check for the "Loading with Data" mapping result (Debug Card)
    expect(find.textContaining('Data (Access Granted)'), findsOneWidget);
    expect(find.textContaining('Loading (Blocked)'), findsNothing);

    // Wait for refresh to complete
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    // Still on Home
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Home')),
      findsOneWidget,
    );

    // 5. Perform Logout
    await tester.tap(find.text('Logout'));
    await tester.pump();
    // Wait for simulated delay
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify Redirect back to Login
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Sign In')),
      findsOneWidget,
    );

    // Reset size
    addTearDown(tester.view.resetPhysicalSize);
  });
}

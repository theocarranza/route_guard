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
import 'package:riverpod_example/core/state/auth_provider.dart';

void main() {
  testWidgets('Riverpod RouteGuard Integration Flow', (WidgetTester tester) async {
    // 1. Build the app (Starts at /login by default if not auth).
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // Verify Initial State: Login Screen
    expect(find.text('Login Page'), findsOneWidget);
    expect(find.text('You are NOT logged in.'), findsOneWidget);

    // 2. Perform Login
    await tester.tap(find.text('Login'));
    // Trigger the loading state (async guard)
    await tester.pump(); 
    // Wait for the simulated delay in AuthNotifier.login
    await tester.pump(const Duration(milliseconds: 600)); 
    await tester.pumpAndSettle();

    // Verify Redirect to Home
    expect(find.text('Home Page'), findsOneWidget);
    expect(find.text('Welcome! You are logged in.'), findsOneWidget);

    // 3. Test Background Refresh (The "Soft Spot" Fix)
    // Tap Refresh Button
    await tester.tap(find.text('Refresh Session (Background)'));
    await tester.pump(); // Trigger the action

    // Check that we are STILL on Home Page during the "loading" phase of the refresh
    expect(find.text('Home Page'), findsOneWidget);
    
    // Check for the "Loading with Data" mapping result (Debug Card)
    // The debug card text logic: "RouteGuard State: Data (Access Granted) 🟢"
    expect(find.textContaining('Data (Access Granted)'), findsOneWidget);
    expect(find.textContaining('Loading (Blocked)'), findsNothing);

    // Wait for refresh to complete
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    // Still on Home
    expect(find.text('Home Page'), findsOneWidget);

    // 4. Perform Logout
    await tester.tap(find.text('Logout'));
    await tester.pump();
    // Wait for simulated delay
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify Redirect back to Login
    expect(find.text('Login Page'), findsOneWidget);
    expect(find.text('You are NOT logged in.'), findsOneWidget);
  });
}

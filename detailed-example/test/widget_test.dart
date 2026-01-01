import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Guest login check: redirects to denied screen', (
    WidgetTester tester,
  ) async {
    // Set a larger surface size to prevent overflow errors in tests
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify we are on the Welcome screen
    expect(find.text('Welcome to Route Guard'), findsOneWidget);
    expect(find.text('Go to Sign In'), findsOneWidget);
    expect(find.text('Try /home'), findsOneWidget);

    // Tap the guest button to try and access the guarded /home route
    await tester.tap(find.text('Try /home'));
    await tester.pumpAndSettle();

    // Expectation: The guard on Home screen should reject us (since not logged in)
    // and redirect us to the fallback path '/denied'.
    // 'Access Denied' appears in AppBar and Body. Let's verify the AppBar title to confirm navigation.
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Access Denied'),
      ),
      findsOneWidget,
    );
    expect(find.text('Protected Content'), findsNothing);

    // Reset size
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('Authenticated login check: allows access to home', (
    WidgetTester tester,
  ) async {
    // Set a larger surface size
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the Login button on Welcome Screen
    await tester.tap(find.text('Go to Sign In'));
    await tester.pumpAndSettle();

    // Now we are on Sign In page. Click "Sign In" button (avoiding AppBar title conflict)
    // Simply finding by Icon since it is unique on this page.
    await tester.tap(find.byIcon(Icons.login));
    await tester.pumpAndSettle();

    // Expectation: We are redirected to Home because logic in SignInPageWidget 
    // navigates to /home after login.
    expect(find.text('Protected Content'), findsOneWidget);
    
    // Reset size
    addTearDown(tester.view.resetPhysicalSize);
  });
}

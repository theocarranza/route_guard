import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('Guest login check: redirects to denied screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify we are on the Login screen (Root Page)
    expect(find.text('Root Page'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Try /home (Unauthorized)'), findsOneWidget);

    // Tap the guest button to try and access the guarded /home route
    await tester.tap(find.text('Try /home (Unauthorized)'));
    await tester.pumpAndSettle();

    // Expectation: The guard on Home screen should reject us (since not logged in)
    // and redirect us to the fallback path '/denied'.
    expect(find.text('Access Denied'), findsOneWidget);
    expect(find.text('Welcome Home!'), findsNothing);
  });

  testWidgets('Authenticated login check: allows access to home', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the Login button
    await tester.tap(find.text('Login'));
    await tester.pump(); // Update state

    // Now try to access /home (simulated by logic, but for this test we'll rely on the app state being updated).
    // In this specific demo, the Login button only updates state, it doesn't navigate.
    // So we would need to manually trigger navigation or click a button that navigates.
    // The current UI doesn't have a "Go to Home" button for logged in users on the login page
    // (the login page itself is an inverse guard that redirects to home if logged in!)

    // Re-trigger build to let InverseGuard redirect to /home
    await tester.pumpAndSettle();

    // Expectation: We are redirected to Home because InverseGuard saw we are logged in.
    expect(find.text('Welcome Home!'), findsOneWidget);
  });
}

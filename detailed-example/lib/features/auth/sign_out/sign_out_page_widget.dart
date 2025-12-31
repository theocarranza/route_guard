import 'package:example/core/router/route_path.dart';
import 'package:flutter/material.dart';

class SignOutPageWidget extends StatelessWidget {
  const SignOutPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Out (/sign-out)')),
      backgroundColor: Colors.red.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 64, color: Colors.red),
            const Text(
              'You have been signed out',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () => Router.of(
                context,
              ).routerDelegate.setNewRoutePath(MyRoutePath('/home')),
              child: const Text('Go to /home'),
            ),
          ],
        ),
      ),
    );
  }
}

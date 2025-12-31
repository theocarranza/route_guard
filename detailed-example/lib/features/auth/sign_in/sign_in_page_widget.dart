import 'package:example/core/router/route_path.dart';
import 'package:example/core/state/app_state.dart';
import 'package:flutter/material.dart';

class SignInPageWidget extends StatelessWidget {
  final AppState appState;

  const SignInPageWidget({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login (/)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Root Page'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: appState.login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            // Feature: Guest Access Check
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: () {
                Router.of(
                  context,
                ).routerDelegate.setNewRoutePath(MyRoutePath('/home'));
              },
              child: const Text('Try /home (Unauthorized)'),
            ),
          ],
        ),
      ),
    );
  }
}

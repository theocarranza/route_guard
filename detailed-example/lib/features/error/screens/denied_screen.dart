import 'package:example/core/router/route_path.dart';
import 'package:flutter/material.dart';

class DeniedScreen extends StatelessWidget {
  const DeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Denied (/denied)')),
      backgroundColor: Colors.red.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.block, size: 64, color: Colors.red),
            const Text(
              'Access Denied',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Router.of(
                context,
              ).routerDelegate.setNewRoutePath(MyRoutePath('/')),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class DeniedScreenRoute extends MaterialPageRoute {
  DeniedScreenRoute()
    : super(
        settings: const RouteSettings(name: '/denied'),
        builder: (context) => const DeniedScreen(),
      );
}

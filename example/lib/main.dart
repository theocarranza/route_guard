import 'package:flutter/material.dart';
import 'package:flutter_route_guard/flutter_route_guard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Simulate an auth state
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Route Guard Example')),
        body: Center(
          child: ValueListenableBuilder<bool>(
            valueListenable: _isLoggedIn,
            builder: (context, isLoggedIn, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Logged In: $isLoggedIn'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _isLoggedIn.value = !_isLoggedIn.value,
                    child: Text(isLoggedIn ? 'Logout' : 'Login'),
                  ),
                  const SizedBox(height: 40),
                  const Text('Guarded Section:'),
                  const SizedBox(height: 10),
                  // Example usage of RouteGuard
                  // In a real app, this would wrap a Page in your router
                  SizedBox(
                    height: 100,
                    width: 200,
                    child: RouteGuard(
                      state: isLoggedIn
                          ? const GuardAsyncData(true)
                          : const GuardAsyncData(false),
                      fallbackPath: '/login',
                      destinationPath: '/protected',
                      currentPath: '/protected', // Simulating we are here
                      onRedirect: (ctx, path) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          SnackBar(content: Text('Redirecting to $path')),
                        );
                      },
                      child: Container(
                        color: Colors.green,
                        alignment: Alignment.center,
                        child: const Text(
                          'Access Granted!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

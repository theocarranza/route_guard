import 'package:flutter/material.dart';
import 'package:example/core/router/route_parser.dart';
import 'package:example/core/router/router_delegate.dart';
import 'package:example/core/state/app_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppState _appState;
  late MyRouterDelegate _routerDelegate;
  late MyRouteInformationParser _routeInformationParser;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _routerDelegate = MyRouterDelegate(_appState);
    _routeInformationParser = MyRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Route Guard Demo (Nav 2.0)',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

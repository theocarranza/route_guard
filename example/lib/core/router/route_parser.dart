import 'package:flutter/material.dart';
import 'package:example/core/router/route_path.dart';

class MyRouteInformationParser extends RouteInformationParser<MyRoutePath> {
  @override
  Future<MyRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    return MyRoutePath(uri.path.isEmpty ? '/' : uri.path);
  }

  @override
  RouteInformation? restoreRouteInformation(MyRoutePath configuration) {
    return RouteInformation(uri: Uri.parse(configuration.location));
  }
}

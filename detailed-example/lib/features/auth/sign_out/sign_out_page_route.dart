import 'package:example/core/router/route_path.dart';
import 'package:example/core/state/app_state.dart';
import 'package:example/features/auth/sign_out/sign_out_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_route_guard/domain/guard_async_value.dart';
import 'package:flutter_route_guard/presentation/route_guard.dart';

class SignOutPageRoute extends MaterialPageRoute {
  final AppState state;
  SignOutPageRoute({required this.state})
    : super(
        settings: const RouteSettings(name: '/sign-out'),
        builder: (context) {
          return SignOutPageRouteGuard(state: state);
        },
      );
}

class SignOutPageRouteGuard extends StatelessWidget {
  final AppState state;
  const SignOutPageRouteGuard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return RouteGuard(
      state: state.isLoggedIn ? const AsyncData(false) : const AsyncData(true),
      onRedirect: (context) {
        Router.of(context).routerDelegate.setNewRoutePath(MyRoutePath('/home'));
      },
      loadingWidget: const Center(child: CircularProgressIndicator()),
      errorWidgetBuilder: (error, stackTrace) =>
          const Center(child: Text('Error')),
      child: const SignOutPageWidget(),
    );
  }
}

import 'package:example/core/router/route_path.dart';
import 'package:example/core/state/app_state.dart';
import 'package:example/features/auth/sign_in/sign_in_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_route_guard/domain/base_async_value.dart';
import 'package:flutter_route_guard/presentation/route_guard.dart';

class SignInPageRoute extends MaterialPageRoute {
  final AppState appState;

  SignInPageRoute({required this.appState})
    : super(
        settings: const RouteSettings(name: '/sign-in'),
        builder: (context) {
          return SignInPageRouteGuard(state: appState);
        },
      );
}

class SignInPageRouteGuard extends StatelessWidget {
  final AppState state;
  const SignInPageRouteGuard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return RouteGuard(
      state: state.isLoggedIn
          ? const BaseAsyncData(false)
          : const BaseAsyncData(true),
      onRedirect: (context) {
        Router.of(context).routerDelegate.setNewRoutePath(MyRoutePath('/home'));
      },
      loadingWidget: const Center(child: CircularProgressIndicator()),
      errorWidgetBuilder: (error, stackTrace) =>
          const Center(child: Text('Error')),
      child: SignInPageWidget(appState: state),
    );
  }
}

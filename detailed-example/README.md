# Example

This example demonstrates how to use `flutter_route_guard` to protect a widget or route based on a boolean state.

In this simple demo, we toggle a "Logged In" state. When logged out, the guard triggers a redirect callback (showing a SnackBar). When logged in, the guarded content ("Access Granted!") is verified and shown.

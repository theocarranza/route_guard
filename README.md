# Route Guard

A platform-agnostic Flutter package for guarding routes based on asynchronous state.

`route_guard` makes it easy to protect routes in your Flutter application, handling loading, error, and data states gracefully. It is designed to work with any router, including `go_router`.

## Features

- **Async State Handling**: Built-in support for loading, error, and data states via `GuardAsyncValue`.
- **Platform Agnostic**: Works with any state management solution (Riverpod, Bloc, Provider, etc.).
- **Flexible Redirection**: Automatically redirects unauthorized users to a fallback path.
- **Router Independent**: purely widget-based, integrating seamlessly with your existing navigation setup.

## Usage

### 1. Define your Guard State

Wrap your state in `GuardAsyncValue`.

```dart
// Example using a simple ValueNotifier or similar
 GuardAsyncValue<bool> authState = const GuardAsyncData(true); // User is authenticated
```

### 2. Wrap your Route

Use the `RouteGuard` widget to protect a page.

```dart
RouteGuard(
  state: authState, // Your async state
  destinationPath: '/dashboard', // Where we are trying to go
  currentPath: currentPath, // The current location (from your router)
  fallbackPath: '/login', // Where to go if denied
  onRedirect: (context, path) {
    // Navigate using your router
    GoRouter.of(context).go(path);
  },
  loadingWidget: const CircularProgressIndicator(), // Optional
  child: DashboardScreen(),
)
```

## Installation

Add `route_guard` to your `pubspec.yaml`:

```yaml
dependencies:
  route_guard: ^0.0.1
```

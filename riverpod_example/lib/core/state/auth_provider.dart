import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simulates a persistent storage (e.g., SharedPreferences or a server-side session)
bool _mockPersistence = false;

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // Simulate network delay for checking session
    await Future.delayed(const Duration(seconds: 1));
    return _mockPersistence;
  }

  Future<void> login() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      _mockPersistence = true;
      return true;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      _mockPersistence = false;
      return false;
    });
  }

  /// Simulates a background token refresh.
  /// This helps demonstrate the 'refreshing' state where we have data but are loading.
  Future<void> refreshCheck() async {
    // This triggers a rebuild, putting the provider in loading state
    // while preserving the previous data (AsyncLoading + hasValue).
    ref.invalidateSelf();
    await future;
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
);

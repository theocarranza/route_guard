import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // Simulate checking local storage or API on startup
    await Future.delayed(const Duration(seconds: 1));
    return false; // Initially logged out
  }

  Future<void> login() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
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

final authProvider = AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

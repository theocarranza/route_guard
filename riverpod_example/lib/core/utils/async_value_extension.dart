import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_route_guard/domain/base_async_value.dart';

/// Extension to map Riverpod's [AsyncValue] to [BaseAsyncValue] for RouteGuard.
///
/// This implements a "Data Priority" strategy:
/// 1. If the AsyncValue has data (even if loading or error occurred during refresh),
///    it returns [BaseAsyncData]. This prevents the UI from flashing a loading
///    spinner or error screen during background refreshes.
/// 2. If no data but has error, returns [BaseAsyncError].
/// 3. Otherwise, returns [BaseAsyncLoading].
extension AsyncValueToGuard<T> on AsyncValue<T> {
  BaseAsyncValue<T> toBaseAsyncValue() {
    if (hasValue) {
      return BaseAsyncData(value as T);
    }
    if (hasError) {
      return BaseAsyncError(error: error!, stackTrace: stackTrace);
    }
    return const BaseAsyncLoading();
  }
}

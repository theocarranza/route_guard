/// A platform-agnostic representation of an asynchronous value state.
///
/// This library provides the sealed class [BaseAsyncValue] and its subclasses
/// for handling data, loading, and error states.
library;

sealed class BaseAsyncValue<T> {
  /// Abstract constant constructor.
  const BaseAsyncValue();
}

/// Represents the data state.
class AsyncData<T> extends BaseAsyncValue<T> {
  /// The current value of the data.
  final T value;

  /// Creates a [AsyncData] with the given [value].
  const AsyncData(this.value);
}

/// Represents the loading state.
class AsyncLoading<T> extends BaseAsyncValue<T> {
  /// Creates a [AsyncLoading] state.
  const AsyncLoading();
}

/// Represents the error state.
class AsyncError<T> extends BaseAsyncValue<T> {
  /// The error that occurred.
  final Object error;

  /// The stack trace associated with the error, if any.
  final StackTrace? stackTrace;

  /// Creates a [AsyncError] with the given [error] and optional [stackTrace].
  const AsyncError({required this.error, this.stackTrace});
}

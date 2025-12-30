/// A platform-agnostic representation of an asynchronous value state.
/// This allows the RouteGuard to be used with any state management solution.
sealed class GuardAsyncValue<T> {
  /// Abstract constant constructor.
  const GuardAsyncValue();
}

/// Represents the data state.
class GuardAsyncData<T> extends GuardAsyncValue<T> {
  /// The current value of the data.
  final T value;

  /// Creates a [GuardAsyncData] with the given [value].
  const GuardAsyncData(this.value);
}

/// Represents the loading state.
class GuardAsyncLoading<T> extends GuardAsyncValue<T> {
  /// Creates a [GuardAsyncLoading] state.
  const GuardAsyncLoading();
}

/// Represents the error state.
class GuardAsyncError<T> extends GuardAsyncValue<T> {
  /// The error that occurred.
  final Object error;

  /// The stack trace associated with the error, if any.
  final StackTrace? stackTrace;

  /// Creates a [GuardAsyncError] with the given [error] and optional [stackTrace].
  const GuardAsyncError(this.error, [this.stackTrace]);
}

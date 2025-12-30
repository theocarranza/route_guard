/// A platform-agnostic representation of an asynchronous value state.
/// This allows the RouteGuard to be used with any state management solution.
sealed class GuardAsyncValue<T> {
  const GuardAsyncValue();
}

/// Represents the data state.
class GuardAsyncData<T> extends GuardAsyncValue<T> {
  final T value;
  const GuardAsyncData(this.value);
}

/// Represents the loading state.
class GuardAsyncLoading<T> extends GuardAsyncValue<T> {
  const GuardAsyncLoading();
}

/// Represents the error state.
class GuardAsyncError<T> extends GuardAsyncValue<T> {
  final Object error;
  final StackTrace? stackTrace;
  const GuardAsyncError(this.error, [this.stackTrace]);
}

class BlocError {
  final dynamic source;
  final String message;
  final StackTrace stackTrace;

  BlocError({
    this.message,
    this.source,
    this.stackTrace,
  });
}

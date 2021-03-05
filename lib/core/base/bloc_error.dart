class BlocError {
  final dynamic source;
  final StackTrace stackTrace;
  final String? message;

  BlocError({
    required this.source,
    required this.stackTrace,
    this.message,
  });
}

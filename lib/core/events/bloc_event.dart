import 'package:meta/meta.dart';

@immutable
class BlocEvent<T, P> extends Object {
  final T? type;
  final Object? error;
  final P? payload;

  const BlocEvent({
    this.payload,
    this.error,
    this.type,
  });
}

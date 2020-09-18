import 'package:meta/meta.dart';

@immutable
class BlocEvent<P> extends Object {
  final dynamic type;
  final Object error;
  final P payload;

  const BlocEvent({
    this.payload,
    this.error,
    this.type,
  });
}

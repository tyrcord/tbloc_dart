import 'package:meta/meta.dart';

class BlocEvent<P> extends Object {
  final String type;
  final Error error;
  final P payload;

  BlocEvent({
    @required this.type,
    this.error,
    this.payload,
  }) : assert(type != null);
}

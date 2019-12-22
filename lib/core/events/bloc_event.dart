import 'package:meta/meta.dart';

@immutable
class BlocEvent<P> extends Object {
  final Object error;
  final P payload;
  final bool resetState;

  const BlocEvent({
    this.error,
    this.payload,
    bool resetState,
  }) : this.resetState = resetState ?? false;
}

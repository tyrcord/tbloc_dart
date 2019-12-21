import 'package:meta/meta.dart';

@immutable
class BlocEvent<P> extends Object {
  final Error error;
  final P payload;
  final bool shouldResetState;

  BlocEvent({
    this.error,
    this.payload,
    bool shouldResetState,
  }) : this.shouldResetState = shouldResetState ?? false;
}

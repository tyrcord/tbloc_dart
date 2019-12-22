import 'package:meta/meta.dart';

@immutable
class BlocEvent<P> extends Object {
  final Object error;
  final P payload;
  final bool shouldResetState;

  const BlocEvent({
    this.error,
    this.payload,
    bool shouldResetState,
  }) : this.shouldResetState = shouldResetState ?? false;
}

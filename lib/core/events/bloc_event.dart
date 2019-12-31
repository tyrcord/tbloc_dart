import 'package:meta/meta.dart';
import 'package:tbloc_dart/core/states/bloc_state.dart';

@immutable
class BlocEvent<P> extends Object {
  final Object error;
  final P payload;
  final BlocState resetWithState;

  const BlocEvent({
    this.error,
    this.payload,
    this.resetWithState,
  });
}

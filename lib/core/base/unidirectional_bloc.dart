import 'package:tbloc_dart/tbloc_dart.dart';

///
/// A UnidirectionalBloc is a subset of Bloc which has no notion of events and
/// relies on methods to emit new states.
///
abstract class UnidirectionalBloc<S extends BlocState> extends Bloc<S> {
  UnidirectionalBloc({
    S? initialState,
    BlocStateBuilder<S>? initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );
}

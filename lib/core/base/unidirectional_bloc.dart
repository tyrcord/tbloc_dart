import 'package:tbloc_dart/tbloc_dart.dart';

abstract class UnidirectionalBloc<S extends BlocState> extends Bloc<S> {
  UnidirectionalBloc({
    S initialState,
    BlocStateBuilder<S> initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );

  Future<void> reset() async => setState(getInitialState());
}

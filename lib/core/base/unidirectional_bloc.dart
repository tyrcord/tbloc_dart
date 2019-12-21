import 'package:tbloc_dart/core/base/base.dart';
import 'package:tbloc_dart/core/states/states.dart';
import 'package:tbloc_dart/core/types/types.dart';

abstract class UnidirectionalBloc<S extends BlocState> extends Bloc<S> {
  UnidirectionalBloc({
    S initialState,
    BlocStateBuilder<S> stateBuilder,
  }) : super(
          initialState: initialState,
          stateBuilder: stateBuilder,
        );

  void reset() => setState(getInitialState());
}

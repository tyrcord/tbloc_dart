import 'package:meta/meta.dart';
import 'package:tbloc_dart/core/states/bloc_state.dart';

class BlocStateTransitionStart<S extends BlocState> {
  final S currentState;
  final S nextState;

  BlocStateTransitionStart({
    @required this.currentState,
    @required this.nextState,
  });
}

class BlocStateTransitionEnd<S extends BlocState> {
  final S previousState;
  final S currentState;

  BlocStateTransitionEnd({
    @required this.previousState,
    @required this.currentState,
  });
}

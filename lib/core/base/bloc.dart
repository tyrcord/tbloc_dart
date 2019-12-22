import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:subx/subx.dart';

import 'package:tbloc_dart/core/states/states.dart';
import 'package:tbloc_dart/core/types/types.dart';

abstract class Bloc<S extends BlocState> {
  @protected
  final BehaviorSubject<S> stateController = BehaviorSubject<S>();
  @protected
  BlocStateBuilder<S> stateBuilder;
  @protected
  final S initialState;
  @protected
  final SubxList subxList = SubxList();

  S get currentState => stateController.value;

  Stream<S> get onData => stateController.stream;

  Bloc({
    this.initialState,
    this.stateBuilder,
  }) : assert(stateBuilder != null || initialState != null) {
    setState(getInitialState());
  }

  void dispose() {
    subxList.cancelAll();
    stateController.close();
  }

  @protected
  S getInitialState() {
    if (initialState != null) {
      return initialState;
    }

    return stateBuilder();
  }

  @protected
  void setState(S candidateState) {
    dispatchState(candidateState);
  }

  @protected
  Function(S) get dispatchState {
    if (!stateController.isClosed) {
      return stateController.sink.add;
    }

    return _dispatchState;
  }

  void _dispatchState(S state) {}
}

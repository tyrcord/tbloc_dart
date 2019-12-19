import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tbloc_dart/core/models/models.dart';
import 'package:tbloc_dart/core/states/states.dart';
import 'package:tbloc_dart/core/types/types.dart';
import 'bloc_delegate.dart';

abstract class Bloc<S extends BlocState, D extends BlocDelegate> {
  @protected
  final BehaviorSubject<S> stateController = BehaviorSubject<S>();
  @protected
  BlocStateBuilder<S> stateBuilder;
  @protected
  final S initialState;
  @protected
  final D delegate;

  S get currentState => stateController.value;

  Stream<S> get stream => stateController.stream;

  Bloc({
    this.initialState,
    this.stateBuilder,
    this.delegate,
  }) : assert(stateBuilder != null || initialState != null) {
    reset();
  }

  void reset() => setState(getInitialState());

  void dispose() => stateController.close();

  @protected
  S getInitialState() {
    if (initialState != null) {
      return initialState;
    }

    return stateBuilder();
  }

  @protected
  void setState(S candidateState) {
    var nextState =
        notifyDelegateBlocStateWillChange(currentState, candidateState);

    nextState ??= candidateState;
    dispatchState(nextState);
    notifyDelegateBlocStateDidChange(nextState, currentState);
  }

  @protected
  void dispatchState(S state) => stateController.sink.add(state);

  @protected
  S notifyDelegateBlocStateWillChange(S currentState, S nextState) {
    if (delegate != null && delegate.blocStateWillChange is Function) {
      return delegate.blocStateWillChange<Bloc, S>(
        this,
        BlocStateTransitionStart(
          currentState: currentState,
          nextState: nextState,
        ),
      );
    }

    return null;
  }

  @protected
  void notifyDelegateBlocStateDidChange(S currentState, S previousState) {
    if (delegate != null && delegate.blocStateDidChange is Function) {
      delegate.blocStateDidChange<Bloc, S>(
        this,
        BlocStateTransitionEnd(
          currentState: currentState,
          previousState: previousState,
        ),
      );
    }
  }

  @protected
  void handleError(Exception error) {
    if (delegate != null && delegate.blocDidCatchError is Function) {
      delegate.blocDidCatchError<Bloc, S>(this, error, currentState);
    }
  }
}

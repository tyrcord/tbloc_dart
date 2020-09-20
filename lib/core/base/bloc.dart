import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:subx/subx.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

abstract class Bloc<S extends BlocState> {
  @protected
  final BehaviorSubject<S> stateController = BehaviorSubject<S>();
  @protected
  final PublishSubject<BlocError> errorController = PublishSubject<BlocError>();
  @protected
  final BlocStateBuilder<S> initialStateBuilder;
  @protected
  final S initialState;
  @protected
  final SubxList subxList = SubxList();
  @protected
  bool isInitializing = false;
  @protected
  bool get isInitialized => _isInitialized;
  @protected
  set isInitialized(bool isInitialized) {
    if (isInitialized) {
      isInitializing = false;
    }

    _isInitialized = isInitialized;
  }

  bool _isInitialized = false;

  S _currentState;

  S get currentState => _currentState;

  Stream<S> get onData => stateController.stream;

  Stream<BlocError> get onError => errorController.stream;

  Bloc({
    this.initialState,
    this.initialStateBuilder,
  }) {
    _currentState = getInitialState();
    subxList.add(stateController.listen((S state) => _currentState = state));
    setState(_currentState);
  }

  S initState() {
    final message = 'A BloC\'s state should be initialized when instancied';
    throw UnimplementedError(message);
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

    if (initialStateBuilder != null) {
      return initialStateBuilder();
    }

    return initState();
  }

  @protected
  void setState(S candidateState) {
    if (candidateState != null) {
      dispatchState(candidateState);
    }
  }

  @protected
  Function(S) get dispatchState {
    if (!stateController.isClosed) {
      return stateController.sink.add;
    }

    return _dispatchState;
  }

  @protected
  BlocError transformError(dynamic error) {
    return BlocError(source: error);
  }

  void _dispatchState(S state) {}
}

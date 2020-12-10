import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:subx/subx.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

///
/// Abstract Bloc which has no notion of events.
///
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
  final List<PublishSubject> throttlers = [];
  @protected
  bool closed = false;
  @protected
  set isInitialized(bool isInitialized) {
    if (isInitialized) {
      isInitializing = false;
    }

    _isInitialized = isInitialized;
  }

  bool _isInitialized = false;

  S _currentState;

  ///
  /// Whether the BloC is closed for dispatching more events.
  ///
  bool get isClosed => closed;

  ///
  /// The current BloC's state.
  ///
  S get currentState => _currentState;

  ///
  /// Called whenever the BloC's state is updated.
  ///
  Stream<S> get onData => stateController.stream.distinct();

  ///
  /// Called whenever the BloC's state is updated.
  ///
  Stream<BlocError> get onError => errorController.stream;

  Bloc({
    this.initialState,
    this.initialStateBuilder,
  }) {
    _currentState = getInitialState();
    subxList.add(stateController.listen((S state) => _currentState = state));
    setState(_currentState);
  }

  ///
  /// Tries to retreive the initial BloC's state.
  ///
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

  ///
  /// Optional callback method to initialize the BloC's state.
  ///
  @protected
  S initState() {
    final message = 'A BloC\'s state should be initialized when instancied';
    throw UnimplementedError(message);
  }

  ///
  /// Set the BloC state.
  ///
  @protected
  void setState(S candidateState) {
    if (candidateState != null) {
      dispatchState(candidateState);
    }
  }

  ///
  /// Notifies the BloC of a new state which triggers `onData`.
  ///
  @protected
  Function(S) get dispatchState {
    if (!stateController.isClosed) {
      return stateController.sink.add;
    }

    return _dispatchState;
  }

  void _dispatchState(S state) {}

  @protected
  BlocError transformError(dynamic error, StackTrace stackTrace) {
    return BlocError(source: error, stackTrace: stackTrace);
  }

  ///
  /// Creates a throttled function that only invokes [function] at most once
  /// per every [duration].
  ///
  /// For example:
  ///
  ///      throttle(() {
  ///          // heavy stuff
  ///      });
  @protected
  Function throttle(
    Function function, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final throttler = PublishSubject<Function>();
    throttlers.add(throttler);

    subxList.add(
      throttler.throttleTime(duration).listen((Function func) => func()),
    );

    return () => throttler.add(function);
  }

  ///
  /// Closes the event and state Streams. This method should be called when
  /// a BloC is no longer needed.
  ///
  @mustCallSuper
  void close() {
    if (!closed) {
      closed = true;
      throttlers.forEach((PublishSubject throttler) => throttler.close());
      stateController.close();
      errorController.close();
      subxList.cancelAll();
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

abstract class BidirectionalBloc<E extends BlocEvent, S extends BlocState>
    extends Bloc<S> {
  @protected
  final PublishSubject<BlocEvent> internalEventController =
      PublishSubject<BlocEvent>();
  @protected
  final PublishSubject<E> externalEventController = PublishSubject<E>();
  @protected
  Stream<S> mapEventToState(E event, S currentState);
  @protected
  Stream<S> onInternalEvent;

  Stream<E> get onEvent => externalEventController.stream;

  Function(BlocEvent) get dispatchEvent {
    if (!internalEventController.isClosed) {
      return internalEventController.sink.add;
    }

    return _dispatchEvent;
  }

  BidirectionalBloc({
    S initialState,
    BlocStateBuilder<S> initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        ) {
    _buildOnInternalEventStream();
    listenToBlocEvents();
  }

  Future<void> reset() async => dispatchEvent(
        BlocEvent(resetWithState: getInitialState()),
      );

  @override
  void dispose() {
    internalEventController.close();
    externalEventController.close();
    errorController.close();
    super.dispose();
  }

  @protected
  void handleError(dynamic error) => errorController.sink.add(error);

  @protected
  void listenToBlocEvents() {
    onInternalEvent
        .handleError((error) => stateController.sink.addError(error))
        .listen((S nextState) => setState(nextState));
  }

  void _buildOnInternalEventStream() {
    onInternalEvent = internalEventController.asyncExpand((BlocEvent event) {
      if (event.resetWithState != null) {
        return Stream.value(event.resetWithState as S);
      }

      if (event is E) {
        externalEventController.sink.add(event);
        final currentState = stateController.value ?? initialState;
        return mapEventToState(event, currentState);
      }

      return Stream.value(currentState);
    }).handleError((dynamic error) {
      handleError(error);
      throw error;
    });
  }

  void _dispatchEvent(BlocEvent event) {}
}

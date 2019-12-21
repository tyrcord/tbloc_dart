import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tbloc_dart/core/base/base.dart';
import 'package:tbloc_dart/core/events/events.dart';
import 'package:tbloc_dart/core/states/states.dart';
import 'package:tbloc_dart/core/types/types.dart';

abstract class BidirectionalBloc<E extends BlocEvent, S extends BlocState>
    extends Bloc<S> {
  @protected
  final PublishSubject<E> eventController = PublishSubject<E>();
  @protected
  final PublishSubject<S> resetController = PublishSubject<S>();

  @protected
  Stream<S> mapEventToState(E event, S currentState);

  BidirectionalBloc({
    S initialState,
    BlocStateBuilder<S> stateBuilder,
  }) : super(
          initialState: initialState,
          stateBuilder: stateBuilder,
        ) {
    eventController.asyncExpand((E event) {
      if (event.shouldResetState) {
        return Stream.value(initialState);
      }

      final currentState = stateController.value ?? initialState;
      return mapEventToState(event, currentState);
    }).listen((S nextState) {
      setState(nextState);
    });
  }

  Function(E) get dispatchEvent {
    if (!eventController.isClosed) {
      return eventController.sink.add;
    }

    return _dispatchEvent;
  }

  void reset();

  @override
  void dispose() {
    eventController.close();
    super.dispose();
  }

  void _dispatchEvent(E event) {}
}

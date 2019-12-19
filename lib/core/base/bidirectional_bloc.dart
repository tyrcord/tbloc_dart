import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tbloc_dart/core/base/base.dart';
import 'package:tbloc_dart/core/events/events.dart';
import 'package:tbloc_dart/core/states/states.dart';
import 'package:tbloc_dart/core/types/types.dart';
import 'bidirectional_bloc_delegate.dart';

abstract class BidirectionalBloc<E extends BlocEvent, S extends BlocState,
    D extends BidirectionalBlocDelegate> extends Bloc<S, D> {
  @protected
  final PublishSubject<E> eventController = PublishSubject<E>();

  Function(E) get dispatchEvent => eventController.sink.add;

  Future<S> mapEventToState(E event, S currentState);

  BidirectionalBloc({
    S initialState,
    BlocStateBuilder<S> stateBuilder,
    D delegate,
  }) : super(
          initialState: initialState,
          stateBuilder: stateBuilder,
          delegate: delegate,
        ) {
    eventController.listen((E event) {
      final currentState = stateController.value ?? initialState;
      notifyDelegateBlocWillProcessEvent(event, currentState);

      mapEventToState(event, currentState).then((S nextState) {
        setState(nextState);
        notifyDelegateBlocDidProcessEvent(event, nextState);
      }).catchError(handleError);
    });
  }

  @override
  void dispose() {
    eventController.close();
    super.dispose();
  }

  @protected
  void notifyDelegateBlocWillProcessEvent(E event, S state) {
    if (delegate != null && delegate.blocWillProcessEvent is Function) {
      delegate.blocWillProcessEvent<BidirectionalBloc, E, S>(
        this,
        event,
        state,
      );
    }
  }

  @protected
  void notifyDelegateBlocDidProcessEvent(E event, S state) {
    if (delegate != null && delegate.blocDidProcessEvent is Function) {
      delegate.blocDidProcessEvent<BidirectionalBloc, E, S>(
        this,
        event,
        state,
      );
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

abstract class BidirectionalBloc<E extends BlocEvent, S extends BlocState>
    extends Bloc<S> {
  @protected
  final PublishSubject<BlocEvent> internalEventController =
      PublishSubject<BlocEvent>();
  @protected
  final PublishSubject<E> externalEventController = PublishSubject<E>();
  @protected
  Stream<S> mapEventToState(E event);
  @protected
  Stream<S> onInternalEvent;

  Stream<E> get onEvent => externalEventController.stream;

  Function(BlocEvent) get dispatchEvent {
    if (!internalEventController.isClosed) {
      return internalEventController.sink.add;
    } else {
      log('[$runtimeType]: try to dispatchEvent on disposed bloc');
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

  @override
  void dispose() {
    internalEventController.close();
    externalEventController.close();
    errorController.close();
    super.dispose();
  }

  @protected
  void listenToBlocEvents() {
    onInternalEvent.listen((S nextState) => setState(nextState));
  }

  void _buildOnInternalEventStream() {
    onInternalEvent = internalEventController.asyncExpand((BlocEvent event) {
      if (event is E) {
        externalEventController.sink.add(event);
        final streamController = StreamController<S>.broadcast();
        final innerSubscription = mapEventToState(event)
            .listen((S state) => streamController.add(state));

        innerSubscription.onDone(() => streamController.close());
        innerSubscription.onError((dynamic error) {
          handleInternalError(error);
          errorController.sink.add(transformError(error));
          streamController.close();
        });

        return streamController.stream.doOnDone(() {
          innerSubscription.cancel();
        });
      }

      return Stream.value(currentState);
    });
  }

  void _dispatchEvent(BlocEvent event) {}

  @protected
  void handleInternalError(dynamic error) {
    if (!errorController.hasListener) {
      log('[$runtimeType]: Internal Bloc error not handled', error: error);
    }
  }

  @protected
  BlocEventCallback<E> throttleEvent(
    BlocEventCallback<E> function,
    Duration duration,
  ) {
    final throttler = PublishSubject<Tuple2<BlocEventCallback<E>, E>>();
    throttlers.add(throttler);

    subxList.add(
      throttler
          .throttleTime(duration)
          .listen((Tuple2<BlocEventCallback<E>, E> tuple) {
        tuple.item1(tuple.item2);
      }),
    );

    return (E event) {
      final tuple = Tuple2<BlocEventCallback<E>, E>(function, event);
      throttler.add(tuple);
    };
  }

  @protected
  void log(String message, {dynamic error, StackTrace stackTrace}) {
    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 4,
        errorMethodCount: 8,
        lineLength: 120,
        colors: false,
        printEmojis: true,
        printTime: false,
      ),
    );

    logger.w(
      message,
      error,
      stackTrace ?? StackTrace.current,
    );
  }
}

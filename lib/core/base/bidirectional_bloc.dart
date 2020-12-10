import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

///
/// Takes a Stream of BlocEvents as input and transforms them into a Stream of
/// BlocStates as output.
///
abstract class BidirectionalBloc<E extends BlocEvent, S extends BlocState>
    extends Bloc<S> {
  @protected
  final PublishSubject<BlocEvent> internalEventController =
      PublishSubject<BlocEvent>();
  @protected
  final PublishSubject<E> externalEventController = PublishSubject<E>();
  @protected
  Stream<S> onInternalEvent;

  ///
  /// Must be implemented when a class extends BidirectionalBloc.
  /// `mapEventToState` is called whenever an event is added and will convert
  /// that event into a new BloC state. It can only yyield zero or one state
  /// for an event.
  ///
  @protected
  Stream<S> mapEventToState(E event);

  ///
  /// Called whenever an event is added to the BloC.
  ///
  Stream<E> get onEvent => externalEventController.stream;

  ///
  /// Notifies the BloC of a new event which triggers `mapEventToState`.
  /// If `dispose` has already been called, any calls to `dispatchEvent`
  /// will be ignored and will not result in any state changes.
  ///
  /// For example:
  ///
  ///     bloc.dispatchEvent(blocEvent);
  Function(BlocEvent) get addEvent {
    // We should use a new Future (() => dispatch) in order to add the task
    // to the end of the event loop.

    if (!isClosed) {
      return internalEventController.sink.add;
    } else if (kDebugMode) {
      log('[$runtimeType]: try to dispatchEvent on disposed bloc');
    }

    return _addEvent;
  }

  void _addEvent(BlocEvent event) {}

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

  ///
  /// Initializes internal event to state logic.
  ///
  void _buildOnInternalEventStream() {
    onInternalEvent = internalEventController.asyncExpand((BlocEvent event) {
      if (event is E) {
        externalEventController.sink.add(event);
        final streamController = StreamController<S>.broadcast();
        final innerSubscription = mapEventToState(event)
            .listen((S state) => streamController.add(state));

        innerSubscription.onDone(() => streamController.close());
        innerSubscription.onError((dynamic error, StackTrace stackTrace) {
          handleInternalError(error);
          errorController.sink.add(transformError(error, stackTrace));
          streamController.close();
        });

        return streamController.stream.doOnDone(() {
          innerSubscription.cancel();
        });
      }

      return Stream.value(currentState);
    });
  }

  ///
  /// Listens to internal events.
  ///
  @protected
  void listenToBlocEvents() {
    onInternalEvent.listen((S nextState) => setState(nextState));
  }

  ///
  /// Handles internal errors.
  ///
  @protected
  void handleInternalError(dynamic error) {
    if (kDebugMode && !errorController.hasListener) {
      log('[$runtimeType]: Internal Bloc error not handled', error: error);
    }
  }

  ///
  /// Creates a throttled function that only invokes [function] at most once
  /// per every [duration].
  ///
  /// For example:
  ///
  ///      throttleEvent((BlocEvent event) {
  ///          // heavy stuff
  ///      });
  @protected
  BlocEventCallback<E> throttleEvent(
    BlocEventCallback<E> function, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
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

  ///
  /// Better logger.
  /// TODO: Should have its own package.
  ///
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

  ///
  /// Closes the event and state Streams. This method should be called when
  /// a BloC is no longer needed.
  ///
  @override
  @mustCallSuper
  void close() {
    if (!closed) {
      super.close();
      internalEventController.close();
      externalEventController.close();
    }
  }
}

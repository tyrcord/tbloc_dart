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
  late StreamSubscription<S> eventSubscriptions;

  ///
  /// Must be implemented when a class extends BidirectionalBloc.
  /// `mapEventToState` is called whenever an event is added and will convert
  /// that event into a new BloC state. It can yield zero, one or several states
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

  // ignore: no-empty-block
  void _addEvent(BlocEvent event) {}

  BidirectionalBloc({
    S? initialState,
    BlocStateBuilder<S>? initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        ) {
    _handleEvents();
  }

  ///
  /// Determines whether a bloc ensures all `events` are processed in
  /// the order in which they are received.
  ///
  @protected
  bool shouldProcessEventInOrder() => true;

  ///
  /// Handles BloC events.
  ///
  void _handleEvents() {
    eventSubscriptions = _transformEvents().listen((S state) {
      setState(state);
    });
  }

  ///
  /// Transforms each event into a sequence of asynchronous events or will
  /// only use the very latest event according to the property
  /// `shouldProcessEventInOrder`.
  ///
  /// By default `asyncExpand` is used to ensure all `events` are processed in
  /// the order in which they are received.
  ///
  /// `switchMap` can be used if you want some scenarios to not complete.
  ///
  Stream<S> _transformEvents() {
    final source = internalEventController.where((_) => !isClosed);

    if (shouldProcessEventInOrder()) {
      return source.asyncExpand(_handleEvent);
    }

    return source.switchMap(_handleEvent);
  }

  ///
  /// Handles an BloC Event.
  ///
  Stream<S> _handleEvent(BlocEvent event) {
    if (event is E) {
      externalEventController.sink.add(event);

      final streamController = StreamController<S>.broadcast();
      final innerSubscription = mapEventToState(event)
          .where((S state) => !isClosed)
          .listen((S nextState) {
        blocState = nextState;
        streamController.add(nextState);
      });

      innerSubscription.onDone(() => streamController.close());
      innerSubscription.onError((dynamic error, StackTrace stackTrace) {
        if (!isClosed) {
          handleInternalError(error);
          var transformedError = transformError(error, stackTrace);

          if (transformedError != null) {
            errorController.sink.add(transformedError);
          }
        }

        streamController.close();
      });

      return streamController.stream.doOnDone(() {
        innerSubscription.cancel();
      });
    }

    return Stream.value(currentState);
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
  ///      final throttled = throttleEvent((BlocEvent event) {
  ///          // heavy stuff
  ///      });
  BlocThrottleEventCallback<E> throttleEvent(
    BlocThrottleEventCallback<E> function, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final throttler = PublishSubject<Tuple2<BlocThrottleEventCallback<E>, E>>();
    publishers.add(throttler);

    subxList.add(
      throttler
          .throttleTime(duration)
          .listen((Tuple2<BlocThrottleEventCallback<E>, E> tuple) {
        tuple.item1(tuple.item2);
      }),
    );

    return (E event) {
      final tuple = Tuple2<BlocThrottleEventCallback<E>, E>(function, event);
      throttler.add(tuple);
    };
  }

  ///
  /// Creates a debounced function that only invokes [function] after a [delay].
  ///
  /// For example:
  ///
  ///      final debounced = debounce((BlocEvent event) {
  ///          // heavy stuff
  ///      });
  BlocDebounceEventCallback<E> debounceEvent(
    BlocDebounceEventCallback<E> function, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    final debouncer = PublishSubject<Tuple2<BlocDebounceEventCallback<E>, E>>();
    publishers.add(debouncer);

    subxList.add(
      debouncer
          .debounceTime(delay)
          .listen((Tuple2<BlocDebounceEventCallback<E>, E> tuple) {
        tuple.item1(tuple.item2);
      }),
    );

    return (E event) {
      final tuple = Tuple2<BlocDebounceEventCallback<E>, E>(function, event);
      debouncer.add(tuple);
    };
  }

  ///
  /// Better logger.
  /// TODO: Should have its own package.
  ///
  @protected
  void log(String message, {dynamic error, StackTrace? stackTrace}) {
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
    if (!closed && canClose()) {
      super.close();

      internalEventController.close();
      externalEventController.close();
      eventSubscriptions.cancel();
    }
  }
}

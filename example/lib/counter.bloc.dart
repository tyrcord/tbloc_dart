import 'package:tbloc_dart/tbloc_dart.dart';

class CounterBloc
    extends BidirectionalBloc<CounterBlocEvent, CounterBlocState> {
  CounterBloc() : super(initialState: CounterBlocState());

  @override
  // ignore: code-metrics
  Stream<CounterBlocState> mapEventToState(CounterBlocEvent event) async* {
    var counter = currentState.counter;

    if (event.type == CounterBlocEventType.increment) {
      yield currentState.copyWith(counter: counter + 1);
    } else if (event.type == CounterBlocEventType.decrement) {
      yield currentState.copyWith(counter: counter > 0 ? counter - 1 : 0);
    } else if (event.type == CounterBlocEventType.reset) {
      yield currentState.copyWith(counter: 0);
    } else if (event.type == CounterBlocEventType.error) {
      throw 'error';
    } else if (event.type == CounterBlocEventType.errorRaised) {
      yield currentState.copyWith(error: 'error');
    }
  }

  @override
  void handleInternalError(error) {
    addEvent(CounterBlocEvent.errorRaised());
  }
}

class CounterBlocState extends BlocState {
  final int counter;

  const CounterBlocState({
    this.counter = 0,
    dynamic error,
  }) : super(error: error);

  @override
  List<Object> get props => [counter];

  @override
  CounterBlocState copyWith({dynamic error, int counter}) {
    return CounterBlocState(counter: counter ?? this.counter, error: error);
  }
}

enum CounterBlocEventType {
  increment,
  decrement,
  reset,
  errorRaised,
  error,
}

class CounterBlocEvent extends BlocEvent<CounterBlocEventType, dynamic> {
  const CounterBlocEvent({CounterBlocEventType type}) : super(type: type);

  CounterBlocEvent.increment() : this(type: CounterBlocEventType.increment);

  CounterBlocEvent.decrement() : this(type: CounterBlocEventType.decrement);

  CounterBlocEvent.error() : this(type: CounterBlocEventType.error);

  CounterBlocEvent.reset() : this(type: CounterBlocEventType.reset);

  CounterBlocEvent.errorRaised() : this(type: CounterBlocEventType.errorRaised);
}

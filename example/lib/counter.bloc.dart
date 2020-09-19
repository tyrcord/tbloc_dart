import 'package:tbloc_dart/tbloc_dart.dart';

class CounterBloc
    extends BidirectionalBloc<CounterBlocEvent, CounterBlocState> {
  CounterBloc() : super(initialState: CounterBlocState());

  @override
  Stream<CounterBlocState> mapEventToState(
    CounterBlocEvent event,
    CounterBlocState currentState,
  ) async* {
    var counter = currentState.counter;

    if (event.payload == CounterBlocEventAction.increment) {
      yield currentState.copyWith(counter: counter + 1);
    } else if (event.payload == CounterBlocEventAction.decrement) {
      yield currentState.copyWith(counter: counter > 0 ? counter - 1 : 0);
    } else if (event.payload == CounterBlocEventAction.reset) {
      yield currentState.copyWith(counter: 0);
    } else if (event.payload == CounterBlocEventAction.error) {
      throw 'error';
    } else if (event.payload == CounterBlocEventAction.errorRaised) {
      yield currentState.copyWith(error: 'error');
    }
  }

  @override
  void handleInternalError(error) {
    dispatchEvent(CounterBlocEvent.errorRaised());
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

enum CounterBlocEventAction {
  increment,
  decrement,
  reset,
  errorRaised,
  error,
}

class CounterBlocEvent extends BlocEvent<CounterBlocEventAction> {
  const CounterBlocEvent({
    CounterBlocEventAction action,
  }) : super(payload: action);

  CounterBlocEvent.increment() : this(action: CounterBlocEventAction.increment);

  CounterBlocEvent.decrement() : this(action: CounterBlocEventAction.decrement);

  CounterBlocEvent.error() : this(action: CounterBlocEventAction.error);

  CounterBlocEvent.reset() : this(action: CounterBlocEventAction.reset);

  CounterBlocEvent.errorRaised()
      : this(action: CounterBlocEventAction.errorRaised);
}

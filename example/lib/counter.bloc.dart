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

    if (event.payload == CounterBlocEventAction.Increment) {
      yield currentState.copyWith(counter: counter + 1);
    } else if (event.payload == CounterBlocEventAction.Decrement) {
      yield currentState.copyWith(counter: counter > 0 ? counter - 1 : 0);
    } else if (event.payload == CounterBlocEventAction.Reset) {
      yield currentState.copyWith(counter: 0);
    } else if (event.payload == CounterBlocEventAction.Error) {
      throw 'error';
    } else if (event.payload == CounterBlocEventAction.ErrorRaised) {
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
  Increment,
  Decrement,
  Reset,
  ErrorRaised,
  Error,
}

class CounterBlocEvent extends BlocEvent<CounterBlocEventAction> {
  const CounterBlocEvent({
    CounterBlocEventAction action,
  }) : super(payload: action);

  CounterBlocEvent.increment() : this(action: CounterBlocEventAction.Increment);

  CounterBlocEvent.decrement() : this(action: CounterBlocEventAction.Decrement);

  CounterBlocEvent.error() : this(action: CounterBlocEventAction.Error);

  CounterBlocEvent.reset() : this(action: CounterBlocEventAction.Reset);

  CounterBlocEvent.errorRaised()
      : this(action: CounterBlocEventAction.ErrorRaised);
}

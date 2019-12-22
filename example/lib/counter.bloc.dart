import 'package:tbloc_dart/tbloc_dart.dart';

class CounterBloc
    extends BidirectionalBloc<CounterBlocEvent, CounterBlocState> {
  CounterBloc() : super(initialState: CounterBlocState());

  @override
  void reset() {
    dispatchEvent(CounterBlocEvent.reset());
  }

  @override
  Stream<CounterBlocState> mapEventToState(
    CounterBlocEvent event,
    CounterBlocState currentState,
  ) async* {
    var counter = currentState.counter;

    if (event.payload == CounterBlocEventAction.increment) {
      yield CounterBlocState(counter: counter + 1);
    } else {
      yield CounterBlocState(counter: counter > 0 ? counter - 1 : 0);
    }
  }
}

class CounterBlocState extends BlocState {
  final int counter;

  const CounterBlocState({
    this.counter = 0,
  }) : super();

  @override
  List<Object> get props => [
        counter,
      ];
}

enum CounterBlocEventAction {
  increment,
  decrement,
}

class CounterBlocEvent extends BlocEvent<CounterBlocEventAction> {
  const CounterBlocEvent({
    CounterBlocEventAction action,
    bool shouldResetState,
  }) : super(
          payload: action,
          shouldResetState: shouldResetState,
        );

  CounterBlocEvent.reset() : this(shouldResetState: true);

  CounterBlocEvent.increment()
      : this(
          action: CounterBlocEventAction.increment,
        );

  CounterBlocEvent.decrement()
      : this(
          action: CounterBlocEventAction.decrement,
        );
}

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
  ) {
    var counter = currentState.counter;

    if (event.payload == CounterAction.increment) {
      return Stream<CounterBlocState>.value(
        CounterBlocState(counter: counter + 1),
      );
    }

    return Stream<CounterBlocState>.value(
      CounterBlocState(counter: counter > 0 ? counter - 1 : 0),
    );
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

enum CounterAction {
  increment,
  decrement,
}

class CounterBlocEvent extends BlocEvent<CounterAction> {
  const CounterBlocEvent({
    CounterAction action,
    bool shouldResetState,
  }) : super(
          payload: action,
          shouldResetState: shouldResetState,
        );

  CounterBlocEvent.reset() : this(shouldResetState: true);
  CounterBlocEvent.increment() : this(action: CounterAction.increment);
  CounterBlocEvent.decrement() : this(action: CounterAction.decrement);
}

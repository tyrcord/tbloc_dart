import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_state.mock.dart';

class UnidirectionalPeopleBloc extends UnidirectionalBloc<PeopleBlocState> {
  UnidirectionalPeopleBloc({
    PeopleBlocState initialState,
    BlocStateBuilder<PeopleBlocState> initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );

  void put(PeopleBlocState state) {
    setState(state);
  }

  Function putThrottle(Function function) => throttle(function);
}

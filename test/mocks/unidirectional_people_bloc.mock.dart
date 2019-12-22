import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_state.mock.dart';

class UnidirectionalPeopleBloc extends UnidirectionalBloc<PeopleBlocState> {
  UnidirectionalPeopleBloc({
    PeopleBlocState initialState,
    BlocStateBuilder<PeopleBlocState> builder,
  }) : super(
          initialState: initialState,
          stateBuilder: builder,
        );

  void put(PeopleBlocState state) {
    setState(state);
  }
}

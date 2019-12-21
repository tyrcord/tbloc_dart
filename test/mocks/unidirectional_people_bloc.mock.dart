import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_state.mock.dart';

class UnidirectionalPeopleBloc extends UnidirectionalBloc<PeopleBlocState> {
  UnidirectionalPeopleBloc(PeopleBlocState initialState)
      : super(initialState: initialState);

  void put(PeopleBlocState state) {
    setState(state);
  }
}

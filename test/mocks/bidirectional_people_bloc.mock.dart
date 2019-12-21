import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_event.mock.dart';
import 'people_bloc_state.mock.dart';

class BidirectionalPeopleBloc
    extends BidirectionalBloc<PeopleBlocEvent, PeopleBlocState> {
  BidirectionalPeopleBloc(PeopleBlocState initialState)
      : super(initialState: initialState);

  @override
  Stream<PeopleBlocState> mapEventToState(
    PeopleBlocEvent event,
    PeopleBlocState currentState,
  ) async* {
    yield currentState.copyWithPayload(event.payload);
  }

  @override
  void reset() {
    dispatchEvent(PeopleBlocEvent(shouldResetState: true));
  }
}

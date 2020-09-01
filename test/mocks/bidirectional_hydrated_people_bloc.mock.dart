import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_event.mock.dart';
import 'people_bloc_state.mock.dart';
import 'people_bloc_store.mock.dart';

class BidirectionalHydratedPeopleBloc
    extends BidirectionalHydratedBloc<PeopleBlocEvent, PeopleBlocState> {
  BidirectionalHydratedPeopleBloc({
    PeopleBlocState initialState,
    BlocStateBuilder<PeopleBlocState> initialStateBuilder,
  }) : super(
          store: PeopleBlocStore(),
          persitenceKey: 'people_bloc',
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );

  @override
  Stream<PeopleBlocState> mapEventToState(
    PeopleBlocEvent event,
    PeopleBlocState currentState,
  ) async* {
    yield currentState.copyWithPayload(event.payload);
  }

  Future<PeopleBlocState> getLastPersistedState() {
    return this.store.retrieve(persitenceKey);
  }
}

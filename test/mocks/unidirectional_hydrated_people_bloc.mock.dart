import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_state.mock.dart';
import 'people_bloc_store.mock.dart';

class UnidirectionalHydratedPeopleBloc
    extends UnidirectionalHydratedBloc<PeopleBlocState> {
  UnidirectionalHydratedPeopleBloc({
    PeopleBlocState? initialState,
    BlocStateBuilder<PeopleBlocState>? initialStateBuilder,
  }) : super(
          store: PeopleBlocStore(),
          persitenceKey: 'uni_people_bloc',
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );

  Future<PeopleBlocState?> getLastPersistedState() {
    return store.retrieve(persitenceKey);
  }

  Future<void> put(PeopleBlocState state) async {
    await store.persist(persitenceKey, state);
    setState(state);
  }
}

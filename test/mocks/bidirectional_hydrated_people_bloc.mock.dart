import 'package:tbloc_dart/core/base/bidirectional_hydrated_bloc.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_event.mock.dart';
import 'people_bloc_state.mock.dart';

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

class PeopleBlocStore implements BlocStore<PeopleBlocState> {
  final _storage = Map<String, PeopleBlocState>();

  @override
  Future<void> clear() async => _storage.clear();

  @override
  Future<PeopleBlocState> persist(String key, PeopleBlocState value) async {
    if (!_storage.containsKey(key)) {
      return _storage.putIfAbsent(key, () => value);
    }

    return _storage.update(key, (_) => value);
  }

  @override
  Future<PeopleBlocState> retrieve(String key) async => _storage[key];

  @override
  Future<PeopleBlocState> delete(String key) async => _storage.remove(key);
}

import 'package:meta/meta.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

mixin HydratedBlocMixin<S extends HydratedBlocState> on Bloc<S> {
  @protected
  BlocStore<S> store;
  @protected
  String persitenceKey;
  @protected
  bool isBlocHydrated = false;

  Future<void> hydrate() async {
    if (!isBlocHydrated) {
      final candidateState =
          await store.retrieve(persitenceKey) ?? currentState;
      setState(candidateState.copyWith(hydrated: true) as S);
      isBlocHydrated = true;
    }
  }

  Future<void> reset() async {
    final candidateState = getInitialState();
    setState(candidateState.copyWith(hydrated: true) as S);
    await store.persist(persitenceKey, currentState);
  }
}

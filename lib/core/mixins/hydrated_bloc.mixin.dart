import 'package:meta/meta.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

mixin HydratedBlocMixin<S extends HydratedBlocState> on Bloc<S> {
  @protected
  late BlocStore<S> store;
  @protected
  late String persitenceKey;
  @protected
  bool isBlocHydrated = false;

  // Save the internal state to the store with the latest state.
  Future<void> hydrate() async {
    if (!isBlocHydrated) {
      final candidateState =
          await store.retrieve(persitenceKey) ?? currentState;

      setState(candidateState.copyWith(hydrated: true) as S);
      isBlocHydrated = true;
    }
  }
}

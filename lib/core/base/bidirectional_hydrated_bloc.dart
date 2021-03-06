import 'package:meta/meta.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

///
/// Takes a Stream of BlocEvents as input and transforms them into a Stream of
/// BlocStates as output.
///
abstract class BidirectionalHydratedBloc<E extends BlocEvent,
        S extends HydratedBlocState> extends BidirectionalBloc<E, S>
    with HydratedBlocMixin<S> {
  @override
  @protected
  final BlocStore<S> store;

  @override
  @protected
  final String persitenceKey;

  @override
  @protected
  bool isBlocHydrated = false;

  @override
  Function(BlocEvent) get addEvent {
    assert(isBlocHydrated);

    return super.addEvent;
  }

  BidirectionalHydratedBloc({
    required this.store,
    required this.persitenceKey,
    S? initialState,
    BlocStateBuilder<S>? initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        ) {
    subxList.add(onData.listen((S state) {
      Stream.fromFuture(store.persist(persitenceKey, state));
    }));
  }
}

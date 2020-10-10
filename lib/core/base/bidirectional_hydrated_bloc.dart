import 'package:meta/meta.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

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
  Function(BlocEvent) get dispatchEvent {
    assert(isBlocHydrated);
    return super.dispatchEvent;
  }

  BidirectionalHydratedBloc({
    @required this.store,
    @required this.persitenceKey,
    S initialState,
    BlocStateBuilder<S> initialStateBuilder,
  })  : assert(store != null),
        assert(persitenceKey != null),
        super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );

  @override
  @protected
  void listenToBlocEvents() {
    onInternalEvent.asyncExpand((S nextState) {
      return Stream.fromFuture(store.persist(persitenceKey, nextState));
    }).listen((S nextState) => setState(nextState));
  }
}

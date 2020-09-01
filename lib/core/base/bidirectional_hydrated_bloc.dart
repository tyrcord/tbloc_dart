import 'package:meta/meta.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

abstract class BidirectionalHydratedBloc<E extends BlocEvent,
        S extends HydratedBlocState> extends BidirectionalBloc<E, S>
    with HydratedBlocMixin<S> {
  @protected
  final BlocStore<S> store;
  @protected
  final String persitenceKey;
  @protected
  bool isBlocHydrated = false;

  Function(BlocEvent) get dispatchEvent {
    assert(isBlocHydrated);
    return super.dispatchEvent;
  }

  BidirectionalHydratedBloc({
    @required this.store,
    @required this.persitenceKey,
    S initialState,
    BlocStateBuilder<S> initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );

  @override
  Future<void> reset() async {
    final candidateState = getInitialState().copyWith(hydrated: true) as S;
    dispatchEvent(BlocEvent(resetWithState: candidateState));
  }

  @override
  @protected
  void listenToBlocEvents() {
    onInternalEvent.asyncExpand((S nextState) {
      return Stream.fromFuture(store.persist(persitenceKey, nextState));
    }).listen((S nextState) => setState(nextState));
  }
}

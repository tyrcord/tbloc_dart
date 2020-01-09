import 'package:meta/meta.dart';

import 'package:tbloc_dart/core/interfaces/interfaces.dart';
import 'package:tbloc_dart/core/mixins/hydrated_bloc.mixin.dart';
import 'package:tbloc_dart/core/states/states.dart';
import 'package:tbloc_dart/core/types/types.dart';
import 'unidirectional_bloc.dart';

abstract class UnidirectionalHydratedBloc<S extends HydratedBlocState>
    extends UnidirectionalBloc<S> with HydratedBlocMixin<S> {
  @protected
  final BlocStore<S> store;
  @protected
  final String persitenceKey;

  UnidirectionalHydratedBloc({
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
    setState(candidateState);
    await store.persist(persitenceKey, candidateState);
  }
}

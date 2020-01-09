import 'package:meta/meta.dart';
import 'package:tbloc_dart/core/base/base.dart';
import 'package:tbloc_dart/core/interfaces/interfaces.dart';
import 'package:tbloc_dart/core/states/states.dart';

mixin HydratedBlocMixin<S extends HydratedBlocState> on Bloc<S> {
  @protected
  BlocStore<S> store;
  @protected
  String persitenceKey;

  Future<void> hydrate() async {
    final candidateState = await store.retrieve(persitenceKey) ?? currentState;
    setState(candidateState.copyWith(hydrated: true) as S);
  }

  Future<void> reset() async {
    final candidateState = getInitialState();
    setState(candidateState.copyWith(hydrated: true) as S);
    await store.persist(persitenceKey, currentState);
  }
}

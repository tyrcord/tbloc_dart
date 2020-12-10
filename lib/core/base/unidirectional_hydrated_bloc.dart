import 'package:meta/meta.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

///
/// A UnidirectionalHydratedBloc is a subset of Bloc which has no notion of
/// events and relies on methods to emit new states.
///
abstract class UnidirectionalHydratedBloc<S extends HydratedBlocState>
    extends UnidirectionalBloc<S> with HydratedBlocMixin<S> {
  @override
  @protected
  final BlocStore<S> store;

  @override
  @protected
  final String persitenceKey;

  UnidirectionalHydratedBloc({
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
}

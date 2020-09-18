import 'package:meta/meta.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

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
  })  : assert(store != null),
        assert(persitenceKey != null),
        super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );
}

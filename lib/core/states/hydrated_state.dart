import 'bloc_state.dart';

abstract class HydratedBlocState extends BlocState {
  final bool hydrated;

  const HydratedBlocState({
    bool hydrated,
    dynamic error,
  })  : hydrated = hydrated ?? false,
        super(error: error);

  BlocState copyWith({bool hydrated});
}

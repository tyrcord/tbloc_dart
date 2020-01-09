import 'bloc_state.dart';

abstract class HydratedBlocState extends BlocState {
  final bool hydrated;

  const HydratedBlocState({
    bool hydrated,
  }) : hydrated = hydrated ?? false;

  BlocState copyWith({
    bool hydrated,
  });
}

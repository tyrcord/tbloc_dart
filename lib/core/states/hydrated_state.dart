import 'bloc_state.dart';

abstract class HydratedBlocState extends BlocState {
  final bool hydrated;

  const HydratedBlocState({
    bool hydrated,
    dynamic exception,
  })  : hydrated = hydrated ?? false,
        super(exception: exception);

  BlocState copyWith({
    bool hydrated,
  });
}

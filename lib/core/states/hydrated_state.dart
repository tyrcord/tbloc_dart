import 'bloc_state.dart';

abstract class HydratedBlocState extends BlocState {
  final bool hydrated;

  const HydratedBlocState({
    bool isInitializing,
    bool isInitialized,
    bool hydrated,
    dynamic error,
  })  : this.hydrated = hydrated ?? false,
        super(
          isInitializing: isInitializing,
          isInitialized: isInitialized,
          error: error,
        );

  BlocState copyWith({bool hydrated});
}

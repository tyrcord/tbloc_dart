import 'bloc_state.dart';

abstract class HydratedBlocState extends BlocState {
  final bool hydrated;

  const HydratedBlocState({
    bool isInitializing = false,
    bool isInitialized = false,
    this.hydrated = false,
    dynamic? error,
  }) : super(
          error: error,
          isInitializing: isInitializing,
          isInitialized: isInitialized,
        );

  @override
  BlocState copyWith({bool? hydrated});
}

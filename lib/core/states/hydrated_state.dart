import 'bloc_state.dart';

abstract class HydratedBlocState extends BlocState {
  @override
  final bool isInitializing;
  @override
  final bool isInitialized;
  final bool hydrated;

  const HydratedBlocState({
    this.isInitializing = false,
    this.isInitialized = false,
    this.hydrated = false,
    dynamic? error,
  }) : super(error: error);

  @override
  BlocState copyWith({bool? hydrated});
}

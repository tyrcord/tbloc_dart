import 'package:equatable/equatable.dart';

abstract class BlocState extends Equatable {
  final dynamic error;
  final bool isInitializing;
  final bool isInitialized;

  bool get hasError => error != null;

  const BlocState({
    bool isInitializing,
    bool isInitialized,
    this.error,
  })  : this.isInitializing = isInitializing ?? false,
        this.isInitialized = isInitialized ?? false;

  BlocState copyWith();
}

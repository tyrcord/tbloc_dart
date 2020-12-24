import 'package:tmodel_dart/logic/core/core.dart';

abstract class BlocState extends TModel {
  final dynamic error;
  final bool isInitializing;
  final bool isInitialized;

  bool get hasError => error != null;

  const BlocState({
    bool isInitializing,
    bool isInitialized,
    this.error,
  })  : isInitializing = isInitializing ?? false,
        isInitialized = isInitialized ?? false;
}

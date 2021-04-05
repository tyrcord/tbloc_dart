import 'package:tmodel_dart/logic/core/core.dart';

abstract class BlocState extends TModel {
  final bool isInitializing;
  final bool isInitialized;
  final dynamic? error;

  bool get hasError => error != null;

  const BlocState({
    this.isInitializing = false,
    this.isInitialized = false,
    this.error,
  });
}

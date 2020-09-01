import 'package:equatable/equatable.dart';

abstract class BlocState extends Equatable {
  final dynamic error;

  bool get hasError => error != null;

  const BlocState({this.error});
}

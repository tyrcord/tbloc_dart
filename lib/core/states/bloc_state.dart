import 'package:equatable/equatable.dart';

abstract class BlocState extends Equatable {
  final dynamic exception;

  bool get hasException => exception != null;

  const BlocState({this.exception});
}

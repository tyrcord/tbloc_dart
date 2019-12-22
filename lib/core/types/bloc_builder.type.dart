import 'package:flutter/widgets.dart';
import 'package:tbloc_dart/core/states/states.dart';

typedef BlocBuilder<S extends BlocState> = Widget Function(
  BuildContext context,
  S state,
);

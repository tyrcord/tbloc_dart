import 'package:flutter/widgets.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

typedef BlocBuilder<S extends BlocState> = Widget Function(
  BuildContext context,
  S state,
);

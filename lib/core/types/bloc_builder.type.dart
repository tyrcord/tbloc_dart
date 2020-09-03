import 'package:flutter/widgets.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

typedef BlocBuilder<S extends BlocState> = Widget Function(
  BuildContext context,
  S state,
);

typedef BlocBuilder2<S1 extends BlocState, S2 extends BlocState> = Widget
    Function(BuildContext context, S1 state, S2 state2);

typedef BlocBuilder3<S1 extends BlocState, S2 extends BlocState,
        S3 extends BlocState>
    = Widget Function(BuildContext context, S1 state, S2 state2, S3 state3);

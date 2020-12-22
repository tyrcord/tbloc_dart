import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

///
/// Handles building a widget when three BloC states change.
///
class BlocBuilderWidget3<S1 extends BlocState, S2 extends BlocState,
    S3 extends BlocState> extends StatefulWidget {
  final BlocBuilder3<S1, S2, S3> builder;
  final Bloc<S1> bloc1;
  final Bloc<S2> bloc2;
  final Bloc<S3> bloc3;

  const BlocBuilderWidget3({
    Key key,
    @required this.builder,
    @required this.bloc1,
    @required this.bloc2,
    @required this.bloc3,
  })  : assert(builder != null),
        assert(bloc1 != null),
        assert(bloc2 != null),
        assert(bloc3 != null),
        super(key: key);

  @override
  _BlocBuilderWidget3State<S1, S2, S3> createState() =>
      _BlocBuilderWidget3State<S1, S2, S3>();
}

class _BlocBuilderWidget3State<S1 extends BlocState, S2 extends BlocState,
    S3 extends BlocState> extends State<BlocBuilderWidget3<S1, S2, S3>> {
  Stream<List<BlocState>> _stream;

  @override
  void initState() {
    super.initState();
    _buildStream();
  }

  @override
  void didUpdateWidget(BlocBuilderWidget3<S1, S2, S3> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bloc1 != widget.bloc1 ||
        oldWidget.bloc2 != widget.bloc2 ||
        oldWidget.bloc3 != widget.bloc3) {
      _buildStream();
    }
  }

  @override
  // ignore: code-metrics
  Widget build(BuildContext context) {
    return StreamBuilder<List<BlocState>>(
      stream: _stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<BlocState>> snapshot,
      ) {
        final data = snapshot.data;
        final state1 = data != null ? data[0] as S1 : null;
        final state2 = data != null ? data[1] as S2 : null;
        final state3 = data != null ? data[2] as S3 : null;

        return widget.builder(
          context,
          state1 ?? widget.bloc1.currentState,
          state2 ?? widget.bloc2.currentState,
          state3 ?? widget.bloc3.currentState,
        );
      },
    );
  }

  void _buildStream() {
    _stream = CombineLatestStream.combine3<S1, S2, S3, List<BlocState>>(
      widget.bloc1.onData,
      widget.bloc2.onData,
      widget.bloc3.onData,
      (S1 a, S2 b, S3 c) => [a, b, c],
    );
  }
}

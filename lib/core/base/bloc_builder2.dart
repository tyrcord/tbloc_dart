import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

class BlocBuilderWidget2<S1 extends BlocState, S2 extends BlocState>
    extends StatefulWidget {
  final BlocBuilder2<S1, S2> builder;
  final Bloc<S1> bloc1;
  final Bloc<S2> bloc2;

  const BlocBuilderWidget2({
    Key key,
    @required this.builder,
    @required this.bloc1,
    @required this.bloc2,
  })  : assert(builder != null),
        assert(bloc1 != null),
        assert(bloc2 != null),
        super(key: key);

  @override
  _BlocBuilderWidget2State<S1, S2> createState() =>
      _BlocBuilderWidget2State<S1, S2>();
}

class _BlocBuilderWidget2State<S1 extends BlocState, S2 extends BlocState>
    extends State<BlocBuilderWidget2<S1, S2>> {
  Stream<List<BlocState>> _stream;

  @override
  void initState() {
    super.initState();
    _buildStream();
  }

  @override
  void didUpdateWidget(BlocBuilderWidget2<S1, S2> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bloc1 != widget.bloc1 || oldWidget.bloc1 != widget.bloc2) {
      _buildStream();
    }
  }

  @override
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

        return widget.builder(
          context,
          state1 ?? widget.bloc1.currentState,
          state2 ?? widget.bloc2.currentState,
        );
      },
    );
  }

  void _buildStream() {
    _stream = CombineLatestStream.combine2<S1, S2, List<BlocState>>(
      widget.bloc1.onData,
      widget.bloc2.onData,
      (S1 a, S2 b) => [a, b],
    );
  }
}

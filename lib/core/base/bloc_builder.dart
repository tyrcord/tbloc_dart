import 'package:flutter/widgets.dart';

import 'package:tbloc_dart/core/states/states.dart';
import 'package:tbloc_dart/core/types/types.dart';
import 'bloc.dart';

class BlocBuilderWidget<S extends BlocState> extends StatelessWidget {
  final BlocBuilder<S> builder;
  final Bloc<S> bloc;

  const BlocBuilderWidget({
    Key key,
    @required this.builder,
    @required this.bloc,
  })  : assert(builder != null),
        assert(bloc != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      stream: bloc.stream,
      initialData: bloc.currentState,
      builder: (
        BuildContext context,
        AsyncSnapshot<S> snapshot,
      ) {
        return builder(context, snapshot.data);
      },
    );
  }
}
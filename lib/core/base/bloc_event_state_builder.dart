import 'package:flutter/widgets.dart';

import 'package:tbloc_dart/core/states/states.dart';
import 'unidirectional_bloc.dart';

typedef UnidirectionalBlocBuilder<S extends BlocState> = Widget Function(
  BuildContext context,
  S state,
);

class UnidirectionalBlocWidget<S extends BlocState> extends StatelessWidget {
  final UnidirectionalBlocBuilder<S> builder;
  final UnidirectionalBloc<S> bloc;

  const UnidirectionalBlocWidget({
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

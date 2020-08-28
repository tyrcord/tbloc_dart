import 'package:flutter/widgets.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

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
      stream: bloc.onData,
      builder: (
        BuildContext context,
        AsyncSnapshot<S> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.active) {
          return builder(
            context,
            snapshot.data ?? bloc.currentState,
            snapshot.error,
          );
        }

        return Container();
      },
    );
  }
}

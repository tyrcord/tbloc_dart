import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'package:tbloc_dart/core/states/bloc_state.dart';
import 'bloc.dart';

class BlocProvider<T extends Bloc<S>, S extends BlocState>
    extends StatefulWidget {
  final Widget child;
  final T bloc;

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  @override
  _BlocProviderState<T, S> createState() => _BlocProviderState<T, S>();

  static T of<T extends Bloc>(BuildContext context) {
    final provider = context
        .getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>()
        ?.widget as _BlocProviderInherited<T>;
    return provider?.bloc;
  }
}

class _BlocProviderState<T extends Bloc<S>, S extends BlocState>
    extends State<BlocProvider<T, S>> {
  @override
  void dispose() {
    widget.bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited<T>(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  final T bloc;

  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}

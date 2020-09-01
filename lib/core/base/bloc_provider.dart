import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

mixin BlocProviderSingleChildWidget on SingleChildWidget {}

class BlocProvider<T extends Bloc<S>, S extends BlocState>
    extends SingleChildStatelessWidget with BlocProviderSingleChildWidget {
  final Dispose<T> _dispose;
  final Create<T> _create;
  final bool _lazy;

  BlocProvider({
    Key key,
    @required T bloc,
    Widget child,
  }) : this._(
          key: key,
          create: (_) => bloc,
          dispose: (_, bloc) => bloc?.dispose(),
          child: child,
        );

  BlocProvider.lazy({
    Key key,
    @required Create<T> create,
    Widget child,
  }) : this._(
          key: key,
          create: create,
          dispose: (_, bloc) => bloc?.dispose(),
          child: child,
        );

  BlocProvider._({
    Key key,
    Widget child,
    Dispose<T> dispose,
    Create<T> create,
    bool lazy = true,
  })  : _create = create,
        _dispose = dispose,
        _lazy = lazy,
        super(key: key, child: child);

  static T of<T extends Bloc>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return InheritedProvider<T>(
      create: _create,
      dispose: _dispose,
      child: child,
      lazy: _lazy,
    );
  }
}

extension BlocProviderExtension on BuildContext {
  B bloc<B extends Bloc>() => BlocProvider.of<B>(this);
}

import 'package:tbloc_dart/core/base/base.dart';
import 'package:tbloc_dart/core/models/models.dart';
import 'package:tbloc_dart/core/states/states.dart';

abstract class BlocDelegate {
  S blocStateWillChange<B extends Bloc, S extends BlocState>(
    B bloc,
    BlocStateTransitionStart<S> transition,
  );

  void blocStateDidChange<B extends Bloc, S extends BlocState>(
    B bloc,
    BlocStateTransitionEnd<S> transition,
  );

  void blocDidCatchError<B extends Bloc, S extends BlocState>(
    B bloc,
    Exception error,
    S currentState,
  );
}

import 'package:tbloc_dart/core/base/bloc_delegate.dart';
import 'package:tbloc_dart/core/events/events.dart';
import 'package:tbloc_dart/core/states/states.dart';
import 'bloc.dart';

abstract class BidirectionalBlocDelegate extends BlocDelegate {
  void blocWillProcessEvent<B extends Bloc, E extends BlocEvent,
      S extends BlocState>(
    B bloc,
    E event,
    S state,
  );

  void blocDidProcessEvent<B extends Bloc, E extends BlocEvent,
      S extends BlocState>(
    B bloc,
    E event,
    S state,
  );
}

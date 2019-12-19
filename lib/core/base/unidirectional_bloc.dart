import 'package:tbloc_dart/core/base/base.dart';
import 'package:tbloc_dart/core/states/states.dart';
import 'bloc_delegate.dart';

abstract class UnidirectionalBloc<S extends BlocState>
    extends Bloc<S, BlocDelegate> {}

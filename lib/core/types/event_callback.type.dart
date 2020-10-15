import 'package:tbloc_dart/tbloc_dart.dart';

typedef BlocEventCallback<E extends BlocEvent> = void Function(E event);

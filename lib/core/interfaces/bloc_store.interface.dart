import 'package:tbloc_dart/tbloc_dart.dart';

abstract class BlocStore<S extends BlocState> {
  Future<S> retrieve(String key);
  Future<S> persist(String key, S value);
  Future<S> delete(String key);
  Future<void> clear();
}

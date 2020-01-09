import 'package:tbloc_dart/core/states/bloc_state.dart';

abstract class BlocStore<S extends BlocState> {
  Future<S> retrieve(String key);
  Future<S> persist(String key, S value);
  Future<S> delete(String key);
  Future<void> clear();
}

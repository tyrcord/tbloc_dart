import 'package:tbloc_dart/tbloc_dart.dart';

///
/// Interface which is used to persist and retrieve state changes.
///
abstract class BlocStore<S extends BlocState> {
  ///
  /// Retreives value for key.
  ///
  Future<S> retrieve(String key);

  ///
  /// Persists key value pair.
  ///
  Future<S> persist(String key, S value);

  ///
  /// Deletes key value pair.
  ///
  Future<S> delete(String key);

  ///
  /// Clears all key value pairs from the store.
  ///
  Future<void> clear();
}

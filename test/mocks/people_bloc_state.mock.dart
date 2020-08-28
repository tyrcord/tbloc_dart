import 'package:meta/meta.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_event.mock.dart';

@immutable
class PeopleBlocState extends HydratedBlocState {
  final String firstname;
  final String lastname;
  final int age;

  PeopleBlocState({
    this.firstname,
    this.lastname,
    this.age,
    bool hydrated,
    dynamic exception,
  }) : super(hydrated: hydrated, exception: exception);

  PeopleBlocState copyWithPayload(PeopleBlocEventPayload payload) {
    return copyWith(
      firstname: payload.firstname,
      lastname: payload.lastname,
      age: payload.age,
    );
  }

  @override
  PeopleBlocState copyWith({
    String firstname,
    String lastname,
    int age,
    bool hydrated,
    dynamic exception,
  }) {
    return PeopleBlocState(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      age: age ?? this.age,
      hydrated: hydrated ?? this.hydrated,
      exception: exception,
    );
  }

  @override
  String toString() {
    return 'firstname: $firstname; '
        'lastname: $lastname; '
        'age: $age';
  }

  @override
  List<Object> get props => [
        firstname,
        lastname,
        age,
      ];
}

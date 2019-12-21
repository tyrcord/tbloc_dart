import 'package:meta/meta.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_event.mock.dart';

@immutable
class PeopleBlocState extends BlocState {
  final String firstname;
  final String lastname;
  final int age;

  PeopleBlocState({
    this.firstname,
    this.lastname,
    this.age,
  });

  PeopleBlocState copyWithPayload(PeopleBlocEventPayload payload) {
    return copyWith(
      firstname: payload.firstname,
      lastname: payload.lastname,
      age: payload.age,
    );
  }

  PeopleBlocState copyWith({
    String firstname,
    String lastname,
    int age,
  }) {
    return PeopleBlocState(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      age: age ?? this.age,
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

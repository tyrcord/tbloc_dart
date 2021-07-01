import 'package:meta/meta.dart';

import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_event.mock.dart';

@immutable
class PeopleBlocState extends HydratedBlocState {
  final String? firstname;
  final String? lastname;
  final bool? isMarrying;
  final bool isSingle;
  @override
  final bool hydrated;
  final int? age;

  PeopleBlocState({
    this.hydrated = false,
    this.isSingle = true,
    dynamic exception,
    this.isMarrying,
    this.firstname,
    this.lastname,
    this.age,
  }) : super(hydrated: hydrated, error: exception);

  PeopleBlocState copyWithPayload(PeopleBlocEventPayload payload) {
    return copyWith(
      firstname: payload.firstname,
      lastname: payload.lastname,
      age: payload.age,
      isMarrying: payload.isMarrying,
      isSingle: payload.isSingle,
    );
  }

  @override
  PeopleBlocState copyWith({
    String? firstname,
    String? lastname,
    int? age,
    bool? hydrated,
    dynamic exception,
    bool? isSingle,
    bool? isMarrying,
  }) {
    return PeopleBlocState(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      age: age ?? this.age,
      hydrated: hydrated ?? this.hydrated,
      isMarrying: isMarrying ?? this.isMarrying,
      isSingle: isSingle ?? this.isSingle,
      exception: exception,
    );
  }

  @override
  String toString() {
    return 'firstname: $firstname; '
        'lastname: $lastname; '
        'age: $age'
        'isMarrying: $isMarrying; '
        'isSingle: $isSingle';
  }

  @override
  List<Object?> get props => [
        firstname,
        lastname,
        age,
        isMarrying,
        isSingle,
      ];

  @override
  PeopleBlocState clone() => this;

  @override
  PeopleBlocState merge(covariant PeopleBlocState state) => this;
}

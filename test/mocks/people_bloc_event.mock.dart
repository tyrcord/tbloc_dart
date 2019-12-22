import 'package:tbloc_dart/tbloc_dart.dart';

class PeopleBlocEventPayload {
  final String firstname;
  final String lastname;
  final int age;

  PeopleBlocEventPayload({
    this.firstname,
    this.lastname,
    this.age,
  });
}

class PeopleBlocEvent extends BlocEvent<PeopleBlocEventPayload> {
  PeopleBlocEvent({
    PeopleBlocEventPayload payload,
    Object error,
  }) : super(
          payload: payload,
          error: error,
        );

  PeopleBlocEvent.error() : this(error: 'error');
}

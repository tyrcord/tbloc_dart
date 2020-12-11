import 'package:tbloc_dart/tbloc_dart.dart';

enum PeopleBlocEventPayloadType {
  updateInformation,
  married,
  marry,
  error,
  multiple,
}

class PeopleBlocEventPayload {
  final String firstname;
  final String lastname;
  final bool isSingle;
  final bool isMarrying;
  final int age;

  PeopleBlocEventPayload({
    this.firstname,
    this.lastname,
    this.isSingle,
    this.isMarrying,
    this.age,
  });
}

class PeopleBlocEvent
    extends BlocEvent<PeopleBlocEventPayloadType, PeopleBlocEventPayload> {
  PeopleBlocEvent.error()
      : super(
          type: PeopleBlocEventPayloadType.error,
          error: 'error',
        );

  PeopleBlocEvent.married({PeopleBlocEventPayload payload})
      : super(
          type: PeopleBlocEventPayloadType.married,
          payload: payload,
        );

  PeopleBlocEvent.updateInformation({PeopleBlocEventPayload payload})
      : super(
          type: PeopleBlocEventPayloadType.updateInformation,
          payload: payload,
        );

  PeopleBlocEvent.marrySomeone()
      : super(type: PeopleBlocEventPayloadType.marry);

  PeopleBlocEvent.updateMultipleInformation()
      : super(type: PeopleBlocEventPayloadType.multiple);
}

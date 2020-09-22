import 'package:tbloc_dart/tbloc_dart.dart';

import 'people_bloc_event.mock.dart';
import 'people_bloc_state.mock.dart';

class BidirectionalPeopleBloc
    extends BidirectionalBloc<PeopleBlocEvent, PeopleBlocState> {
  BidirectionalPeopleBloc({
    PeopleBlocState initialState,
    BlocStateBuilder<PeopleBlocState> initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );

  @override
  Stream<PeopleBlocState> mapEventToState(PeopleBlocEvent event) async* {
    if (event.type == PeopleBlocEventPayloadType.error) {
      throw event.error;
    } else if (event.type == PeopleBlocEventPayloadType.updateInformation) {
      yield currentState.copyWithPayload(event.payload);
    } else if (event.type == PeopleBlocEventPayloadType.marry) {
      yield currentState.copyWith(isMarrying: true);
      await Future.delayed(Duration(milliseconds: 300));
      dispatchEvent(PeopleBlocEvent.married());
    } else if (event.type == PeopleBlocEventPayloadType.married) {
      yield currentState.copyWith(isSingle: false, isMarrying: false);
      dispatchEvent(
        PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(lastname: 'married'),
        ),
      );
    }
  }

  @override
  void handleInternalError(dynamic error) {}
}

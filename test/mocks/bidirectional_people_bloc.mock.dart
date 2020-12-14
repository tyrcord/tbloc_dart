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
      addEvent(PeopleBlocEvent.married());
    } else if (event.type == PeopleBlocEventPayloadType.married) {
      yield currentState.copyWith(isSingle: false, isMarrying: false);
      addEvent(
        PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(lastname: 'married'),
        ),
      );
    } else if (event.type == PeopleBlocEventPayloadType.multiple) {
      yield currentState.copyWithPayload(PeopleBlocEventPayload(age: 1));

      yield null;

      yield currentState.copyWithPayload(
        PeopleBlocEventPayload(firstname: 'multi'),
      );
    }
  }

  @override
  void handleInternalError(dynamic error) {}

  BlocThrottleEventCallback<PeopleBlocEvent> putThrottleEvent(
    BlocThrottleEventCallback<PeopleBlocEvent> function,
  ) {
    return throttleEvent(function);
  }

  BlocDebounceEventCallback<PeopleBlocEvent> putDebounceEvent(
    BlocDebounceEventCallback<PeopleBlocEvent> function,
  ) {
    return debounceEvent(function);
  }
}

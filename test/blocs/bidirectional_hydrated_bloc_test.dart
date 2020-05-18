@Timeout(Duration(seconds: 5))

import 'package:flutter_test/flutter_test.dart';

import '../mocks/bidirectional_hydrated_people_bloc.mock.dart';
import '../mocks/people_bloc_event.mock.dart';
import '../mocks/people_bloc_state.mock.dart';

void main() {
  group('BidirectionalHydratedPeopleBloc', () {
    BidirectionalHydratedPeopleBloc bloc;

    final defaultState = PeopleBlocState(
      age: 42,
      firstname: 'foo',
      lastname: 'bar',
    );

    setUp(() {
      bloc = BidirectionalHydratedPeopleBloc(initialState: defaultState);
    });

    tearDown(() {
      bloc.dispose();
    });

    group('#BidirectionalHydratedPeopleBloc()', () {
      test('should return a BidirectionalHydratedPeopleBloc object', () {
        expect(
          BidirectionalHydratedPeopleBloc(
            initialState: defaultState,
          ) is BidirectionalHydratedPeopleBloc,
          equals(true),
        );
      });
    });

    group('#hydrate()', () {
      test('should retrieve and set the lasted persited state', () async {
        final bloc2 = BidirectionalHydratedPeopleBloc(
          initialState: defaultState,
        );

        await bloc.hydrate();

        bloc.dispatchEvent(
          PeopleBlocEvent(
            payload: PeopleBlocEventPayload(
              age: 24,
            ),
          ),
        );

        // wait for the state to be updated
        await Future.delayed(const Duration(microseconds: 100), () {});
        await bloc2.hydrate();

        expect(
          bloc2.currentState.age == 24,
          equals(true),
        );
      });
    });

    group('#reset()', () {
      test('should reset a BLoC\'s state', () async {
        await bloc.hydrate();

        expect(
          bloc.onData.skip(1).take(3).map((state) => state.age),
          emitsInOrder([
            24,
            42,
            12,
            emitsDone,
          ]),
        );

        bloc.dispatchEvent(
          PeopleBlocEvent(
            payload: PeopleBlocEventPayload(
              age: 24,
            ),
          ),
        );

        await bloc.reset();

        bloc.dispatchEvent(
          PeopleBlocEvent(
            payload: PeopleBlocEventPayload(
              age: 12,
            ),
          ),
        );
      });
    });
  });
}
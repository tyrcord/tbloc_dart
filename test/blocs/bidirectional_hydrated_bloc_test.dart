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

    group('#BidirectionalPeopleBloc()', () {
      test('should return a BidirectionalPeopleBloc object', () {
        expect(
          BidirectionalHydratedPeopleBloc(
            initialState: defaultState,
          ) is BidirectionalHydratedPeopleBloc,
          equals(true),
        );
      });
    });

    group('#reset()', () {
      test('should reset a BLoC\'s state', () async {
        await bloc.hydrate();

        expect(
          bloc.onData.take(4).map((state) => state.age),
          emitsInOrder([
            42,
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

@Timeout(Duration(seconds: 5))

import 'package:flutter_test/flutter_test.dart';

import '../mocks/people_bloc_state.mock.dart';
import '../mocks/unidirectional_hydrated_people_bloc.mock.dart';

void main() {
  group('UnidirectionalHydratedPeopleBloc', () {
    UnidirectionalHydratedPeopleBloc bloc;

    final defaultState = PeopleBlocState(
      age: 42,
      firstname: 'foo',
      lastname: 'bar',
    );

    setUp(() {
      bloc = UnidirectionalHydratedPeopleBloc(initialState: defaultState);
    });

    tearDown(() {
      bloc.dispose();
    });

    group('#UnidirectionalHydratedPeopleBloc()', () {
      test('should return a UnidirectionalHydratedPeopleBloc object', () {
        expect(
          UnidirectionalHydratedPeopleBloc(
            initialState: defaultState,
          ) is UnidirectionalHydratedPeopleBloc,
          equals(true),
        );
      });
    });

    group('#hydrate()', () {
      test('should retrieve and set the lasted persited state', () async {
        final bloc2 = UnidirectionalHydratedPeopleBloc(
          initialState: defaultState,
        );

        await bloc.hydrate();
        await bloc.put(PeopleBlocState(age: 24));

        // wait for the state to be updated
        await Future.delayed(const Duration(microseconds: 100), () {});
        await bloc2.hydrate();

        expect(
          bloc.currentState.age == 24,
          equals(true),
        );

        expect(
          bloc2.currentState.age == 24,
          equals(true),
        );
      });
    });

    group('#reset()', () {
      test('should reset a BLoC\'s state', () async {
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

        await bloc.put(PeopleBlocState(age: 24));
        await bloc.reset();
        await bloc.put(PeopleBlocState(age: 12));
      });
    });
  });
}

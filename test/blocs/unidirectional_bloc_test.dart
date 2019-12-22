@Timeout(Duration(seconds: 5))

import 'package:flutter_test/flutter_test.dart';

import '../mocks/people_bloc_state.mock.dart';
import '../mocks/unidirectional_people_bloc.mock.dart';

void main() {
  group('UnidirectionalBloc', () {
    UnidirectionalPeopleBloc bloc;

    final defaultState = PeopleBlocState(
      age: 42,
      firstname: 'foo',
      lastname: 'bar',
    );

    setUp(() {
      bloc = UnidirectionalPeopleBloc(
        initialState: defaultState,
      );
    });

    tearDown(() {
      bloc.dispose();
    });

    group('#UnidirectionalPeopleBloc()', () {
      test('should return a UnidirectionalPeopleBloc object', () {
        expect(
            UnidirectionalPeopleBloc(initialState: defaultState)
                is UnidirectionalPeopleBloc,
            equals(true));
      });

      test('should initialize its state', () async {
        bloc = UnidirectionalPeopleBloc(
          initialState: defaultState,
        );

        expect(bloc.currentState.firstname, equals('foo'));
        expect(bloc.currentState.lastname, equals('bar'));
        expect(bloc.currentState.age, equals(42));

        bloc = UnidirectionalPeopleBloc(
          builder: () => defaultState,
        );

        expect(bloc.currentState.firstname, equals('foo'));
        expect(bloc.currentState.lastname, equals('bar'));
        expect(bloc.currentState.age, equals(42));
      });
    });

    group('#onData', () {
      test('should be an Stream', () {
        expect(bloc.onData is Stream, equals(true));
      });

      test('should dispatch states when BLoC\'s states change', () async {
        expect(
          bloc.onData.take(3).map((state) => state.firstname),
          emitsInOrder([
            'foo',
            'baz',
            'qux',
            emitsDone,
          ]),
        );

        bloc.put(PeopleBlocState(firstname: 'baz'));
        bloc.put(PeopleBlocState(firstname: 'qux'));
      });
    });

    group('#currentState', () {
      test(
        'should return the inital state when a BLoC has been instantiated',
        () {
          final state = bloc.currentState;
          expect(state.firstname, equals('foo'));
          expect(state.lastname, equals('bar'));
          expect(state.age, equals(42));
        },
      );

      test(
        'should return the lastest state '
        'when a BLoC\'s state has been updated',
        () async {
          bloc.put(PeopleBlocState(firstname: 'baz'));

          final lastState = await bloc.onData
              .skipWhile((state) => state.firstname != 'baz')
              .first;

          expect(
            lastState.firstname,
            equals('baz'),
          );

          expect(
            lastState.firstname == bloc.currentState.firstname,
            equals(true),
          );
        },
      );
    });

    group('#reset()', () {
      test('should reset a BLoC\'s state', () {
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

        bloc.put(PeopleBlocState(age: 24));
        bloc.reset();
        bloc.put(PeopleBlocState(age: 12));
      });
    });

    group('#dispose()', () {
      test('should close the bloc stream', () {
        expect(
          bloc.onData.map((state) => state.age),
          neverEmits(12),
        );

        bloc.dispose();
        bloc.put(PeopleBlocState(age: 12));
      });
    });
  });
}

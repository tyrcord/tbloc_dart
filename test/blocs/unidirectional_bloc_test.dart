@Timeout(Duration(seconds: 5))

import 'package:flutter_test/flutter_test.dart';

import '../mocks/people_bloc_state.mock.dart';
import '../mocks/unidirectional_people_bloc.mock.dart';

void main() {
  group('BidirectionalBloc', () {
    UnidirectionalPeopleBloc bloc;

    setUp(() {
      bloc = UnidirectionalPeopleBloc(PeopleBlocState(
        age: 42,
        firstname: 'foo',
        lastname: 'bar',
      ));
    });

    tearDown(() {
      bloc.dispose();
    });

    group('#stream', () {
      test('should be an Stream', () {
        expect(bloc.stream is Stream, equals(true));
      });

      test('should dispatch states when BLoC\'s states change', () async {
        expect(
          bloc.stream.take(3).map((state) => state.firstname),
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

          final lastState = await bloc.stream
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
          bloc.stream.take(4).map((state) => state.age),
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
          bloc.stream.map((state) => state.age),
          neverEmits(12),
        );

        bloc.dispose();
        bloc.put(PeopleBlocState(age: 12));
      });
    });
  });
}

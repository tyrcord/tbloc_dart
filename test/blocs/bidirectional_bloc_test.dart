@Timeout(Duration(seconds: 5))
import 'package:flutter_test/flutter_test.dart';

import '../mocks/bidirectional_people_bloc.mock.dart';
import '../mocks/people_bloc_event.mock.dart';
import '../mocks/people_bloc_state.mock.dart';

void main() {
  group('BidirectionalBloc', () {
    BidirectionalPeopleBloc bloc;

    final defaultState = PeopleBlocState(
      age: 42,
      firstname: 'foo',
      lastname: 'bar',
    );

    setUp(() {
      bloc = BidirectionalPeopleBloc(initialState: defaultState);
    });

    tearDown(() {
      bloc.dispose();
    });

    group('#BidirectionalPeopleBloc()', () {
      test('should return a BidirectionalPeopleBloc object', () {
        expect(
            BidirectionalPeopleBloc(initialState: defaultState)
                is BidirectionalPeopleBloc,
            equals(true));
      });

      test('should initialize its state', () async {
        bloc = BidirectionalPeopleBloc(
          initialState: defaultState,
        );

        expect(bloc.currentState.firstname, equals('foo'));
        expect(bloc.currentState.lastname, equals('bar'));
        expect(bloc.currentState.age, equals(42));

        bloc = BidirectionalPeopleBloc(
          initialStateBuilder: () => defaultState,
        );

        expect(bloc.currentState.firstname, equals('foo'));
        expect(bloc.currentState.lastname, equals('bar'));
        expect(bloc.currentState.age, equals(42));
      });
    });

    group('#dispatchEvent()', () {
      test('should update a BLoC\'s state when an Event is dispatched',
          () async {
        bloc.dispatchEvent(
          PeopleBlocEvent(
            payload: PeopleBlocEventPayload(
              age: 12,
              lastname: 'qux',
            ),
          ),
        );

        final lastState = await bloc.onData.skip(1).first;

        expect(
          lastState ==
              PeopleBlocState(
                age: 12,
                firstname: 'foo',
                lastname: 'qux',
              ),
          equals(true),
        );
      });
    });

    group('#onData', () {
      test('should be an Stream', () {
        expect(bloc.onData is Stream, equals(true));
      });

      test(
        'should dispatch states when a BLoC\'s states change',
        () async {
          expect(
            bloc.onData.take(3).map((state) => state.firstname),
            emitsInOrder([
              'foo',
              'baz',
              'qux',
              emitsDone,
            ]),
          );

          bloc.dispatchEvent(
            PeopleBlocEvent(
              payload: PeopleBlocEventPayload(firstname: 'baz'),
            ),
          );

          bloc.dispatchEvent(
            PeopleBlocEvent(
              payload: PeopleBlocEventPayload(firstname: 'qux'),
            ),
          );
        },
      );
    });

    group('#onError', () {
      test('should be an Stream', () {
        expect(bloc.onError is Stream, equals(true));
      });

      test('should dispatch an error when an error occurs', () async {
        expect(
          bloc.onError.take(1).map((Object error) => error.toString()),
          emitsInOrder([
            'error',
            emitsDone,
          ]),
        );

        bloc.dispatchEvent(PeopleBlocEvent.error());
      });
    });

    group('#onEvent', () {
      test('should be an Stream', () {
        expect(bloc.onEvent is Stream, equals(true));
      });

      test('should dispatch an event when a BloC receives an event', () async {
        final event = PeopleBlocEvent(
          payload: PeopleBlocEventPayload(firstname: 'baz'),
        );

        expect(
          bloc.onEvent.take(1),
          emitsInOrder([
            event,
            emitsDone,
          ]),
        );

        bloc.dispatchEvent(event);
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
          bloc.dispatchEvent(
            PeopleBlocEvent(
              payload: PeopleBlocEventPayload(firstname: 'baz'),
            ),
          );

          final lastState = await bloc.onData
              .skipWhile((state) => state.firstname != 'baz')
              .first;

          expect(
            lastState == bloc.currentState,
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

        bloc.dispatchEvent(
          PeopleBlocEvent(
            payload: PeopleBlocEventPayload(
              age: 24,
            ),
          ),
        );

        bloc.reset();

        bloc.dispatchEvent(
          PeopleBlocEvent(
            payload: PeopleBlocEventPayload(
              age: 12,
            ),
          ),
        );
      });
    });

    group('#dispose()', () {
      test('should close the bloc onData stream', () {
        expect(
          bloc.onData.skip(1).map((state) => state.age),
          neverEmits(12),
        );

        bloc.dispose();

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

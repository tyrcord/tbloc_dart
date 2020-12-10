@Timeout(Duration(seconds: 5))
import 'package:flutter_test/flutter_test.dart';
import 'package:tbloc_dart/core/base/base.dart';

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
      bloc.close();
    });

    group('#BidirectionalPeopleBloc()', () {
      test('should return a BidirectionalPeopleBloc object', () {
        expect(
          BidirectionalPeopleBloc(initialState: defaultState)
              is BidirectionalPeopleBloc,
          equals(true),
        );
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

    group('#addEvent()', () {
      test('should update a BLoC\'s state when an Event is dispatched',
          () async {
        bloc.addEvent(
          PeopleBlocEvent.updateInformation(
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

          bloc.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(firstname: 'baz'),
            ),
          );

          bloc.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(firstname: 'qux'),
            ),
          );
        },
      );

      test(
        'should dispatch states in order when a BLoC\'s states change',
        () async {
          var i = 0;

          expect(
            bloc.onData.skip(1).take(3).map((state) {
              i++;

              if (i == 3) {
                return state.lastname;
              }

              return state.isSingle;
            }),
            emitsInOrder([
              true,
              false,
              'married',
              emitsDone,
            ]),
          );

          bloc.addEvent(PeopleBlocEvent.marrySomeone());
        },
      );

      test(
        'should not dispatch states when the state has not changed',
        () async {
          var count = 0;
          var listenCallback = (state) => count++;
          var listenCallbackAsync1 = expectAsync1(listenCallback, count: 1);
          var event = PeopleBlocEvent.updateInformation(
            payload: PeopleBlocEventPayload(
              age: 12,
              lastname: 'qux',
            ),
          );

          bloc.onData.skip(1).listen(listenCallbackAsync1);

          bloc.addEvent(event);
          bloc.addEvent(event);

          await Future.delayed(const Duration(milliseconds: 300), () {
            expect(count, equals(1));
          });
        },
      );
    });

    group('#onError', () {
      test('should be an Stream', () {
        expect(bloc.onError is Stream, equals(true));
      });

      test('should dispatch an error when an error occurs', () async {
        expect(
          bloc.onError.take(1).map((BlocError error) => error.source),
          emitsInOrder([
            'error',
            emitsDone,
          ]),
        );

        bloc.addEvent(PeopleBlocEvent.error());
      });
    });

    group('#onEvent', () {
      test('should be an Stream', () {
        expect(bloc.onEvent is Stream, equals(true));
      });

      test(
        'should dispatch an event when an event is added to a BloC',
        () async {
          final event = PeopleBlocEvent.updateInformation(
            payload: PeopleBlocEventPayload(firstname: 'baz'),
          );

          expect(
            bloc.onEvent.take(1),
            emitsInOrder([
              event,
              emitsDone,
            ]),
          );

          bloc.addEvent(event);
        },
      );
    });

    group('#currentState', () {
      test(
        'should return the initial state when a BLoC has been instantiated',
        () {
          final state = bloc.currentState;
          expect(state.firstname, equals('foo'));
          expect(state.lastname, equals('bar'));
          expect(state.age, equals(42));
        },
      );

      test(
        'should return the latest state '
        'when a BLoC\'s state has been updated',
        () async {
          bloc.addEvent(
            PeopleBlocEvent.updateInformation(
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

    group('#close()', () {
      test('should close bloC streams', () {
        expect(
          bloc.onData.skip(1).map((state) => state.age),
          neverEmits(12),
        );

        bloc.close();

        bloc.addEvent(
          PeopleBlocEvent.updateInformation(
            payload: PeopleBlocEventPayload(
              age: 12,
            ),
          ),
        );

        expect(bloc.isClosed, equals(true));
      });
    });
  });
}

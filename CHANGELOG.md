# Changelog

## [0.14.1](https://github.com/tyrcord/tbloc_dart/releases/tag/0.14.1) (2020-03-30)

### Enhancements

- Allow to override the default behavior of the close method.

## [0.14.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.14.0) (2020-03-28)

### Enhancements

- Stable nullsafety.

## [0.14.0-nullsafety.1](https://github.com/tyrcord/tbloc_dart/releases/tag/0.14.0-nullsafety.1) (2020-03-08)

### Fixes

- Fixes regression.

## [0.14.0-nullsafety.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.14.0-nullsafety.0) (2020-03-05)

### Enhancements

- Supports sound null safety.

## [0.13.1](https://github.com/tyrcord/tbloc_dart/releases/tag/0.13.1) (2020-12-25)

### Fixes

- Minor fixes.

## [0.13.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.13.0) (2020-12-24)

### Enhancements

- Bloc's state extends from TModel class.

## [0.12.1](https://github.com/tyrcord/tbloc_dart/releases/tag/0.12.1) (2020-12-18)

### Fixes

- Fixed regressions.

## [0.12.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.12.0) (2020-12-14)

### Fixes

- Fixed currentState safety within mapEventToState.

### Enhancements

- Allow to skip some BloC's events.
- added debounceEvent and debounce methods.

## [0.11.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.11.0) (2020-12-10)

### Enhancements

- Minor improvements.

### Breaking Changes

- Renamed `dispatchEvent` to `addEvent`.
- Renamed `dispose` to `close`.

## [0.10.2](https://github.com/tyrcord/tbloc_dart/releases/tag/0.10.2) (2020-11-29)

### Enhancements

- added stackTrace property to BlocError.

## [0.10.1](https://github.com/tyrcord/tbloc_dart/releases/tag/0.10.1) (2020-11-11)

### Enhancements

- Minor improvements.

## [0.10.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.10.0) (2020-10-19)

### Features

- Added helpers for throttling events.

## [0.9.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.9.0) (2020-10-10)

### Enhancements

- Minor improvements.

### Breaking Changes

- Requires dart 2.10.0

## [0.8.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.8.0) (2020-10-01)

### Breaking Changes

- the method `mapEventToState` doesn't pass the bloc's state as a parameter anymore

## [0.7.1](https://github.com/tyrcord/tbloc_dart/releases/tag/0.7.1) (2020-09-20)

### Features

- added `isInitializing` and `isInitialized` properties to the abstract Bloc class.

## [0.7.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.7.0) (2020-09-19)

### Features

- Add `isInitialized` and `isInitializing` properties to BlocState.
- Add BlocError Object.

### Breaking Changes

- Add `type` property to the BlocEvent.
- Remove BloC's `reset` method.

## [0.6.1](https://github.com/tyrcord/tbloc_dart/releases/tag/0.6.1) (2020-09-03)

### Features

- Provide BlocBuilderWidget2 and BlocBuilderWidget3 widgets.

### Fixes

- Only log a warning when an internal error is not handled.

## [0.6.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.6.0) (2020-09-02)

### Breaking Changes

- Refactor BloC's internal errors handling.

### Fixes

- Minor fixes.

## [0.5.1](https://github.com/tyrcord/tbloc_dart/releases/tag/0.5.1) (2020-08-02)

### Fixes

- Make sure errors are dispatched correctly.

## [0.5.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.5.0) (2020-08-01)

### Breaking changes

- BlocBuilder callback function takes a third argument, Support errors that could occur.

### Fixes

- Avoid to dispatch null states.

## [0.4.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.4.0) (2020-06-25)

### Features

- Add Multi Blocs provider

## [0.3.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.3.0) (2020-05-18)

### Features

- Add hydrated blocs (beta)
- Add initState method to the abstract Bloc Class

### Breaking changes

- Bloc parameter `stateBuilder` has been renamed `initialStateBuilder`

## [0.2.0](https://github.com/tyrcord/tbloc_dart/releases/tag/0.2.0) (2019-12-22)

### Features

- First release

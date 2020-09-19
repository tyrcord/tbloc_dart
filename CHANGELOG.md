# Changelog

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

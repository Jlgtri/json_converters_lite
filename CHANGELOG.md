# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.3]

### Changed

- Changed `DurationConverter` to accept strings in format `dd:hh:mm:ss.us`.

## [1.0.2+1]

### Added

- Added [`package:meta`][https://pub.dev/packages/meta] annotations to
  `EnumConverter`.

## [1.0.2]

### Fixed

- Fixed bug on `EnumConverter`.

## [1.0.1]

### Added

- Added [`package:meta`][https://pub.dev/packages/meta] annotations to
  converters.

### Changed

- Changed library name.

## [1.0.0+2]

### Changed

- Update License.

## [1.0.0+1]

### Changed

- Minor README changes.

## [1.0.0]

### Added

- Initial Release including 5 converters:
  1. **BoolConverter**, which converts a `bool` to an `int`.
  2. **DateTimeConverter**, which converts a `DateTime` to the `ISO8601` string.
  3. **DurationConverter**, which gets a total amount of seconds from `Duration`.
  4. **EnumConverter**, which serializes `Enum` value as string from it's name.
  5. **IterableConverter**, which takes the other `converter` as an argument and
     serializes each value in the `Iterable` with that converter.

[unreleased]: https://github.com/Jlgtri/json_converters_lite/compare/v1.0.3...HEAD
[1.0.3]: https://github.com/Jlgtri/json_converters_lite/compare/v1.0.2+1...v1.0.3
[1.0.2+1]: https://github.com/Jlgtri/json_converters_lite/compare/v1.0.2...v1.0.2+1
[1.0.2]: https://github.com/Jlgtri/json_converters_lite/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/Jlgtri/json_converters_lite/compare/v1.0.0+2...v1.0.1
[1.0.0+2]: https://github.com/Jlgtri/json_converters_lite/compare/v1.0.0+1...v1.0.0+2
[1.0.0+1]: https://github.com/Jlgtri/json_converters_lite/compare/v1.0.0...v1.0.0+1
[1.0.0]: https://github.com/Jlgtri/json_converters_lite/releases/tag/v1.0.0

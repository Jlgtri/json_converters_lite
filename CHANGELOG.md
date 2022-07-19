# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0]

### Added

- Initial Release including 5 converters:
  1. **BoolConverter**, which converts a `bool` to an `int`.
  2. **DateTimeConverter**, which converts a `DateTime` to the `ISO8601` string.
  3. **DurationConverter**, which gets a total amount of seconds from `Duration`.
  4. **EnumConverter**, which serializes `Enum` value as string from it's name.
  5. **IterableConverter**, which takes the other `converter` as an argument and
     serializes each value in the `Iterable` with that converter.

[unreleased]: https://github.com/Jlgtri/json_converters/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Jlgtri/json_converters/releases/tag/v1.0.0

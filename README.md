Easily convert common Dart data types into a json compatible ones.

- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [FAQ](#faq)

## Getting Started

This package provides a unified way to work with Dart data type serialization.

All converters implement the `JsonConverter` interface which has two methods:

- **toJson**, which serializes the value.
- **fromJson**, which deserializes the value.

Each converter in this package has a nullable and non-nullable variation.
A value passed to the non-nullable converter should be also non-nullable.
The name of the nullable converter starts with `optional`. It may return a
nullable value.

For a complete example, see `Example` tab.

## Installation

This is a standalone helper package which does not have any dependencies.

In general, put the reference to this package under [dependencies][] in your
[`pubspec.yaml`][pubspec].

```yaml
dependencies:
  json_converters:
```

## Usage

To use this package, import it in your code:

```dart
import 'package:json_converters_lite/json_converters_lite.dart';
```

And use any of the currently available converters, currently featuring:

1. **BoolConverter**, which converts a `bool` to an `int`.
2. **DateTimeConverter**, which converts a `DateTime` to the `ISO8601` string.
3. **DurationConverter**, which gets a total amount of seconds from `Duration`.
4. **EnumConverter**, which serializes `Enum` value as string from it's name.
5. **IterableConverter**, which takes the other `converter` as an argument and
   serializes each value in the `Iterable` with that converter.

Also, you can create your own converters and use them, by implementing the
`JsonConverter` interface.

## Contributing

You can contibute by designing your own converters and proposing them to be
added to this package. Also, any bug reports are appreciated.

## FAQ

### Why create a package for such basic features?

Because, these features are frequently used in different projects. Thus, it is
very useful and convenient to have a consistent code base between projects.

[dependencies]: https://dart.dev/tools/pub/dependencies
[pubspec]: https://dart.dev/tools/pub/pubspec

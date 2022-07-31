library json_converters_lite;

import 'package:meta/meta.dart';

/// The class to convert an object of type [T] to the object of type [S].
@immutable
mixin JsonConverter<T extends Object?, S extends Object?> on Object {
  /// Convert an object of type [T] to the object of type [S].
  S toJson(final T value);

  /// Convert an object of type [S] of to the object of type [T].
  T fromJson(final S value);
}

/// The dummy converter for nullable [T].
///
/// Returns the same instance it was passed.
@immutable
@optionalTypeArgs
class OptionalDummyConverter<T extends Object?>
    implements JsonConverter<T?, T?> {
  /// The dummy converter for nullable [T].
  ///
  /// Returns the same instance it was passed.
  const OptionalDummyConverter();

  @override
  T? toJson(final T? value) => value;

  @override
  T? fromJson(final T? value) => value;
}

/// The dummy converter for [T].
///
/// Returns the same instance it was passed.
@immutable
@optionalTypeArgs
class DummyConverter<T extends Object> implements JsonConverter<T, T> {
  /// The dummy converter for [T].
  ///
  /// Returns the same instance it was passed.
  const DummyConverter();

  @override
  T toJson(final T value) => value;

  @override
  T fromJson(final T value) => value;
}

/// The converter for nullable [Iterable].
///
/// Converts an [Iterable] using the provided [converter].
@immutable
@optionalTypeArgs
class OptionalIterableConverter<T extends Object, S extends Object>
    implements JsonConverter<Iterable<T>?, Iterable<S>?> {
  /// The converter for nullable [Iterable].
  ///
  /// Converts an [Iterable] using the provided [converter].
  const OptionalIterableConverter(this.converter);

  /// The provided converter for nullable [Iterable].
  final JsonConverter<T?, S?> converter;

  @override
  Iterable<S>? toJson(final Iterable<T?>? value) => value
      ?.whereType<T>()
      .map(converter.toJson)
      .whereType<S>()
      .toList(growable: false);

  @override
  Iterable<T>? fromJson(final Iterable<S?>? value) =>
      value?.whereType<S>().map(converter.fromJson).whereType<T>();
}

/// The converter for [Iterable].
///
/// Converts an [Iterable] using the provided [converter].
@immutable
@optionalTypeArgs
class IterableConverter<T extends Object, S extends Object>
    implements JsonConverter<Iterable<T>, Iterable<S>> {
  /// The converter for [Iterable].
  ///
  /// Converts an [Iterable] using the provided [converter].
  const IterableConverter(this.converter);

  /// The provided converter for an [Iterable].
  final JsonConverter<T, S> converter;

  @override
  Iterable<S> toJson(final Iterable<T> value) => value.map(converter.toJson);

  @override
  Iterable<T> fromJson(final Iterable<S> value) =>
      value.map(converter.fromJson).cast<T>();
}

/// The converter for nullable [bool].
///
/// Converts nullable [bool] to nullable [int].
const OptionalBoolConverter optionalBoolConverter = OptionalBoolConverter._();

/// The converter for nullable [bool].
///
/// Converts nullable [bool] to nullable [int].
@immutable
class OptionalBoolConverter implements JsonConverter<bool?, int?> {
  const OptionalBoolConverter._();

  @override
  int? toJson(final bool? value) => value == null ? null : (value ? 1 : 0);

  @override
  bool? fromJson(final int? value) => value == null ? null : value == 1;
}

/// The converter for [bool].
///
/// Converts [bool] to [int].
const BoolConverter boolConverter = BoolConverter._();

/// The converter for [bool].
///
/// Converts [bool] to [int].
@immutable
class BoolConverter implements JsonConverter<bool, int> {
  /// The converter for [bool].
  ///
  /// Converts [bool] to [int].
  const BoolConverter._();

  @override
  int toJson(final bool value) => value ? 1 : 0;

  @override
  bool fromJson(final int value) => value == 1;
}

/// The converter for nullable [DateTime].
///
/// Converts [DateTime] to `ISO8601` string.
const OptionalDateTimeConverter optionalDateTimeConverter =
    OptionalDateTimeConverter();

/// The converter for nullable [DateTime].
///
/// Converts [DateTime] to `ISO8601` string.
@immutable
class OptionalDateTimeConverter implements JsonConverter<DateTime?, String?> {
  /// The converter for nullable [DateTime].
  ///
  /// Converts [DateTime] to `ISO8601` string.
  const OptionalDateTimeConverter({this.isUtc = true});

  /// If the datetime creation from unix timestamp should use utc time.
  final bool isUtc;

  @override
  String? toJson(final DateTime? value) => value?.toIso8601String();

  @override
  DateTime? fromJson(final String? value) {
    if (value == null) {
      return null;
    }
    try {
      return DateTimeConverter(isUtc: isUtc).fromJson(value);
    } on FormatException catch (_) {
      return null;
    }
  }
}

/// The converter for [DateTime].
///
/// Converts [DateTime] to `ISO8601` string.
const DateTimeConverter dateTimeConverter = DateTimeConverter();

/// The converter for [DateTime].
///
/// Converts [DateTime] to `ISO8601` string.
@immutable
class DateTimeConverter implements JsonConverter<DateTime, String> {
  /// The converter for [DateTime].
  ///
  /// Converts [DateTime] to `ISO8601` string.
  const DateTimeConverter({this.isUtc = true});

  /// If the [DateTime] creation from unix timestamp should use utc time.
  final bool isUtc;

  @override
  String toJson(final DateTime value) => value.toIso8601String();

  @override
  DateTime fromJson(final String value) {
    num? seconds = num.tryParse(value);
    if (seconds == null) {
      return DateTime.parse(value);
    }
    final String fraction = seconds.toStringAsFixed(6).split('.').last;
    seconds = seconds.truncate();
    if (fraction.length <= 3) {
      final int millis =
          int.parse(seconds.toStringAsFixed(0) + fraction.padRight(3));
      return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: isUtc);
    } else {
      final int micros =
          int.parse(seconds.toStringAsFixed(0) + fraction.padRight(6));
      return DateTime.fromMicrosecondsSinceEpoch(micros, isUtc: isUtc);
    }
  }
}

/// The converter for nullable [Duration].
///
/// Gets total seconds within the [Duration] with microsecond precision.
const OptionalDurationConverter optionalDurationConverter =
    OptionalDurationConverter._();

/// The converter for nullable [Duration].
///
/// Gets total seconds within the [Duration] with microsecond precision.
@immutable
class OptionalDurationConverter implements JsonConverter<Duration?, num?> {
  /// The converter for nullable [Duration].
  ///
  /// Gets total seconds within the [Duration] with microsecond precision.
  const OptionalDurationConverter._();

  @override
  num? toJson(final Duration? value) {
    if (value == null) {
      return null;
    }
    try {
      return durationConverter.toJson(value);
    } on FormatException catch (_) {
      return null;
    }
  }

  @override
  Duration? fromJson(final num? value) {
    if (value == null) {
      return null;
    }
    try {
      return durationConverter.fromJson(value);
    } on FormatException catch (_) {
      return null;
    }
  }
}

/// The converter for [Duration].
///
/// Gets total seconds within the [Duration] with microsecond precision.
const DurationConverter durationConverter = DurationConverter._();

/// The converter for [Duration].
///
/// Gets total seconds within the [Duration] with microsecond precision.
@immutable
class DurationConverter implements JsonConverter<Duration, num> {
  /// The converter for [Duration].
  ///
  /// Gets total seconds within the [Duration] with microsecond precision.
  const DurationConverter._();

  @override
  num toJson(final Duration value) {
    final String microseconds = value.inMicroseconds.toString();
    final String seconds = microseconds.length > 6
        ? microseconds.substring(0, microseconds.length - 6)
        : '0';
    final String micros = microseconds.substring(
      microseconds.length > 6 ? microseconds.length - 6 : 0,
    );
    return double.parse('$seconds.${micros.padLeft(6, '0')}');
  }

  @override
  Duration fromJson(final num value) {
    final int seconds;
    final int milliseconds;
    final int microseconds;
    if (value is int) {
      seconds = value;
      milliseconds = microseconds = 0;
    } else if (value is double) {
      final Iterable<String> parts = value.toStringAsFixed(6).split('.');
      seconds = int.parse(parts.first);
      milliseconds = int.parse(parts.last.substring(0, 3));
      microseconds = int.parse(parts.last.substring(3));
    } else {
      throw FormatException(
        'A value of type "${value.runtimeType}" can not be handled. '
        'Supported types are int and double.',
      );
    }
    return Duration(
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    );
  }
}

/// The converter for nullable [Enum].
///
/// Converts [Enum] to [String].
@immutable
class OptionalEnumConverter<T extends Enum>
    implements JsonConverter<T?, String?> {
  /// The converter for nullable [Enum].
  ///
  /// Converts [Enum] to [String].
  const OptionalEnumConverter(this.values);

  /// The values of this enum.
  final Iterable<T> values;

  @override
  T? fromJson(final String? value) {
    if (value == null) {
      return null;
    }
    try {
      return EnumConverter<T>(values).fromJson(value);
    } on FormatException catch (_) {
      return null;
    }
  }

  @override
  String? toJson(final T? value) =>
      value == null ? null : EnumConverter<T>(values).toJson(value);
}

/// The converter for [Enum].
///
/// Converts [Enum] to [String].
@immutable
class EnumConverter<T extends Enum> implements JsonConverter<T, String> {
  /// The converter for [Enum].
  ///
  /// Converts [Enum] to [String].
  const EnumConverter(this.values);

  /// The values of this enum.
  final Iterable<T> values;

  @override
  T fromJson(final String value) => values.firstWhere(
        (final T value) => value.name == value,
        orElse: () => throw FormatException(
            'Value "$value" is not present. Possible values: '
            '${values.map((final T value) => value.name).join(', ')}'),
      );

  @override
  String toJson(final T value) => value.name;
}

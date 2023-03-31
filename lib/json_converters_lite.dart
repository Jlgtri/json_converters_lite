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
/// Convert the [Duration] with microsecond precision.
const OptionalDurationConverter optionalDurationConverter =
    OptionalDurationConverter._();

/// The converter for nullable [Duration].
///
/// Convert the [Duration] with microsecond precision.
@immutable
class OptionalDurationConverter implements JsonConverter<Duration?, String?> {
  /// The converter for nullable [Duration].
  ///
  /// Convert the [Duration] with microsecond precision.
  const OptionalDurationConverter._();

  @override
  String? toJson(final Duration? value) {
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
  Duration? fromJson(final String? value) {
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
/// Convert the [Duration] with microsecond precision.
const DurationConverter durationConverter = DurationConverter._();

/// The converter for [Duration].
///
/// Convert the [Duration] with microsecond precision.
@immutable
class DurationConverter implements JsonConverter<Duration, String> {
  /// The converter for [Duration].
  ///
  /// Convert the [Duration] with microsecond precision.
  const DurationConverter._();

  @override
  String toJson(final Duration value) => <String>[
        <int>[
          value.inHours,
          value.inMinutes % 60,
          value.inSeconds % 60,
        ].map((final _) => _.toString().padLeft(2, '0')).join(':'),
        (value.inMicroseconds % 1000000).toString().padLeft(6, '0'),
      ].join('.');

  @override
  Duration fromJson(final String value) {
    final Iterable<String> parts = value.split(':');
    if (parts.isEmpty ||
        parts.length > 4 ||
        parts.any((final _) => _.contains(RegExp('[^0-9.]')))) {
      throw FormatException(
        'A value `$value` can not be handled. '
        'Should be in format `dd:hh:mm:ss.us`.',
      );
    }

    double days = 0;
    double hours = 0;
    double minutes = 0;
    double seconds = double.parse(parts.last);
    if (parts.length > 3) {
      final String daysPart = parts.elementAt(parts.length - 4);
      if (daysPart.isNotEmpty) {
        days += double.parse(daysPart);
        hours += 24 * days.remainder(1);
      }
    }
    if (parts.length > 2) {
      final String hoursPart = parts.elementAt(parts.length - 3);
      if (hoursPart.isNotEmpty) {
        hours += double.parse(hoursPart);
        minutes += 60 * hours.remainder(1);
      }
    }
    if (parts.length > 1) {
      final String minutesPart = parts.elementAt(parts.length - 2);
      if (minutesPart.isNotEmpty) {
        minutes += double.parse(minutesPart);
        seconds += 60 * minutes.remainder(1);
      }
    }
    final String fraction = seconds.remainder(1).toStringAsFixed(6);
    final int milliseconds = int.parse(fraction.substring(2, 5));
    final int microseconds = int.parse(fraction.substring(5, 8));
    return Duration(
      days: days.floor(),
      hours: hours.floor(),
      minutes: minutes.floor(),
      seconds: seconds.floor(),
      milliseconds: milliseconds,
      microseconds: microseconds,
    );
  }
}

/// The converter for nullable [Enum].
///
/// Converts [Enum] to [String].
@immutable
@optionalTypeArgs
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
@optionalTypeArgs
class EnumConverter<T extends Enum> implements JsonConverter<T, String> {
  /// The converter for [Enum].
  ///
  /// Converts [Enum] to [String].
  const EnumConverter(this.values);

  /// The values of this enum.
  final Iterable<T> values;

  @override
  T fromJson(final String value) => values.firstWhere(
        (final T $value) => $value.name == value,
        orElse: () => throw FormatException(
            'Value "$value" is not present. Possible values: '
            '${values.map((final T value) => value.name).join(', ')}'),
      );

  @override
  String toJson(final T value) => value.name;
}

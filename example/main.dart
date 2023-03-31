// ignore_for_file: avoid_print

import 'package:json_converters_lite/json_converters_lite.dart';

void main() {
  final DateTime dateTime = DateTime.now();
  final String serializedDateTime =
      dateTimeConverter.toJson(dateTime); // 2022-07-19T19:13:13.603
  final DateTime deserializedDateTime =
      dateTimeConverter.fromJson(serializedDateTime);
  print(dateTime == deserializedDateTime); // true

  final String? $serializedDateTime =
      optionalDateTimeConverter.toJson(dateTime); // 2022-07-19T19:13:13.603
  final DateTime? $deserializedDateTime =
      optionalDateTimeConverter.fromJson($serializedDateTime);
  print(dateTime == $deserializedDateTime); // true

  const Duration duration = Duration.zero;
  final String serializedDuration =
      durationConverter.toJson(duration); // 00:00:00.000000
  final Duration deserializedDuration =
      durationConverter.fromJson(serializedDuration);
  print(duration == deserializedDuration); // true

  final String? $serializedDuration =
      optionalDurationConverter.toJson(duration); // 00:00:00.000000
  final Duration? $deserializedDuration =
      optionalDurationConverter.fromJson($serializedDuration);
  print(duration == $deserializedDuration); // true
}

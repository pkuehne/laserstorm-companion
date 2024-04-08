import 'package:flutter_test/flutter_test.dart';
import 'package:weasel/src/laserstorm/validators.dart';

void main() {
  test('NotEmpty cannot be empty', () {
    // Given
    var input = "";

    // When
    var result = notEmpty(input);

    // Then
    expect(result, isNotNull);
  });

  test('NotEmpty cannot be null', () {
    // Given

    // When
    var result = notEmpty(null);

    // Then
    expect(result, isNotNull);
  });

  test('NotEmpty validates if set', () {
    // Given
    var input = "foobar";

    // When
    var result = notEmpty(input);

    // Then
    expect(result, isNull);
  });

  test('Multiple validators must all be null', () {
    // Given
    var input = "foobar";

    // When
    var result = notEmpty(input) ?? notEmpty(input);

    // Then
    expect(result, isNull);
  });

  test('Multiple validators any not null returns null', () {
    // Given
    var input = "foobar";

    // When
    var result = notEmpty(input) ?? notEmpty(null);

    // Then
    expect(result, isNotNull);
  });

  test('strictlyPositiveNumbers rejects 0', () {
    // Given
    var input = "0";

    // When
    var result = strictlyPositiveNumber(input);

    // Then
    expect(result, isNotNull);
  });

  test('strictlyPositiveNumbers rejects -1', () {
    // Given
    var input = "-1";

    // When
    var result = strictlyPositiveNumber(input);

    // Then
    expect(result, isNotNull);
  });

  test('strictlyPositiveNumbers accepts 1', () {
    // Given
    var input = "1";

    // When
    var result = strictlyPositiveNumber(input);

    // Then
    expect(result, isNull);
  });

  test('positiveNumbers accepts 0', () {
    // Given
    var input = "0";

    // When
    var result = positiveNumber(input);

    // Then
    expect(result, isNull);
  });

  test('positiveNumbers rejects -1', () {
    // Given
    var input = "-1";

    // When
    var result = positiveNumber(input);

    // Then
    expect(result, isNotNull);
  });

  test('positiveNumbers accepts 1', () {
    // Given
    var input = "1";

    // When
    var result = positiveNumber(input);

    // Then
    expect(result, isNull);
  });

  test("Trait must be in list", () {
    // Given
    var input = "Foobar";

    // When
    var result = traits(input);

    // Then
    expect(result, isNotNull);
  });

  test("More than one trait is allowed", () {
    // Given
    var input = "Aim,Burst";

    // When
    var result = traits(input);

    // Then
    expect(result, isNull);
  });
  test("Whitespace doesn't matter in traits", () {
    // Given
    var input = "Aim,              Burst             ";

    // When
    var result = traits(input);

    // Then
    expect(result, isNull);
  });
  test("All traits must be valid", () {
    // Given
    var input = "Aim,Foobar";

    // When
    var result = traits(input);

    // Then
    expect(result, isNotNull);
  });
  test("Empty traits are ok", () {
    // Given
    var input = "";

    // When
    var result = traits(input);

    // Then
    expect(result, isNull);
  });
}

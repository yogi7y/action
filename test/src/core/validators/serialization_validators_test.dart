import 'package:action/src/core/exceptions/serialization_exception.dart';
import 'package:action/src/core/validators/serialization_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FieldTypeValidator', () {
    late StackTrace stackTrace;
    late Map<String, dynamic> payload;
    late FieldTypeValidator validator;

    setUp(() {
      stackTrace = StackTrace.current;
      payload = {
        'stringField': 'test string',
        'intField': 42,
        'doubleField': 3.14,
        'boolField': true,
        'mapField': {'key': 'value'},
        'listField': [1, 2, 3],
      };
      validator = FieldTypeValidator(payload, stackTrace);
    });

    test('successfully validates String type', () {
      expect(
        validator.isOfType<String>('stringField'),
        equals('test string'),
      );
    });

    test('successfully validates int type', () {
      expect(
        validator.isOfType<int>('intField'),
        equals(42),
      );
    });

    test('successfully validates double type', () {
      expect(
        validator.isOfType<double>('doubleField'),
        equals(3.14),
      );
    });

    test('successfully validates bool type', () {
      expect(
        validator.isOfType<bool>('boolField'),
        equals(true),
      );
    });

    test('successfully validates Map type', () {
      expect(
        validator.isOfType<Map<String, Object?>>('mapField'),
        equals({'key': 'value'}),
      );
    });

    test('successfully validates List type', () {
      expect(
        validator.isOfType<List<Object?>>('listField'),
        equals([1, 2, 3]),
      );
    });

    test('throws InvalidTypeException when type does not match', () {
      expect(
        () => validator.isOfType<int>('stringField'),
        throwsA(
          isA<InvalidTypeException>()
              .having(
                (e) => e.exception,
                'exception message',
                'stringField must be of type int, but got String',
              )
              .having(
                (e) => e.payload,
                'payload',
                equals(payload),
              )
              .having(
                (e) => e.stackTrace,
                'stackTrace',
                equals(stackTrace),
              ),
        ),
      );
    });

    test('returns fallback value when type does not match', () {
      expect(
        validator.isOfType<int>('stringField', fallback: 0),
        equals(0),
      );
    });

    test(
      'returns fallback when value is null',
      () {
        expect(
          validator.isOfType<int>('nullField', fallback: 0),
          equals(0),
        );
      },
    );

    test('throws InvalidTypeException with custom stackTrace', () {
      final customStackTrace = StackTrace.current;
      expect(
        () => validator.isOfType<int>(
          'stringField',
          stackTrace: customStackTrace,
        ),
        throwsA(
          isA<InvalidTypeException>().having(
            (e) => e.stackTrace,
            'stackTrace',
            equals(customStackTrace),
          ),
        ),
      );
    });

    test('throws InvalidTypeException for non-existent key', () {
      expect(
        () => validator.isOfType<String>('nonExistentField'),
        throwsA(
          isA<InvalidTypeException>().having(
            (e) => e.exception,
            'exception message',
            'nonExistentField must be of type String, but got Null',
          ),
        ),
      );
    });
  });
}

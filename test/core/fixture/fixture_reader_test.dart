import 'dart:io';

import 'package:test/test.dart';

import 'fixture_reader.dart';

void main() {
  group('should test fixture', () {
    test('shoulf return json', () {
      final json =
          FixtureReader.getJsonData('core/fixture/fixture_reader_test.json');

      expect(json, isNotEmpty);
    });

    test('should return Map<String dynamic>', () {
      final data = FixtureReader.getData<Map<String, dynamic>>(
        'core/fixture/fixture_reader_test.json',
      );

      expect(
        data,
        isA<Map<String, dynamic>>(),
      );

      expect(data['id'], 1);
    });

    test('should return List', () {
      final data = FixtureReader.getData<List>(
        'core/fixture/fixture_reader_list_test.json',
      );

      expect(data, isA<List>());
      expect(data.isNotEmpty, isTrue);
      expect(data.first['id'], 1);
    });

    test('should return FileSystemException if is file not found', () {
      final call = FixtureReader.getData;

      expect(() => call('error.json'), throwsA(isA<FileSystemException>()));
    });
  });
}

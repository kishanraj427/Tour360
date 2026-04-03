import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tour360/utils/api_config.dart';

void main() {
  group('ApiConfig', () {
    setUp(() {
      dotenv.testLoad(fileInput: '''
GOOGLE_API_KEY=test_api_key_123
GOOGLE_CX=test_cx_456
''');
    });

    group('env var access', () {
      test('apiKey returns value from env', () {
        expect(ApiConfig.apiKey, equals('test_api_key_123'));
      });

      test('cx returns value from env', () {
        expect(ApiConfig.cx, equals('test_cx_456'));
      });

      test('apiKey returns empty string when env var missing', () {
        dotenv.testLoad(fileInput: '');
        expect(ApiConfig.apiKey, equals(''));
      });

      test('cx returns empty string when env var missing', () {
        dotenv.testLoad(fileInput: '');
        expect(ApiConfig.cx, equals(''));
      });
    });

    group('sanitizeQuery', () {
      test('preserves normal location names', () {
        expect(ApiConfig.sanitizeQuery('Taj Mahal'), equals('Taj Mahal'));
      });

      test('preserves names with commas and periods', () {
        expect(
            ApiConfig.sanitizeQuery('Paris, France'), equals('Paris, France'));
      });

      test('preserves hyphens', () {
        expect(ApiConfig.sanitizeQuery('Kuala-Lumpur'), equals('Kuala-Lumpur'));
      });

      test('strips special characters', () {
        expect(ApiConfig.sanitizeQuery('Taj Mahal<script>'), equals('Taj Mahalscript'));
      });

      test('strips SQL injection attempts', () {
        expect(ApiConfig.sanitizeQuery("'; DROP TABLE--"), equals('DROP TABLE--'));
      });

      test('trims whitespace', () {
        expect(ApiConfig.sanitizeQuery('  Eiffel Tower  '), equals('Eiffel Tower'));
      });

      test('handles empty string', () {
        expect(ApiConfig.sanitizeQuery(''), equals(''));
      });

      test('strips emojis and unicode symbols', () {
        expect(ApiConfig.sanitizeQuery('Paris 🗼'), equals('Paris'));
      });
    });

    group('buildSearchUrl', () {
      test('builds correct URL with query', () {
        final url = ApiConfig.buildSearchUrl('Taj Mahal');
        expect(url, contains('customsearch.googleapis.com'));
        expect(url, contains('key=test_api_key_123'));
        expect(url, contains('cx=test_cx_456'));
        expect(url, contains('searchType=image'));
        expect(url, contains('imgSize=HUGE'));
        expect(url, contains('panoramic%20image'));
        expect(url, contains('Taj%20Mahal'));
      });

      test('URL-encodes the query parameter', () {
        final url = ApiConfig.buildSearchUrl('New York, USA');
        expect(url, contains('New%20York%2C%20USA'));
      });

      test('sanitizes query before building URL', () {
        final url = ApiConfig.buildSearchUrl('Paris<script>');
        expect(url, isNot(contains('<')));
        expect(url, isNot(contains('>')));
      });
    });
  });
}

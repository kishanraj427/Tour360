import 'package:flutter_test/flutter_test.dart';
import 'package:tour360/models/place.dart';

void main() {
  group('Place', () {
    test('creates instance with required fields', () {
      final place = Place(name: 'Taj Mahal', image: 'https://example.com/taj.jpg');
      expect(place.name, equals('Taj Mahal'));
      expect(place.image, equals('https://example.com/taj.jpg'));
    });

    test('fields are mutable', () {
      final place = Place(name: 'Old Name', image: 'old.jpg');
      place.name = 'New Name';
      place.image = 'new.jpg';
      expect(place.name, equals('New Name'));
      expect(place.image, equals('new.jpg'));
    });

    test('handles empty strings', () {
      final place = Place(name: '', image: '');
      expect(place.name, isEmpty);
      expect(place.image, isEmpty);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:tour360/utils/store.dart';

void main() {
  group('Store', () {
    group('mostSearchedPlaces', () {
      test('contains 8 places', () {
        expect(mostSearchedPalces, hasLength(8));
      });

      test('each place has non-empty name', () {
        for (final place in mostSearchedPalces) {
          expect(place.name, isNotEmpty, reason: 'Place name should not be empty');
        }
      });

      test('each place has non-empty image URL', () {
        for (final place in mostSearchedPalces) {
          expect(place.image, isNotEmpty,
              reason: 'Place image should not be empty');
        }
      });

      test('contains Taj Mahal', () {
        expect(
            mostSearchedPalces.any((p) => p.name.contains('Taj Mahal')), isTrue);
      });

      test('contains Eiffel Tower', () {
        expect(mostSearchedPalces.any((p) => p.name.contains('Eiffel Tower')),
            isTrue);
      });
    });

    group('topPlaces', () {
      test('is not empty', () {
        expect(topPlaces, isNotEmpty);
      });

      test('each place has non-empty name', () {
        for (final place in topPlaces) {
          expect(place.name, isNotEmpty);
        }
      });

      test('each place has non-empty image URL', () {
        for (final place in topPlaces) {
          expect(place.image, isNotEmpty);
        }
      });

      test('has no duplicate names', () {
        final names = topPlaces.map((p) => p.name).toList();
        expect(names.length, equals(names.toSet().length),
            reason: 'topPlaces should not have duplicate names');
      });
    });

    group('searchList', () {
      test('contains a substantial number of entries', () {
        expect(searchList.length, greaterThanOrEqualTo(200));
      });

      test('all entries are non-empty strings', () {
        for (final term in searchList) {
          expect(term, isNotEmpty);
        }
      });

      test('unique entries are a significant portion', () {
        final uniqueTerms = searchList.toSet();
        expect(uniqueTerms.length, greaterThanOrEqualTo(200),
            reason: 'searchList should have many unique entries');
      });

      test('contains well-known landmarks', () {
        expect(searchList.any((s) => s.contains('Taj Mahal')), isTrue);
      });
    });
  });
}

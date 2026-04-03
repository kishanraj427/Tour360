import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tour360/utils/palatte.dart';
import 'package:tour360/utils/strings.dart';

void main() {
  group('Strings', () {
    test('welcome is defined', () {
      expect(Strings.welcome, equals('Welcome'));
    });

    test('toTheWorldOfTour360 is defined', () {
      expect(Strings.toTheWorldOfTour360, equals('To the world of Tour 360'));
    });

    test('topSearches is defined', () {
      expect(Strings.topSearches, equals('Top Searches'));
    });

    test('popularPlaces is defined', () {
      expect(Strings.popularPlaces, equals('Popular Places'));
    });

    test('searchAnyPlace is defined', () {
      expect(Strings.searchAnyPlace, equals('Search any place...'));
    });

    test('searchPlace is defined', () {
      expect(Strings.searchPlace, equals('Search Place'));
    });
  });

  group('Palatte', () {
    test('backgroundColor is light grey', () {
      expect(Palatte.backgroundColor, equals(Colors.grey.shade100));
    });

    test('green is green', () {
      expect(Palatte.green, equals(Colors.green));
    });

    test('white is white', () {
      expect(Palatte.white, equals(Colors.white));
    });
  });
}

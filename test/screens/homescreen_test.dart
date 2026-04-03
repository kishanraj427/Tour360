import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tour360/screens/homescreen.dart';
import 'package:tour360/utils/strings.dart';

import '../test_helpers.dart';

void main() {
  setUp(() {
    setupMockHttpClient();
    dotenv.testLoad(fileInput: '''
GOOGLE_API_KEY=test_key
GOOGLE_CX=test_cx
''');
  });

  Widget createTestApp() {
    return GetMaterialApp(
      home: const HomeScreen(),
    );
  }

  group('HomeScreen', () {
    testWidgets('renders welcome text', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.text(Strings.welcome), findsOneWidget);
      expect(find.text(Strings.toTheWorldOfTour360), findsOneWidget);
    });

    testWidgets('renders Top Searches section title', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.text(Strings.topSearches), findsOneWidget);
    });

    testWidgets('renders Popular Places section title', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.scrollUntilVisible(
        find.text(Strings.popularPlaces),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(Strings.popularPlaces), findsOneWidget);
    });

    testWidgets('has a green app bar', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(Colors.green));
    });

    testWidgets('renders as a Scaffold with grey background', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(Colors.grey.shade100));
    });
  });
}

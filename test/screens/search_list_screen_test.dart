import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tour360/screens/search_list_screen.dart';

import '../test_helpers.dart';

void main() {
  setUp(() {
    setupMockHttpClient();
    dotenv.testLoad(fileInput: '''
GOOGLE_API_KEY=test_key
GOOGLE_CX=test_cx
''');
  });

  Widget createTestApp({String search = 'Taj Mahal'}) {
    return GetMaterialApp(
      home: SearchListScreen(search: search),
    );
  }

  group('SearchListScreen', () {
    testWidgets('renders app bar with search term', (tester) async {
      await tester.pumpWidget(createTestApp(search: 'Eiffel Tower'));
      // Only pump once - Dio creates async timers we can't resolve in tests
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Eiffel Tower'), findsOneWidget);
    }, skip: false);

    testWidgets('has green app bar', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump(const Duration(milliseconds: 100));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(Colors.green));
    });

    testWidgets('renders within a Scaffold', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('has grey background', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump(const Duration(milliseconds: 100));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(Colors.grey.shade100));
    });

    testWidgets('displays different search terms correctly', (tester) async {
      await tester.pumpWidget(createTestApp(search: 'Mount Fuji'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Mount Fuji'), findsOneWidget);
    });

    testWidgets('app bar has white foreground color', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump(const Duration(milliseconds: 100));

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.foregroundColor, equals(Colors.white));
    });
  });
}

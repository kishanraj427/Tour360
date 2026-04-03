import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tour360/screens/view_screen.dart';

import '../test_helpers.dart';

void main() {
  setUp(() {
    setupMockHttpClient();
    dotenv.testLoad(fileInput: '''
GOOGLE_API_KEY=test_key
GOOGLE_CX=test_cx
''');
  });

  Widget createTestApp({
    String url = 'https://example.com/panorama.jpg',
    String search = 'Taj Mahal',
  }) {
    return GetMaterialApp(
      home: ViewScreen(url: url, search: search),
    );
  }

  group('ViewScreen', () {
    testWidgets('renders location name in header', (tester) async {
      await tester.pumpWidget(createTestApp(search: 'Eiffel Tower'));
      await tester.pump();

      expect(find.text('Eiffel Tower'), findsOneWidget);
    });

    testWidgets('renders back button', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('renders within a Scaffold', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays different location names', (tester) async {
      await tester.pumpWidget(createTestApp(search: 'Great Wall of China'));
      await tester.pump();

      expect(find.text('Great Wall of China'), findsOneWidget);
    });

    testWidgets('back button icon is white', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_back_rounded));
      expect(icon.color, equals(Colors.white));
    });
  });
}

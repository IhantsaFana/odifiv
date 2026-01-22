// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:fivondronana/main.dart';

void main() {
  testWidgets('HomeScreen displays welcome message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HarambatoApp());

    // Verify that our welcome message is displayed.
    expect(find.text('Bienvenue à Harambato'), findsOneWidget);
    expect(find.text('Digitalisation du Scout Protestant'), findsOneWidget);
    expect(find.text('Se déconnecter'), findsOneWidget);
  });
}

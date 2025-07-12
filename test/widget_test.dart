import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weekplanner_pro/app.dart';

void main() {
  testWidgets('App launches and displays UI', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const App());

    // You can adjust the following expectations depending on your actual UI.
    expect(find.byType(App), findsOneWidget);
    expect(find.text('Weekly Planner'), findsOneWidget); // From AppBar title
  });
}

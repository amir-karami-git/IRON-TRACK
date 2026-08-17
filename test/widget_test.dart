// Basic smoke test: verifies the app boots and shows the welcome screen.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:iron_track/app.dart';

void main() {
  testWidgets('App boots and shows the welcome screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const IronTrack());

    expect(find.text('IRON TRACK'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}

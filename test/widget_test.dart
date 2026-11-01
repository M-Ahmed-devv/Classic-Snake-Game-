
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/main.dart' as app;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Snake Classic app launches', (WidgetTester tester) async {
    // Launch the application using its main entry point.
    app.main();

    // Build the first frame.
    await tester.pump();

    // Verify that the application has rendered a Flutter app.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

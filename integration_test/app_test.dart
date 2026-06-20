import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jetlialogistics/main.dart' as app;
import 'package:jetlialogistics/webview_screen.dart';
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Tests', () {
    testWidgets('App launches successfully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify app is launched
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('WebViewScreen is the home screen', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify WebViewScreen is displayed
      expect(find.byType(WebViewScreen), findsOneWidget);
    });

    testWidgets('AppBar shows correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify AppBar elements
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.byIcon(Icons.security), findsOneWidget);
      expect(find.text('Secure'), findsOneWidget);
    });

    testWidgets('Loading indicator appears on start', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Check loading elements
      expect(find.text('Loading Enterprise System'), findsOneWidget);
      expect(find.text('Securely connecting to server...'), findsOneWidget);
    });

    testWidgets('Back button works', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find and tap back button
      final backButton = find.byIcon(Icons.arrow_back_rounded);
      expect(backButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();
    });
  });
}

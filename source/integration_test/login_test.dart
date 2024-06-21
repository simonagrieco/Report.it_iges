import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:report_it/firebase_options.dart';
import 'package:report_it/main.dart' as app;
import 'package:report_it/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TC_GA.2_1', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });
    testWidgets('Formato e-mail non rispettato', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      //campi di input per email e password e accedi
      final emailField = find.byKey(ValueKey('E-mail'));
      final passwordField = find.byKey(ValueKey('Password'));
      final loginButton = find.byKey(ValueKey('Accedi'));

      // Verifica che i widget esistano
      expect(emailField, findsOneWidget, reason: 'Email field not found');
      expect(passwordField, findsOneWidget, reason: 'Password field not found');
      expect(loginButton, findsOneWidget, reason: 'Login button not found');

      //email e password corrette
      await tester.enterText(emailField, '@asd,lolo/.pippo');
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, 'Amm1234@');
      await tester.pumpAndSettle();

      // Tap sul pulsante di login
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(MyApp), findsOneWidget);
    });
  });

  group('TC_GA.2_2', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });
    testWidgets('Email non esistente', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      //campi di input per email e password e accedi
      final emailField = find.byKey(ValueKey('E-mail'));
      final passwordField = find.byKey(ValueKey('Password'));
      final loginButton = find.byKey(ValueKey('Accedi'));

      // Verifica che i widget esistano
      expect(emailField, findsOneWidget, reason: 'Email field not found');
      expect(passwordField, findsOneWidget, reason: 'Password field not found');
      expect(loginButton, findsOneWidget, reason: 'Login button not found');

      //email e password corrette
      await tester.enterText(emailField, 'amm111@gmail.com');
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, 'Amm1234@');
      await tester.pumpAndSettle();

      // Tap sul pulsante di login
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(MyApp), findsOneWidget);
    });
  });

  group('TC_GA.2_3', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });
    testWidgets('Formato password non rispettato', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      //campi di input per email e password e accedi
      final emailField = find.byKey(ValueKey('E-mail'));
      final passwordField = find.byKey(ValueKey('Password'));
      final loginButton = find.byKey(ValueKey('Accedi'));

      // Verifica che i widget esistano
      expect(emailField, findsOneWidget, reason: 'Email field not found');
      expect(passwordField, findsOneWidget, reason: 'Password field not found');
      expect(loginButton, findsOneWidget, reason: 'Login button not found');

      //email e password corrette
      await tester.enterText(emailField, 'amm@gmail.com');
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, 'PassErrata');
      await tester.pumpAndSettle();

      // Tap sul pulsante di login
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(MyApp), findsOneWidget);
    });
  });

  group('TC_GA.2_4', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });
    testWidgets('Password non corretta', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      //campi di input per email e password e accedi
      final emailField = find.byKey(ValueKey('E-mail'));
      final passwordField = find.byKey(ValueKey('Password'));
      final loginButton = find.byKey(ValueKey('Accedi'));

      // Verifica che i widget esistano
      expect(emailField, findsOneWidget, reason: 'Email field not found');
      expect(passwordField, findsOneWidget, reason: 'Password field not found');
      expect(loginButton, findsOneWidget, reason: 'Login button not found');

      //email e password corrette
      await tester.enterText(emailField, 'amm@gmail.com');
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, 'PassErrata12*/');
      await tester.pumpAndSettle();

      // Tap sul pulsante di login
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(MyApp), findsOneWidget);
    });
  });

  group('TC_GA.2_5', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });
    testWidgets('Login effettuato con successo', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      //campi di input per email e password e accedi
      final emailField = find.byKey(ValueKey('E-mail'));
      final passwordField = find.byKey(ValueKey('Password'));
      final loginButton = find.byKey(ValueKey('Accedi'));

      // Verifica che i widget esistano
      expect(emailField, findsOneWidget, reason: 'Email field not found');
      expect(passwordField, findsOneWidget, reason: 'Password field not found');
      expect(loginButton, findsOneWidget, reason: 'Login button not found');

      //email e password corrette
      await tester.enterText(emailField, 'amm@gmail.com');
      await tester.pumpAndSettle();

      await tester.enterText(passwordField, 'Amm1234@');
      await tester.pumpAndSettle();

      // Tap sul pulsante di login
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(MyApp), findsOneWidget);
    });
  });

}

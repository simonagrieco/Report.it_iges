import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:integration_test/integration_test.dart';
import 'package:report_it/firebase_options.dart';
import 'package:report_it/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Inoltro denuncia - Integration Testing', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    //regione
    testWidgets('TC_GD.1_6', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");

      await LoginHelper.login(tester);

      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      // Esegui il pull-to-refresh
      //await performPullToRefresh(tester, find.byType(RefreshIndicator));

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final nomeField = find.byKey(ValueKey('Regione'));
      await waitForElement(tester, nomeField);
      await tester.enterText(nomeField, 'campnia');
      await tester.pumpAndSettle();

      final gesture = await tester
          .startGesture(Offset(0, 300)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -150)); //How much to scroll by
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));

      await tester.pump(Duration(seconds: 10));

      // Trovare messaggio errore
      bool foundError = false;

      if (find
          .text('Par favore, inserisci una regione valida.')
          .evaluate()
          .isNotEmpty) {
        foundError = true;
      }
      await tester.pumpAndSettle();

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });
}

/*Future<void> performPullToRefresh(WidgetTester tester, Finder refreshIndicatorFinder) async {
  expect(refreshIndicatorFinder, findsOneWidget, reason: 'RefreshIndicator not found');

  // Trova il widget RefreshIndicator
  final refreshIndicator = tester.widget<RefreshIndicator>(refreshIndicatorFinder);

  // Trova il child del RefreshIndicator per effettuare il pull-to-refresh
  final childFinder = find.descendant(of: refreshIndicatorFinder, matching: find.byWidget(refreshIndicator.child));

  // Simula il gesto di pull-to-refresh
  await tester.drag(childFinder, const Offset(0.0, 300.0));
  await tester.pump(); // Avvia l'animazione di pull-to-refresh
  await tester.pump(const Duration(seconds: 1)); // Attendi che l'animazione di refresh sia completata
} */

Future<void> ensureVisibleAndTap(WidgetTester tester, Finder widget) async {
  await waitForElement(tester, widget);

  // Scrolla fino al widget se necessario
  await tester.ensureVisible(widget);

  // Verifica che il widget sia visibile
  expect(widget, findsOneWidget, reason: widget.toString() + ' not found');

  // Clicca sul widget
  await tester.tap(widget);
  await tester.pumpAndSettle();
}

Future<void> waitForElement(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump();
    if (tester.any(finder)) return;
  }
  throw TimeoutException('Element not found: $finder');
}

Future<void> waitAndTap(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 30)}) async {
  await waitForElement(tester, finder, timeout: timeout);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

class LoginHelper {
  static Future<void> login(WidgetTester tester) async {
    // Trova il pulsante SPID
    final spidButton = find.byKey(ValueKey('Spid'));
    await waitAndTap(tester, spidButton);

    // Trova i campi di input per email e password e il pulsante di accesso
    final emailField = find.byKey(ValueKey('E-mail'));
    final passwordField = find.byKey(ValueKey('Password'));
    final loginButton = find.byKey(ValueKey('Accedi'));

    // Verifica che i widget esistano
    await waitForElement(tester, emailField);
    expect(emailField, findsOneWidget, reason: 'Email field not found');
    await waitForElement(tester, passwordField);
    expect(passwordField, findsOneWidget, reason: 'Password field not found');
    await waitForElement(tester, loginButton);
    expect(loginButton, findsOneWidget, reason: 'Login button not found');

    // Email e password corrette
    await tester.enterText(emailField, 'alb.genovese@gmail.com');
    await tester.pumpAndSettle();

    await tester.enterText(passwordField, 'Pikachu10');
    await tester.pumpAndSettle();

    // Tap sul pulsante di login
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  }
}

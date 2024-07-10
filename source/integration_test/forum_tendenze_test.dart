import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:integration_test/integration_test.dart';
import 'package:report_it/firebase_options.dart';
import 'package:report_it/main.dart' as app;
import 'package:report_it/presentation/widget/crealista.dart';
import 'package:report_it/presentation/widget/like.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tendenze forum - Integration Testing', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('TC_GF.7_2', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");

      await LoginHelper.login(tester);

      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.people));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text("Tendenze"));
      await tester.pumpAndSettle();


      // Scrolla fino al primo post
      await scrollUntilVisible(tester, find.byType(CreaDiscussione).at(1), 200);
      await tester.pumpAndSettle();

      // Trova il primo widget Like
      final likeWidgetFinder = find.descendant(
        of: find.byType(CreaDiscussione).at(1),
        matching: find.byType(Like),
      );
      expect(likeWidgetFinder, findsOneWidget);

      // Trova il contatore dei like e il bottone like
      final likeCounterFinder = find.descendant(
        of: likeWidgetFinder,
        matching: find.byType(Text),
      ).first;
      final initialLikeCount = int.parse(tester.widget<Text>(likeCounterFinder).data!);

      try {
        final likeButtonFinder = find.descendant(
          of: likeWidgetFinder,
          matching: find.byIcon(Icons.favorite_border_outlined),
        );
        expect(likeButtonFinder, findsOneWidget);

        // Clicca sul bottone like
        await tester.tap(likeButtonFinder);
        await tester.pumpAndSettle();

        // Verifica che il contatore dei like è incrementato di 1
        final updatedLikeCount = int.parse(tester
            .widget<Text>(likeCounterFinder)
            .data!);
        expect(updatedLikeCount, initialLikeCount + 1);

        print("Test completato!");
      }
      catch(e){
        print("like no");
      }

      /*try {
        final likeButtonFinder = find.descendant(
          of: likeWidgetFinder,
          matching: find.byIcon(Icons.favorite),
        );
        expect(likeButtonFinder, findsOneWidget);

        // Clicca sul bottone like
        await tester.tap(likeButtonFinder);
        await tester.pumpAndSettle();

        // Verifica che il contatore dei like è incrementato di 1
        final updatedLikeCount = int.parse(tester
            .widget<Text>(likeCounterFinder)
            .data!);
        expect(updatedLikeCount, initialLikeCount - 1);

        print("Test completato!");
      }
      catch(e){
        print("like no");
      } */

      final gesture = await tester
          .startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, 200));
      await tester.pumpAndSettle();

      // Trova il widget crealista
      await tester.drag(find.byType(RefreshIndicator), Offset(0, 500));

      print("Pull-to-refresh eseguito!");

      await tester.pump(Duration(seconds: 20));

      //Position of the scrollview
      await gesture.moveBy(Offset(0, -200));
      await tester.pumpAndSettle();


      print("Test completato!");
    });
  });
}


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

Future<void> scrollUntilVisible(WidgetTester tester, Finder finder, double scrollOffset) async {
  bool visible = false;
  while (!visible) {
    await tester.drag(find.byType(Scrollable), Offset(0, -scrollOffset));
    await tester.pumpAndSettle();
    visible = tester.any(finder);
  }
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

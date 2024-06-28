import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax/iconsax.dart';
import 'package:integration_test/integration_test.dart';
import 'package:report_it/firebase_options.dart';
import 'package:report_it/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TC_GA.2_1"', () {

    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    );

    testWidgets('TC_GA.2_1', (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();

      print("sono qua!");

      await LoginHelper.login(tester);

      print("sono qua 2!");

      await tester.pump(Duration(seconds: 15));

      print("sono qua 3!");

      // Trova il BottomNavigationBar
      final bottomNavigationBar = find.byType(SnakeNavigationBar);
      expect(bottomNavigationBar, findsOneWidget, reason: 'BottomNavigationBar not found');

      // Stampa la gerarchia dei widget
      // debugDumpApp();

      // Trova il bottone 'Denunce'
      final denunceButton = find.byIcon(Iconsax.document_normal);
      expect(denunceButton, findsOneWidget, reason: 'Denunce button not found');
      await tester.tap(denunceButton);

      print("Trovato 'Denunce'");

      await tester.pumpAndSettle();

      final inoltraButton1 = find.byKey(ValueKey('Inoltra'),);
      await tester.tap(inoltraButton1);

      await tester.pumpAndSettle();


      final nomeField = find.byKey(ValueKey('Nome'),);
      await tester.enterText(nomeField, 'Alberto');
      await tester.pumpAndSettle();



    });

  });

}


class LoginHelper {
  static Future<void> login(WidgetTester tester) async {

    // Trova il pulsante SPID
    final spidButton = find.byKey(ValueKey('Spid'));
    expect(spidButton, findsOneWidget, reason: 'Spid button not found');

    // Tap sul pulsante di login
    await tester.tap(spidButton);
    await tester.pumpAndSettle();

    // Trova i campi di input per email e password e il pulsante di accesso
    final emailField = find.byKey(ValueKey('E-mail'));
    final passwordField = find.byKey(ValueKey('Password'));
    final loginButton = find.byKey(ValueKey('Accedi'));

    // Verifica che i widget esistano
    expect(emailField, findsOneWidget, reason: 'Email field not found');
    expect(passwordField, findsOneWidget, reason: 'Password field not found');
    expect(loginButton, findsOneWidget, reason: 'Login button not found');

    //email e password corrette
    await tester.enterText(emailField, 'alb.genovese@gmail.com');
    await tester.pumpAndSettle();

    await tester.enterText(passwordField, 'Pikachu10');
    await tester.pumpAndSettle();

    // Tap sul pulsante di login
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Aspetta che il primo SnackBar ("Validazione in corso...") venga mostrato e poi scompaia
    await tester.pump(Duration(seconds: 20));
    //await tester.pumpAndSettle();
  }
}

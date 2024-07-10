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

  //TEST INDIRIZZO (formato)
  group('TC_GD.1_1', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Formato indirizzo non rispettato', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();


      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final indirizzoField = find.byKey(ValueKey('Indirizzo'));
      await waitForElement(tester, indirizzoField);
      await tester.enterText(indirizzoField, 'Via Traversa Taurano');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci un indirizzo valido.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST INDIRIZZO (lunghezza)
  group('TC_GD.1_2', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Lunghezza indirizzo non rispettata', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final indirizzoField = find.byKey(ValueKey('Indirizzo'));
      await waitForElement(tester, indirizzoField);
      await tester.enterText(indirizzoField, 'Via Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean fermentum mi a nibh rutrum, sed scelerisque enim efficitur. Fusce accumsan id mi quis hendrerit. Vivamus ut tincidunt orci, 46');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci un indirizzo valido.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST CAP
  group('TC_GD.1_3', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Formato CAP non rispettato', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();


      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final capField = find.byKey(ValueKey('CAP'));
      await waitForElement(tester, capField);
      await tester.enterText(capField, '84016777');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci un CAP valido.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST CELLULARE
  group('TC_GD.1_4', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Formato numero di cellulare non rispettato', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final numeroField = find.byKey(ValueKey('Numero telefonico'));
      await waitForElement(tester, numeroField);
      await tester.enterText(numeroField, '+3938021107031213422');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci un numero telefonico valido.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST PROVINCIA
  group('TC_GD.1_5', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Formato provincia non rispettato', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final provinciaField = find.byKey(ValueKey('Provincia'));
      await waitForElement(tester, provinciaField);
      await tester.enterText(provinciaField, 'SAS');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci una provincia valida.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST REGIONE
  group('TC_GD.1_6', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Regione non valida', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final regioneField = find.byKey(ValueKey('Regione'));
      await waitForElement(tester, regioneField);
      await tester.enterText(regioneField, 'Cmpania');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci una regione valida.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST EMAIL
  group('TC_GD.1_7', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Formato mail non rispettato', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final mailField = find.byKey(ValueKey('E-mail'));
      await waitForElement(tester, mailField);
      await tester.enterText(mailField, 'mailerrata@dominioincompleto');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci una e-mail valida.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST CATEGORIA DISCRIMINAZIONE
  group('TC_GD.1_8', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Categoria disciminazione non trovata', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();


    });
  });

  //TEST NOME VITTIMA
  group('TC_GD.1_9', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Lunghezza nome vittima non rispettata', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final nomevittimaField = find.byKey(ValueKey('Nome vittima'));
      await waitForElement(tester, nomevittimaField);
      await tester.enterText(nomevittimaField, 'Lfjjfieqeofeebfbdwfbwkffkfkbsafjfwnkdjwqjfb');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci un nome valido.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST COGNOME VITTIMA
  group('TC_GD.1_10', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Lunghezza cognome vittima non rispettata', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final cognomevittimaField = find.byKey(ValueKey('Cognome vittima'));
      await waitForElement(tester, cognomevittimaField);
      await tester.enterText(cognomevittimaField, 'Ordkwkwjwighwihihewifeqifheienqeioioio');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci un cognome valido.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST DENUNCIATO
  group('TC_GD.1_11', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Lunghezza campo denunciato non rispettata', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final nomeoppField = find.byKey(ValueKey('Nome oppressore'));
      await waitForElement(tester, nomeoppField);
      await tester.enterText(nomeoppField, 'Giovanni Jimmy FabioElioAlessandro Rapa Sbacco');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci un nome valido.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST DESCRIZIONE
  group('TC_GD.1_12', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('lunghezza descrizione non rispettata', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final descrizioneField = find.byKey(ValueKey('Vicenda'));
      await waitForElement(tester, descrizioneField);
      await tester.enterText(descrizioneField, 'Il signor Jimmy Sbacco il giorno 20/03/2024 ha negato al mio amico Gonzalo il servizio nel suo ristorante usando come motivazione che essendo di colore non potesse permettersi di pagare il conto. Non solo: ha osato paragonarmi ai primati davanti a tutta la sala e davanti a mia figlia, facendomi cascare in un profondo imbarazzo. Siamo stati allontanati bruscamente e con violenza nei modi; nessuno in sala si è opposto al trattamento e lo ritengo disumano.');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci una descrizione valida.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST VALORE CONSENSO
  group('TC_GD.1_13', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Valore consenso non riconosciuto', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();


    });
  });


  //TEST VALORE PRATICA
  group('TC_GD.1_14', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Valore pratica archiviata non riconosciuto', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      // Verifica che nessuna opzione sia selezionata all'inizio
      expect(find.byType(RadioListTile), findsNWidgets(2)); // Assicura che ci siano due Radio
      expect(find.byWidgetPredicate((widget) => widget is RadioListTile && widget.value == "Si" && widget.groupValue == null), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is RadioListTile && widget.value == "No" && widget.groupValue == null), findsOneWidget);

      // Simula il tap sulla prima opzione
      await tester.tap(find.text('Sì'));
      await tester.pumpAndSettle();

      // Verifica che l'opzione 1 sia stata selezionata
      expect(find.byWidgetPredicate((widget) => widget is RadioListTile && widget.value == "Si" && widget.groupValue == "alreadyFiledRadio"), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is RadioListTile && widget.value == "No" && widget.groupValue == null), findsNothing);

      // Simula il tap sulla seconda opzione
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      // Verifica che l'opzione 2 sia stata selezionata
      expect(find.byWidgetPredicate((widget) => widget is RadioListTile && widget.value == "Si" && widget.groupValue == null), findsNothing);
      expect(find.byWidgetPredicate((widget) => widget is RadioListTile && widget.value == "No" && widget.groupValue == "alreadyFiledRadio"), findsOneWidget);
    });
  });

  //TEST CONTENUTO MULTIMEDIALE
  group('TC_GD.1_15', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Formato contenuto multimediale non è valido', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

    });
  });

  //TEST NOME DENUNCIANTE
  group('TC_GD.1_16', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Lunghezza nome denunciante non rispettata', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final nomeField = find.byKey(ValueKey('Nome'));
      await waitForElement(tester, nomeField);
      await tester.enterText(nomeField, 'AlbertoAlbertoAlbertoAlberto');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci un nome valido.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST COGNOME DENUNCIANTE
  group('TC_GD.1_17', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Lunghezza cognome denunciante non rispettata', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      final cognomeDenField = find.byKey(ValueKey('Cognome'));
      await waitForElement(tester, cognomeDenField);
      await tester.enterText(cognomeDenField, 'GenoveseGenoveseGenoveseGenovese');
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset(0, 300));
      await gesture.moveBy(Offset(0, -150));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.byKey(ValueKey('Continua1')));
      await tester.pumpAndSettle();

      // Trovare messaggio errore
      bool foundError = false;

      for (int i = 0; i < 10; i++) {
        await tester.pump();
        if (find
            .text('Per favore, inserisci un cognome valido.')
            .evaluate()
            .isNotEmpty) {
          foundError = true;
          break;
        }
        await tester.pump(Duration(milliseconds: 100));
      }

      // Verifica che il messaggio di errore sia mostrato
      expect(foundError, true);
    });
  });

  //TEST CORRETTO
  group('TC_GD.1_18', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Denuncia inoltrata con successo', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      print("Inizio!");
      await LoginHelper.login(tester);
      print("Loggato!");

      await ensureVisibleAndTap(tester, find.byIcon(Iconsax.document_normal));
      await tester.pumpAndSettle();

      await ensureVisibleAndTap(tester, find.text('Inoltra'));
      await tester.pumpAndSettle();

      // Simula il tap sul pulsante "Inoltra"
      final inoltraButton = find.byKey(ValueKey('InoltraDenuncia'));
      expect(inoltraButton, findsOneWidget);
      await tester.tap(inoltraButton);
      await tester.pumpAndSettle();

      // Attendi che il toast venga visualizzato
      await tester.runAsync(() async {
        await tester.pump(const Duration(
            milliseconds: 500));
        expect(find.text('Inoltro avvenuto correttamente!'), findsOneWidget);
      });

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

  // Verifica che ci sia un solo widget trovato
  expect(widget, findsOneWidget, reason: widget.toString() + ' not found or too many found');

  // Scrolla fino al widget se necessario
  await tester.ensureVisible(widget);

  // Verifica che il widget sia visibile
  //expect(widget, findsOneWidget, reason: widget.toString() + ' not found');

  // Clicca sul widget
  await tester.tap(widget);
  await tester.pumpAndSettle();
}

Future<void> waitForElement(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 30)}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump();
    if (tester.any(finder)) {
      // Verifica che ci sia un solo widget trovato
      if (finder
          .evaluate()
          .length == 1) return;
      throw StateError('Too many elements found: $finder');
    }
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

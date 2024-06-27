import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:report_it/application/entity/entity_GA/spid_entity.dart';
import 'package:report_it/application/entity/entity_GA/super_utente.dart';
import 'package:report_it/application/entity/entity_GA/tipo_utente.dart';
import 'package:report_it/firebase_options.dart';
import 'package:report_it/main.dart' as app;
import 'package:report_it/main.dart';
import 'package:report_it/presentation/pages/pages_GD/inoltro_denuncia_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TC_GD.1_1', () {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Chiave globale per il Form
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Test inoltro denuncia', (WidgetTester tester) async {
      // Crea istanze di SuperUtente e SPID
      SuperUtente utente = SuperUtente(
        'id',
        TipoUtente.Utente,
        cap: '84016',
        provincia: 'NA',
        indirizzo: 'Via Traversa Taurano, 46',
        citta: 'Napoli',
      );
      SPID spid = SPID(
        'GNVLRT01R10F839G',
        'Alberto',
        'Genovese',
        'Napoli',
        DateTime(2001, 10, 10),
        'Maschio',
        'Carta Identità',
        'AY1234567',
        'Via Traversa Taurano, 46',
        'NA',
        DateTime(2025, 10, 10),
        '+393802110703',
        'alb.genovese@gmail.com',
        'Pikachu10',
      );

      await tester.pumpWidget(MaterialApp(
        home: InoltroDenuncia(utente: utente, spid: spid), // Naviga direttamente alla pagina
      ));
      await tester.pumpAndSettle();


      final nomeField = find.byKey(ValueKey('Nome'));

      // Verifica che i widget esistano
      expect(nomeField, findsOneWidget, reason: 'Nome field not found');

      print('Trova il campo nome: $nomeField');

      //email e password corrette
      await tester.enterText(nomeField, 'Alberto');
      await tester.pumpAndSettle();

      expect(find.byType(InoltroDenuncia), findsOneWidget);

    });
  });
}

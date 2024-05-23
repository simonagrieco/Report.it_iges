import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_it/application/entity/entity_GA/super_utente.dart';
import 'package:report_it/firebase_options.dart';
import 'package:report_it/presentation/pages/pages_GA/authentication_wrapper.dart';
import 'package:report_it/presentation/widget/styles.dart';
import 'application/repository/authentication_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Chiama la funzione per aggiungere il campo a tutti i documenti
  await addFieldToAllDocuments();

  runApp(MyApp());
}

Future<void> addFieldToAllDocuments() async {
  // Riferimento alla tua raccolta
  CollectionReference collectionRef = FirebaseFirestore.instance.collection('Denuncia');

  try {
    // Ottieni tutti i documenti della raccolta
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Itera attraverso tutti i documenti
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Aggiungi il nuovo campo a ciascun documento
      await doc.reference.update({'RegioneDenunciante': 'null'});
      print('Campo aggiunto a documento con ID: ${doc.id}');
    }
  } catch (e) {
    print('Errore durante l\'aggiunta del campo: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
        StreamProvider<SuperUtente?>(
            create: (_) =>
                AuthenticationService(FirebaseAuth.instance).superUtenteStream,
            initialData: null)
      ],
      child: MaterialApp(
        title: 'Report.it',
        debugShowCheckedModeBanner: false,
        theme: ThemeText.theme,
        home: Scaffold(
          body: AuthenticationWrapper(),
        ),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('it')],
      ),
    );
  }
}

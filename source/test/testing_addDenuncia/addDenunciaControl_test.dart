import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:report_it/data/models/denuncia_dao.dart';
import 'package:report_it/application/entity/entity_GD/categoria_denuncia.dart';
import 'package:report_it/application/entity/entity_GD/denuncia_entity.dart';
import 'package:report_it/application/entity/entity_GD/stato_denuncia.dart';

import 'addDenunciaControl_test.mocks.dart';

@GenerateMocks([
  DenunciaDao
], customMocks: [
  MockSpec<DenunciaDao>(as: #MockDenunciaDaoRelaxed),
])
void main() {
  late DenunciaDao dao;
  late MockUser user;
  late MockFirebaseAuth auth;

  setUp(() {
    dao = MockDenunciaDao();
    user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    auth = MockFirebaseAuth(mockUser: user, signedIn: true);
  });

  funzioneTest({
    required String nomeDenunciante,
    required String cognomeDenunciante,
    required String regioneDenunciante, //AGGIUNTO
    required String indirizzoDenunciante,
    required String capDenunciante,
    required String provinciaDenunciante,
    required String cellulareDenunciante,
    required String emailDenunciante,
    required String? tipoDocDenunciante,
    required String? numeroDocDenunciante,
    required Timestamp scadenzaDocDenunciante,
    required CategoriaDenuncia categoriaDenuncia,
    required String nomeVittima,
    required String denunciato,
    required String descrizione,
    required String cognomeVittima,
    required bool consenso,
    required bool? alreadyFiled,
    required List<String> mediaUrls,
  }) {
    Timestamp today = Timestamp.now();
    final regexEmail = RegExp(r"^[A-z0-9\.\+_-]+@[A-z0-9\._-]+\.[A-z]{2,6}$");
    final regexIndirizzo = RegExp(r"^[a-zA-Z+\s]+[,]?\s?[0-9]+$");
    final regexCap = RegExp(r"^[0-9]{5}$");
    final regexProvincia = RegExp(r"^[a-zA-Z]{2}$");
    final regexCellulare =
        RegExp(r"^((00|\+)39[\. ]??)??3\d{2}[\. ]??\d{6,7}$");

    final List<String> regioniItaliane = [
      "Abruzzo",
      "Basilicata",
      "Calabria",
      "Campania",
      "Emilia-Romagna",
      "Friuli Venezia Giulia",
      "Lazio",
      "Liguria",
      "Lombardia",
      "Marche",
      "Molise",
      "Piemonte",
      "Puglia",
      "Sardegna",
      "Sicilia",
      "Toscana",
      "Trentino Alto Adige",
      "Umbria",
      "Valle d'Aosta",
      "Veneto"
    ];
    String? valueLowerCase = regioneDenunciante.toLowerCase();
    bool isValidRegion = regioniItaliane
        .any((regione) => regione.toLowerCase() == valueLowerCase);

    final List<String> allowedExtensions = [
      'jpg',
      'jpeg',
      'png',
      'mp3',
      'mp4',
      'pdf',
      'doc',
      'docx',
      'webp'
    ];

    final User? user = auth.currentUser;
    if (user == null) {
    } else {}
    if (nomeDenunciante.length > 30) {
      return ("Errore: lunghezza nome denunciate non rispettata");
    }
    if (cognomeDenunciante.length > 30) {
      return ("Errore: lunghezza cognome denunciate non rispettata");
    }
    if (indirizzoDenunciante.length > 50) {
      return ("Errore: lunghezza indirizzo non rispettata");
    }
    if (!regexIndirizzo.hasMatch(indirizzoDenunciante)) {
      return ("Errore: formato indirizzo non rispettato");
    }
    if (!regexCap.hasMatch(capDenunciante)) {
      return ("Errore: formato CAP non rispettato");
    }
    if (!regexProvincia.hasMatch(provinciaDenunciante)) {
      return ("Errore: formato provincia non rispettato");
    }
    if (!regexCellulare.hasMatch(cellulareDenunciante)) {
      return ("Errore: formato numero cellulare non rispettato");
    }
    if (!regexEmail.hasMatch(emailDenunciante)) {
      return ("Errore: formato mail non rispettato");
    }
    if (tipoDocDenunciante == "Carta Identita" ||
        tipoDocDenunciante == "Patente") {
      if ((numeroDocDenunciante?.length)! > 10) {
        return ("Errore: lunghezza codice documento non rispettata");
      }
      //aggiungere
    } else {
      return ("Errore: formato documento non valido");
    }

    if (scadenzaDocDenunciante.toDate().compareTo(DateTime.now()) <= 0) {
      return ("Errore: documento scaduto");
    }
    try {
      CategoriaDenuncia.values.byName(categoriaDenuncia.name);
    } catch (e) {
      return ("Errore: categoria di discriminazione non trovata");
    }
    if (nomeVittima.length > 30) {
      return ("Errore: lunghezza nome vittima non rispettata");
    }
    if (denunciato.length > 60) {
      return ("Errore: lunghezza del campo denunciato non rispettata");
    }
    if (descrizione.length > 1000) {
      return ("Errore: lunghezza descrizione non rispettata");
    }
    if (cognomeVittima.length > 30) {
      return ("Errore: lunghezza cognome vittima non rispettata");
    }
    if (consenso == false) {
      return ("Errore: valore consenso non riconosciuto");
    }
    if (alreadyFiled == null) {
      return ("Errore: valore pratica archiviata non riconosciuto");
    }

    //Controllo regione (aggiunto)
    if (!isValidRegion) {
      return 'Errore: regione non valida';
    }
    //Controllo mediaUrls
    for (var url in mediaUrls) {
      if (url.isNotEmpty) {
        var extension = url.split('.').last.toLowerCase();
        if (!allowedExtensions.contains(extension)) {
          return "Errore: formato media non valido";
        }
      }
    }

    Denuncia denuncia = Denuncia(
      id: null,
      nomeDenunciante: nomeDenunciante,
      cognomeDenunciante: cognomeDenunciante,
      indirizzoDenunciante: indirizzoDenunciante,
      capDenunciante: capDenunciante,
      provinciaDenunciante: provinciaDenunciante,
      cellulareDenunciante: cellulareDenunciante,
      emailDenunciante: emailDenunciante,
      tipoDocDenunciante: tipoDocDenunciante!,
      numeroDocDenunciante: numeroDocDenunciante!,
      scadenzaDocDenunciante: scadenzaDocDenunciante,
      categoriaDenuncia: categoriaDenuncia,
      nomeVittima: nomeVittima,
      denunciato: denunciato,
      descrizione: descrizione,
      cognomeVittima: cognomeVittima,
      alreadyFiled: alreadyFiled,
      consenso: consenso,
      cognomeUff: null,
      coordCaserma: null,
      dataDenuncia: today,
      idUff: null,
      idUtente: user!.uid,
      nomeCaserma: null,
      nomeUff: null,
      statoDenuncia: StatoDenuncia.NonInCarico,
      tipoUff: null,
      indirizzoCaserma: null,
      gradoUff: null,
      regioneDenunciante: regioneDenunciante,
      //AGGIUNTO
      mediaUrls: mediaUrls, //Aggiunto per img
    );
    when(dao.addDenuncia(denuncia)).thenAnswer((realInvocation) => Future((() {
          return "someuid";
        })));

    dao.addDenuncia(denuncia).then((String id) {
      denuncia.setId = id;
      DenunciaDao().updateId(denuncia.getId);
    });

    return "Corretto";
  }

  group("AddDenuncia", () {
    //formato indirizzo
    test("TC_GD.1.1_1 ", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania";
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
            cognomeDenunciante: cognomeDenunciante,
            regioneDenunciante: regioneDenunciante,
            //AGGIUNTO
            indirizzoDenunciante: indirizzoDenunciante,
            provinciaDenunciante: provinciaDenunciante,
            cellulareDenunciante: cellulareDenunciante,
            emailDenunciante: emailDenunciante,
            tipoDocDenunciante: tipoDocDenunciante,
            numeroDocDenunciante: numeroDocDenunciante,
            scadenzaDocDenunciante: scadenzaDocDenunciante,
            categoriaDenuncia: categoriaDenuncia,
            nomeVittima: nomeVittima,
            denunciato: denunciato,
            descrizione: descrizione,
            cognomeVittima: cognomeVittima,
            consenso: consenso,
            alreadyFiled: alreadyFiled,
            nomeDenunciante: nomeDenunciante,
            capDenunciante: capDenunciante,
            mediaUrls: mediaUrls,
          ) ==
          "Errore: formato indirizzo non rispettato");
    }));

    //lunghezza indirizzo
    test("TC_GD.1.1_2", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania";
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante =
          "Via Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean fermentum mi a nibh rutrum, sed scelerisque enim efficitur. Fusce accumsan id mi quis hendrerit. Vivamus ut tincidunt orci, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];;

      assert(await funzioneTest(
            cognomeDenunciante: cognomeDenunciante,
            indirizzoDenunciante: indirizzoDenunciante,
            provinciaDenunciante: provinciaDenunciante,
            cellulareDenunciante: cellulareDenunciante,
            emailDenunciante: emailDenunciante,
            tipoDocDenunciante: tipoDocDenunciante,
            numeroDocDenunciante: numeroDocDenunciante,
            scadenzaDocDenunciante: scadenzaDocDenunciante,
            categoriaDenuncia: categoriaDenuncia,
            nomeVittima: nomeVittima,
            denunciato: denunciato,
            descrizione: descrizione,
            cognomeVittima: cognomeVittima,
            consenso: consenso,
            alreadyFiled: alreadyFiled,
            nomeDenunciante: nomeDenunciante,
            capDenunciante: capDenunciante,
            regioneDenunciante: regioneDenunciante,
            mediaUrls: mediaUrls, //AGGIUNTO
          ) ==
          "Errore: lunghezza indirizzo non rispettata");
    }));

    //formato cap
    test("TC_GD.1.1_3", (() async {
      String capDenunciante = "84016777";
      String regioneDenunciante = "Campania";
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];;

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              //AGGIUNTO
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: formato CAP non rispettato");
    }));

    //formato num cellulare
    test("TC_GD.1.1_4", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110704543534534534";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];;

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              //AGGIUNTO
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: formato numero cellulare non rispettato");
    }));

    //formato provincia
    test("TC_GD.1.1_5", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SUS";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];;

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: formato provincia non rispettato");
    }));

    //AGGIUNTI PER REGIONE
    test("TC_GD.1.1_6", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "campnia"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "123456";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];;

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              //Aggiunto
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: regione non valida");
    }));

    //formato mail
    test("TC_GD.1.1_7", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "mailSbagliata@dominioincompleto";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];;

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: formato mail non rispettato");
    }));

    //categoria discriminazione
    /*test("TC_GD.1.1_8", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania";
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
      Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Nullo; //modificare
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
          cognomeDenunciante: cognomeDenunciante,
          regioneDenunciante: regioneDenunciante,
          indirizzoDenunciante: indirizzoDenunciante,
          provinciaDenunciante: provinciaDenunciante,
          cellulareDenunciante: cellulareDenunciante,
          emailDenunciante: emailDenunciante,
          tipoDocDenunciante: tipoDocDenunciante,
          numeroDocDenunciante: numeroDocDenunciante,
          scadenzaDocDenunciante: scadenzaDocDenunciante,
          categoriaDenuncia: categoriaDenuncia,
          nomeVittima: nomeVittima,
          denunciato: denunciato,
          descrizione: descrizione,
          cognomeVittima: cognomeVittima,
          consenso: consenso,
          alreadyFiled: alreadyFiled,
          nomeDenunciante: nomeDenunciante,
          capDenunciante: capDenunciante,
          mediaUrls: mediaUrls) ==
          "Errore: categoria di discriminazione non trovata");
    })); */

    //lunghezza nome vittima
    test("TC_GD.1.1_9", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Lfjjfieqeofeebfbdwfbwkffkfkbsafjfwnkdjwqjfb";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: lunghezza nome vittima non rispettata");
    }));

    //lunghezza cognome vittima
    test("TC_GD.1.1_10", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania";
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ordkwkwjwighwihihewifeqifheienqeioioio";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: lunghezza cognome vittima non rispettata");
    }));

    //lunghezza campo denunciato
    test("TC_GD.1.1_11", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato =
          "Giuseppe Fabio Pierferdinando Santini Quondamangelomaria Garibaldi";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: lunghezza del campo denunciato non rispettata");
    }));

    //lunghezza descrizione
    test("TC_GD.1.1_12", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc sed ipsum at mauris pulvinar auctor. Duis sit amet quam tellus. Suspendisse potenti. Cras leo magna, hendrerit vel nisi eget, egestas fringilla tellus. Cras luctus lacus augue, eu accumsan ante dictum et. Nulla tincidunt ligula ut ultrices laoreet. "
          "Aenean congue nec mi a rhoncus. Donec ligula metus, auctor in libero et, maximus pharetra mi. Integer felis dui, accumsan in diam vitae, placerat sollicitudin turpis. Curabitur at augue varius urna tristique lobortis sed quis purus. Ut ultricies, arcu ut luctus fringilla, ante ligula vulputate dui, vel accumsan erat libero ac magna. Aenean ut laoreet mauris, eu tempus tortor. Nullam venenatis risus ut ex suscipit gravida. In imperdiet tortor quis neque pellentesque porta "
          "ac vitae dolor. Ut sagittis ex turpis, sed vulputate mauris scelerisque at.Proin ac massa ut elit suscipit dictum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lobortis ultrices mauris, et eleifend.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: lunghezza descrizione non rispettata");
    }));

    //valore consenso
    test("TC_GD.1.1_13", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = false;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: valore consenso non riconosciuto");
    }));

    //archiviazione
    test("TC_GD.1.1_14", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = null;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: valore pratica archiviata non riconosciuto");
    }));

    //mediaUrls
    test("TC_GD.1.1_15", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = [
        "fileaudio.mp4",
        "documento.pdf",
        "file.html"
      ];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: formato media non valido");
    }));

    //lunghezza nome denunciate
    test("TC_GD.1.1_16", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante =
          "AlbertoAlbertoAlbertoAlbertoAlberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: lunghezza nome denunciate non rispettata");
    }));

    //lunghezza cognome denunciate
    test("TC_GD.1.1_17", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante =
          "GenoveseGenoveseGenoveseGenovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: lunghezza cognome denunciate non rispettata");
    }));

    //formato documento
    test("TC_GD.1.1_18", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "CartaPassaporto";
      String? numeroDocDenunciante = "AY1234567";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: formato documento non valido");
    }));

    //lunghezza codice documento
    test("TC_GD.1.1_19", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "AY1234DDYRHIIDWDIWJQO";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: lunghezza codice documento non rispettata");
    }));

    //data scadenza documento
    test("TC_GD.1.1_20", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "123456";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2010-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Errore: documento scaduto");
    }));

    //Corretto
    test("TC_GD.1.1_21", (() async {
      String capDenunciante = "84016";
      String regioneDenunciante = "Campania"; //AGGIUNTO
      String nomeDenunciante = "Alberto";
      String cognomeDenunciante = "Genovese";
      String indirizzoDenunciante = "Via Traversa Taurano, 46";
      String provinciaDenunciante = "SA";
      String cellulareDenunciante = "+393802110703";
      String emailDenunciante = "alb.genovese@gmail.com";
      String? tipoDocDenunciante = "Carta Identita";
      String? numeroDocDenunciante = "123456";
      Timestamp scadenzaDocDenunciante =
          Timestamp.fromDate(DateTime.parse("2030-12-12"));
      CategoriaDenuncia categoriaDenuncia = CategoriaDenuncia.Colore;
      String nomeVittima = "Gonzalo";
      String denunciato = "Jimmy Sbacco";
      String descrizione =
          "Il signor Jimmy Sbacco il giorno 20/03/2023 mi ha negato il servizio nel suo ristorante usando come motivazione che essendo di colore non potessi permettermi di pagare il conto.";
      String cognomeVittima = "Ortiz";
      bool consenso = true;
      bool? alreadyFiled = false;
      List<String> mediaUrls = ["img.png","video.mp4","audio.mp3"];

      assert(await funzioneTest(
              cognomeDenunciante: cognomeDenunciante,
              regioneDenunciante: regioneDenunciante,
              indirizzoDenunciante: indirizzoDenunciante,
              provinciaDenunciante: provinciaDenunciante,
              cellulareDenunciante: cellulareDenunciante,
              emailDenunciante: emailDenunciante,
              tipoDocDenunciante: tipoDocDenunciante,
              numeroDocDenunciante: numeroDocDenunciante,
              scadenzaDocDenunciante: scadenzaDocDenunciante,
              categoriaDenuncia: categoriaDenuncia,
              nomeVittima: nomeVittima,
              denunciato: denunciato,
              descrizione: descrizione,
              cognomeVittima: cognomeVittima,
              consenso: consenso,
              alreadyFiled: alreadyFiled,
              nomeDenunciante: nomeDenunciante,
              capDenunciante: capDenunciante,
              mediaUrls: mediaUrls) ==
          "Corretto");
    }));
  });
}

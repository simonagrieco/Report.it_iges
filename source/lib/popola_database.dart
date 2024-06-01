import 'package:cloud_firestore/cloud_firestore.dart';

class DatabasePopulator {
  final FirebaseFirestore firestore;

  DatabasePopulator(this.firestore);

  void populateDatabase() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<Map<String, String>> denunce = [
      // Veneto (6 denunce)
      {'RegioneDenunciante': 'Veneto', 'CategoriaDenuncia': 'Etnia'},
      {'RegioneDenunciante': 'Veneto', 'CategoriaDenuncia': 'Colore'},
      {'RegioneDenunciante': 'Veneto', 'CategoriaDenuncia': 'Disabilita'},
      {'RegioneDenunciante': 'Veneto', 'CategoriaDenuncia': 'Eta'},
      {
        'RegioneDenunciante': 'Veneto',
        'CategoriaDenuncia': 'OrientamentoSessuale'
      },
      {'RegioneDenunciante': 'Veneto', 'CategoriaDenuncia': 'Religione'},

      // Lazio (6 denunce)
      {'RegioneDenunciante': 'Lazio', 'CategoriaDenuncia': 'Stirpe'},
      {'RegioneDenunciante': 'Lazio', 'CategoriaDenuncia': 'Gender'},
      {'RegioneDenunciante': 'Lazio', 'CategoriaDenuncia': 'IdentitaDiGenere'},
      {
        'RegioneDenunciante': 'Lazio',
        'CategoriaDenuncia': 'EspressioneDiGenere'
      },
      {'RegioneDenunciante': 'Lazio', 'CategoriaDenuncia': 'Fede'},
      {'RegioneDenunciante': 'Lazio', 'CategoriaDenuncia': 'StoriaPersonale'},

      // Piemonte (6 denunce)
      {'RegioneDenunciante': 'Piemonte', 'CategoriaDenuncia': 'Reddito'},
      {'RegioneDenunciante': 'Piemonte', 'CategoriaDenuncia': 'Aggressione'},
      {'RegioneDenunciante': 'Piemonte', 'CategoriaDenuncia': 'Etnia'},
      {'RegioneDenunciante': 'Piemonte', 'CategoriaDenuncia': 'Colore'},
      {'RegioneDenunciante': 'Piemonte', 'CategoriaDenuncia': 'Disabilita'},
      {'RegioneDenunciante': 'Piemonte', 'CategoriaDenuncia': 'Eta'},

      // Trentino (6 denunce)
      {
        'RegioneDenunciante': 'Trentino',
        'CategoriaDenuncia': 'OrientamentoSessuale'
      },
      {'RegioneDenunciante': 'Trentino', 'CategoriaDenuncia': 'Religione'},
      {'RegioneDenunciante': 'Trentino', 'CategoriaDenuncia': 'Stirpe'},
      {'RegioneDenunciante': 'Trentino', 'CategoriaDenuncia': 'Gender'},
      {
        'RegioneDenunciante': 'Trentino',
        'CategoriaDenuncia': 'IdentitaDiGenere'
      },
      {
        'RegioneDenunciante': 'Trentino',
        'CategoriaDenuncia': 'EspressioneDiGenere'
      },

      // Basilicata (4 denunce)
      {'RegioneDenunciante': 'Basilicata', 'CategoriaDenuncia': 'Fede'},
      {
        'RegioneDenunciante': 'Basilicata',
        'CategoriaDenuncia': 'StoriaPersonale'
      },
      {'RegioneDenunciante': 'Basilicata', 'CategoriaDenuncia': 'Reddito'},
      {'RegioneDenunciante': 'Basilicata', 'CategoriaDenuncia': 'Aggressione'},

      // Calabria (4 denunce)
      {'RegioneDenunciante': 'Calabria', 'CategoriaDenuncia': 'Etnia'},
      {'RegioneDenunciante': 'Calabria', 'CategoriaDenuncia': 'Colore'},
      {'RegioneDenunciante': 'Calabria', 'CategoriaDenuncia': 'Disabilita'},
      {'RegioneDenunciante': 'Calabria', 'CategoriaDenuncia': 'Eta'},

      // Emilia-Romagna (4 denunce)
      {
        'RegioneDenunciante': 'Emilia-Romagna',
        'CategoriaDenuncia': 'OrientamentoSessuale'
      },
      {
        'RegioneDenunciante': 'Emilia-Romagna',
        'CategoriaDenuncia': 'Religione'
      },
      {'RegioneDenunciante': 'Emilia-Romagna', 'CategoriaDenuncia': 'Stirpe'},
      {'RegioneDenunciante': 'Emilia-Romagna', 'CategoriaDenuncia': 'Gender'},

      // Marche (4 denunce)
      {'RegioneDenunciante': 'Marche', 'CategoriaDenuncia': 'IdentitaDiGenere'},
      {
        'RegioneDenunciante': 'Marche',
        'CategoriaDenuncia': 'EspressioneDiGenere'
      },
      {'RegioneDenunciante': 'Marche', 'CategoriaDenuncia': 'Fede'},
      {'RegioneDenunciante': 'Marche', 'CategoriaDenuncia': 'StoriaPersonale'},

      // Puglia (4 denunce)
      {'RegioneDenunciante': 'Puglia', 'CategoriaDenuncia': 'Reddito'},
      {'RegioneDenunciante': 'Puglia', 'CategoriaDenuncia': 'Aggressione'},
      {'RegioneDenunciante': 'Puglia', 'CategoriaDenuncia': 'Etnia'},
      {'RegioneDenunciante': 'Puglia', 'CategoriaDenuncia': 'Colore'},

      // Toscana (7 denunce)
      {'RegioneDenunciante': 'Toscana', 'CategoriaDenuncia': 'Disabilita'},
      {'RegioneDenunciante': 'Toscana', 'CategoriaDenuncia': 'Eta'},
      {
        'RegioneDenunciante': 'Toscana',
        'CategoriaDenuncia': 'OrientamentoSessuale'
      },
      {'RegioneDenunciante': 'Toscana', 'CategoriaDenuncia': 'Religione'},
      {'RegioneDenunciante': 'Toscana', 'CategoriaDenuncia': 'Stirpe'},
      {'RegioneDenunciante': 'Toscana', 'CategoriaDenuncia': 'Gender'},
      {
        'RegioneDenunciante': 'Toscana',
        'CategoriaDenuncia': 'IdentitaDiGenere'
      },

      // Valle d'Aosta (7 denunce)
      {
        'RegioneDenunciante': 'Valle d\'Aosta',
        'CategoriaDenuncia': 'EspressioneDiGenere'
      },
      {'RegioneDenunciante': 'Valle d\'Aosta', 'CategoriaDenuncia': 'Fede'},
      {
        'RegioneDenunciante': 'Valle d\'Aosta',
        'CategoriaDenuncia': 'StoriaPersonale'
      },
      {'RegioneDenunciante': 'Valle d\'Aosta', 'CategoriaDenuncia': 'Reddito'},
      {
        'RegioneDenunciante': 'Valle d\'Aosta',
        'CategoriaDenuncia': 'Aggressione'
      },
      {'RegioneDenunciante': 'Valle d\'Aosta', 'CategoriaDenuncia': 'Etnia'},
      {'RegioneDenunciante': 'Valle d\'Aosta', 'CategoriaDenuncia': 'Colore'},

      // Sardegna (2 denunce)
      {'RegioneDenunciante': 'Sardegna', 'CategoriaDenuncia': 'Disabilita'},
      {'RegioneDenunciante': 'Sardegna', 'CategoriaDenuncia': 'Eta'},

      // Sicilia (2 denunce)
      {
        'RegioneDenunciante': 'Sicilia',
        'CategoriaDenuncia': 'OrientamentoSessuale'
      },
      {'RegioneDenunciante': 'Sicilia', 'CategoriaDenuncia': 'Religione'},
    ];
    for (var denuncia in denunce) {
      await addDenuncia(firestore, denuncia);
    }
  }

  Future<void> addDenuncia(FirebaseFirestore firestore,
      Map<String, String> denuncia) async {
    try {
      final querySnapshot = await firestore.collection('Denuncia')
          .where('RegioneDenunciante', isEqualTo: denuncia['RegioneDenunciante'])
          .where('CategoriaDenuncia', isEqualTo: denuncia['CategoriaDenuncia'])
          .get();

      if (querySnapshot.docs.isEmpty) {
      await firestore.collection('Denuncia').add({
        'AlreadyFiled': true,
        'CapDenunciante': '80030',
        'CellulareDenunciante': '+393291612345',
        'CognomeDenunciante': 'Schiavone',
        'CognomeUff': null,
        'CognomeVittima': 'Schiavone',
        'Consenso': true,
        'CoordCaserma': null,
        'DataDenuncia': Timestamp.now(),
        'Denunciato': 'nome',
        'Descrizione': 'Descrizione',
        'EmailDenunciante': 'mariaconcetta@gmail.com',
        'GradoUff': null,
        'RegioneDenunciante': denuncia['RegioneDenunciante'],
        'CategoriaDenuncia': denuncia['CategoriaDenuncia'],
        'IDUff': null,
        'IDUtente': '12ndidUVp8QH50uOwglHCkazKmB3',
        'IndirizzoCaserma': null,
        'IndirizzoDenunciante': 'Via Lone, 12',
        'NomeCaserma': null,
        'NomeDenunciante': 'Maria Concetta',
        'NomeUff': null,
        'NomeVittima': 'Maria Concetta',
        'NumeroDocDenunciante': 'AY1234DD',
        'ProvinciaDenunciante': 'AV',
        'ScadenzaDocDenunciante': null,
        'Stato': 'NonInCarico',
        'TipoDocDenunciante': null,
        'TipoUff': null,
      });
      print("Denuncia aggiunta: $denuncia");
      } else {
        print("Denuncia già esistente: $denuncia");
      }
    } catch (e) {
      print("Errore durante l'aggiunta della denuncia: $e");
    }
  }
}
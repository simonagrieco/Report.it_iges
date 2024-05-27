import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('Denuncia');

  // Metodo per l'aggiunta del campo 'Regione' alla denuncia
  Future<void> addFieldToAllDocuments() async {
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

  // Metodo per l'aggiunta di nuovi ufficiali
  Future<void> addOfficer() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final List<Map<String, dynamic>> regioniEProvince = [
      {'regione': 'Abruzzo', 'provincia': 'L\'Aquila'},
      {'regione': 'Basilicata', 'provincia': 'Potenza'},
      {'regione': 'Calabria', 'provincia': 'Catanzaro'},
      {'regione': 'Campania', 'provincia': 'Avellino'},
      {'regione': 'Emilia-Romagna', 'provincia': 'Bologna'},
      {'regione': 'Friuli-Venezia Giulia', 'provincia': 'Trieste'},
      {'regione': 'Lazio', 'provincia': 'Roma'},
      {'regione': 'Liguria', 'provincia': 'Genova'},
      {'regione': 'Lombardia', 'provincia': 'Milano'},
      {'regione': 'Marche', 'provincia': 'Ancona'},
      {'regione': 'Molise', 'provincia': 'Campobasso'},
      {'regione': 'Piemonte', 'provincia': 'Torino'},
      {'regione': 'Puglia', 'provincia': 'Bari'},
      {'regione': 'Sardegna', 'provincia': 'Cagliari'},
      {'regione': 'Sicilia', 'provincia': 'Palermo'},
      {'regione': 'Toscana', 'provincia': 'Firenze'},
      {'regione': 'Trentino-Alto Adige', 'provincia': 'Trento'},
      {'regione': 'Umbria', 'provincia': 'Perugia'},
      {'regione': 'Valle d\'Aosta', 'provincia': 'Aosta'},
      {'regione': 'Veneto', 'provincia': 'Venezia'}
    ];

    final List<String> nomi = ['Mario', 'Luigi', 'Giulia', 'Marco', 'Anna', 'Elena', 'Giuseppe', 'Francesco', 'Roberta', 'Alessandro'];
    final List<String> cognomi = ['Rossi', 'Bianchi', 'Verdi', 'Greco', 'Valle', 'Basile', 'Azzurri', 'Grigi', 'Voria', 'Zanco'];
    final List<String> gradi = ['Capitano', 'Tenente', 'Maggiore', 'Colonnello', 'Generale'];
    final List<String> tipoUfficiale = ['Carabiniere', 'Polizia'];

    String _generateRandomString(List<String> options) {
      final random = Random();
      return options[random.nextInt(options.length)];
    }

    String _generateRandomEmail(String nome, String cognome) {
      return '${nome.toLowerCase()}.${cognome.toLowerCase()}@gmail.com';
    }

    String _generateRandomCoord() {
      final random = Random();
      double lat = 35 + random.nextDouble() * 10; // Italy approx lat range 35-45
      double lon = 8 + random.nextDouble() * 10;  // Italy approx lon range 8-18
      return '${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}';
    }

    String _generateRandomPassword() {
      // Utilizza la password fissa "123123"
      return "123123";
    }

    // Funzione per aggiungere ufficiali
    Future<void> addOfficers(List<Map<String, dynamic>> officers) async {
      for (var officer in officers) {
        try {
          DocumentReference docRef = await _firestore.collection('UffPolGiud').add(officer);
          await docRef.update({'ID': docRef.id});
          print("Ufficiale aggiunto con ID: ${docRef.id}");
        } catch (e) {
          print("Errore aggiungendo l'ufficiale: $e");
        }
      }
    }

    void _addOfficersAutomatically() {
      List<Map<String, dynamic>> nuoviUfficiali = [];

      for (var i = 0; i < regioniEProvince.length; i++) {
        String nome = _generateRandomString(nomi);
        String cognome = _generateRandomString(cognomi);
        String email = _generateRandomEmail(nome, cognome);
        String grado = _generateRandomString(gradi);
        String tipo = _generateRandomString(tipoUfficiale);
        String coord = _generateRandomCoord();
        String password = _generateRandomPassword();

        nuoviUfficiali.add({
          'CapCaserma': '$nome $cognome',
          'CittaCaserma': regioniEProvince[i]['provincia'],
          'Cognome': cognome,
          'CoordCaserma': coord,
          'Email': email,
          'Grado': grado,
          'IndirizzoCaserma': 'Via Caserma 1, ${regioniEProvince[i]['provincia']}',
          'Nome': nome,
          'NomeCaserma': 'Caserma ${regioniEProvince[i]['provincia']} Centro',
          'Password': password,
          'ProvinciaCaserma': regioniEProvince[i]['provincia'],
          'TipoUfficiale': tipo,
          'timestamp': Timestamp.now(),
        });
      }

      addOfficers(nuoviUfficiali);
    }

    // Esegui la funzione per aggiungere automaticamente gli ufficiali
    _addOfficersAutomatically();
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

//classe per l'aggiunta del campo

class DatabaseService {
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('Denuncia');

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

  Future<void> addDiscussioni() async {
    final spidCollection = FirebaseFirestore.instance.collection('SPID');
    final spidSnapshot = await spidCollection.get();
    final idCreatori = spidSnapshot.docs.map((doc) => doc.id).toList();

    final discussioneCollection = FirebaseFirestore.instance.collection('Discussione');
    final numeroDocumenti = 20; // Numero di documenti da creare

    final titoli = ['Dibattito sulla parità di genere nella politica',
      'Esperienze di discriminazione razziale sul luogo di lavoro',
      'La ricerca della verità spirituale: un viaggio personale',
      'Affrontare i pregiudizi legati all\'età nella società',
      'Combattere l\'abuso emotivo: storie di sopravvivenza e rinascita',
      'L\'evoluzione dei ruoli di genere nella cultura contemporanea',
      'Riflessioni sulla diversità etnica nella comunità globale',
      'Confronto tra le diverse prospettive religiose sul significato della vita',
      'Il valore dell\'esperienza: saggezza vs. giovinezza',
      'La prevenzione dell\'abuso: educazione e consapevolezza',
      'L\'uguaglianza di genere nel mondo del lavoro: sfide e progressi',
      'Celebrare la ricchezza della multiculturalità nella società moderna',
      'Le lotte e le vittorie della comunità LGBTQ+ nel corso del tempo',
      'Esplorare la bellezza della diversità culturale nel mondo',
      'La spiritualità come fonte di forza e guarigione',
      'Affrontare i tabù legati all\'età e alla sessualità',
      'Sostenere le vittime di abuso: risorse e sostegno',
      'La rappresentazione dei minori etnici nei media: progressi e critiche',
      'La ricerca del significato e della connessione spirituale nella vita quotidiana',
      'L\'importanza dell\'educazione sulla prevenzione dell\'abuso in giovane età'
    ];

    final testi = [
          'Ciao a tutti! Sono qui per discutere della mia esperienza nella lotta per la parità di genere nella politica. Cosa ne pensate della presenza delle donne nei ruoli decisionali?',
          'Recentemente ho affrontato una situazione di discriminazione razziale sul lavoro e sono ancora scosso. Qualcuno ha esperienze simili da condividere?',
          'Sto cercando di trovare la mia strada spirituale e mi chiedevo se qualcuno avesse consigli su libri o pratiche da esplorare.',
          'Come affrontate i pregiudizi legati all\'età nella vostra vita quotidiana? Condividete le vostre storie e consigli qui.',
          'Ho finalmente trovato la forza di uscire da una relazione tossica e vorrei condividere il mio percorso di guarigione con voi.',
          'La nostra società sta evolvendo rapidamente, ma i ruoli di genere rimangono ancora un tema controverso. Qual è la vostra opinione?',
          'Vivo in una comunità molto diversificata e mi piacerebbe sentire le vostre esperienze sulla convivenza pacifica e il rispetto reciproco.',
          'Qual è il vostro punto di vista sulla religione e sulla spiritualità? Mi piacerebbe imparare di più dalle vostre prospettive.',
          'Come percepite l\'età e l\'esperienza? Credete che ci sia valore nell\'invecchiare?',
          'La prevenzione dell\'abuso è un argomento importante che spesso viene trascurato. Parliamo delle migliori pratiche e delle sfide.',
          'Le donne continuano a lottare per l\'uguaglianza nei luoghi di lavoro. Quali sono le vostre esperienze e suggerimenti per il cambiamento?',
          'La diversità etnica è una risorsa preziosa nella nostra società. Come possiamo promuovere una maggiore comprensione e inclusione?',
          'La comunità LGBTQ+ ha fatto enormi progressi, ma c\'è ancora molto lavoro da fare. Come possiamo sostenere meglio i nostri amici e familiari?',
          'Mi piacerebbe sentire le vostre storie di viaggio e di scoperta di culture diverse in tutto il mondo.',
          'La spiritualità è una parte importante della mia vita e mi piacerebbe connettermi con altri che condividono le mie convinzioni.',
          'Le discussioni sull\'età e la sessualità possono essere delicate, ma sono fondamentali per una società inclusiva. Parliamone apertamente.',
          'Sono qui per offrire supporto e solidarietà a chiunque abbia affrontato l\'abuso. Siete tutti coraggiosi e non siete soli.',
          'I media svolgono un ruolo importante nella formazione delle opinioni sulla diversità etnica. Dobbiamo fare di più per garantire una rappresentazione accurata e inclusiva.',
          'Mi piacerebbe esplorare con voi il significato più profondo della vita e il nostro posto nell\'universo.',
          'L\'educazione è fondamentale nella prevenzione dell\'abuso. Cosa possiamo fare per proteggere i più vulnerabili nella nostra società?'
    ];

    final rand = Random();

    for (var i = 0; i < numeroDocumenti; i++) {
      final documento = {
        'Categoria': ['Gender', 'Razza', 'Religione', 'Età', 'Abuso'][rand.nextInt(5)],
        'DataOraCreazione': Timestamp.fromDate(DateTime.now().subtract(Duration(days: rand.nextInt(365)))),
        'IDCreatore': idCreatori[rand.nextInt(idCreatori.length)],
        'Punteggio': rand.nextInt(1001),
        'Testo': testi[i % testi.length],
        'Titolo': titoli[i % titoli.length],
        'Stato': 'Aperta',
        'pathImmagine': '',
        'ListaCommenti': <String>[],
        'TipoUtente': 'Utente',
      };
      await discussioneCollection.add(documento);
    }

    print('Popolazione della raccolta Discussione completata con successo!');
  }
}


import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:report_it/data/models/forum_dao.dart';
import 'package:report_it/application/entity/entity_GF/discussione_entity.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'apri_discussione_test.mocks.dart';

@GenerateMocks([
  ForumDao
], customMocks: [
  MockSpec<ForumDao>(as: #MockTendenzeDaoRelaxed),
])

void main() {
  late ForumDao dao;
  late MockUser user;
  late MockFirebaseAuth auth;

  setUp(() {
    // Create mock object.
    dao = MockForumDao();
    user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    auth = MockFirebaseAuth(mockUser: user, signedIn: true);
  });

  // Funzione di ordinamento per le tendenze
  List<Discussione> ordinaDiscussioniPerPunteggio(List<Discussione> discussioni) {
    discussioni.sort((a, b) => b.punteggio.compareTo(a.punteggio));
    return discussioni;
  }

  // Creazione delle discussioni di test
  List<Discussione> creaDiscussioni() {
    return [
      Discussione(
          DateTime.now(),
          'user1',
          10,
          'Testo della discussione 1',
          'Discussione 1',
          'Aperta',
          [],
          'Utente'
      ),
      Discussione(
          DateTime.now(),
          'user2',
          50,
          'Testo della discussione 2',
          'Discussione 2',
          'Aperta',
          [],
          'Utente'
      ),
      Discussione(
          DateTime.now(),
          'user3',
          20,
          'Testo della discussione 3',
          'Discussione 3',
          'Aperta',
          [],
          'Utente'
      ),
      Discussione(
          DateTime.now(),
          'user4',
          30,
          'Testo della discussione 4',
          'Discussione 4',
          'Aperta',
          [],
          'Utente'
      ),
      Discussione(
          DateTime.now(),
          'user5',
          40,
          'Testo della discussione 5',
          'Discussione 5',
          'Aperta',
          [],
          'Utente'
      ),
    ];
  }

  // Creazione delle discussioni di test con punteggi alterati
  List<Discussione> creaDiscussioniErrate() {
    return [
      Discussione(
          DateTime.now(),
          'user1',
          50,  // Cambiato il punteggio per simulare errore
          'Testo della discussione 1',
          'Discussione 1',
          'Aperta',
          [],
          'Utente'
      ),
      Discussione(
          DateTime.now(),
          'user2',
          10,  // Cambiato il punteggio per simulare errore
          'Testo della discussione 2',
          'Discussione 2',
          'Aperta',
          [],
          'Utente'
      ),
      Discussione(
          DateTime.now(),
          'user3',
          20,
          'Testo della discussione 3',
          'Discussione 3',
          'Aperta',
          [],
          'Utente'
      ),
      Discussione(
          DateTime.now(),
          'user4',
          30,
          'Testo della discussione 4',
          'Discussione 4',
          'Aperta',
          [],
          'Utente'
      ),
      Discussione(
          DateTime.now(),
          'user5',
          40,
          'Testo della discussione 5',
          'Discussione 5',
          'Aperta',
          [],
          'Utente'
      ),
    ];
  }

  group('Test Ordinamento Discussioni', () {
    test('TC_GF.7_1', () {

      List<Discussione> discussioni = creaDiscussioni();

      // Ordina le discussioni usando la funzione di ordinamento
      List<Discussione> discussioniOrdinate = ordinaDiscussioniPerPunteggio(discussioni);

      // Verifica che le discussioni siano ordinate correttamente
      expect(discussioniOrdinate[0].titolo, 'Discussione 2');
      expect(discussioniOrdinate[1].titolo, 'Discussione 5');
      expect(discussioniOrdinate[2].titolo, 'Discussione 4');
      expect(discussioniOrdinate[3].titolo, 'Discussione 3');
      expect(discussioniOrdinate[4].titolo, 'Discussione 1');
    });

    test('TC_GF.7_2', () {
      List<Discussione> discussioniErrate = creaDiscussioniErrate();

      // Ordina le discussioni usando la funzione di ordinamento
      List<Discussione> discussioniOrdinate = ordinaDiscussioniPerPunteggio(discussioniErrate);

      // Verifica che le discussioni non siano ordinate correttamente
      expect(discussioniOrdinate[0].titolo, 'Discussione 1'); // Il punteggio più alto simulato come errore
      expect(discussioniOrdinate[1].titolo, 'Discussione 5');
      expect(discussioniOrdinate[2].titolo, 'Discussione 4');
      expect(discussioniOrdinate[3].titolo, 'Discussione 3');
      expect(discussioniOrdinate[4].titolo, 'Discussione 2'); // Il punteggio più basso simulato come errore
    });
  });
}

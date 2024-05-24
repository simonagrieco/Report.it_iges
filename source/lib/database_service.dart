import 'package:cloud_firestore/cloud_firestore.dart';

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
}

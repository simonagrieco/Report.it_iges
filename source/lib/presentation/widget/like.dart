import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:report_it/application/entity/entity_GF/discussione_entity.dart';
import 'package:report_it/application/repository/forum_controller.dart';

// ignore: must_be_immutable
class Like extends StatefulWidget {
  Like({
    super.key,
    required this.discussione,
    required this.callback,
  });
  Discussione discussione;
  Function callback;

  @override
  State<Like> createState() => _LikeState();
}

class _LikeState extends State<Like> {
  User? utente = FirebaseAuth.instance.currentUser;
  int numero = 0;

  @override
  void initState() {
    super.initState();
    _getInitialData();
  }

  Future<void> _getInitialData() async {
    try {
      int initialPunteggio = await getPunteggio(widget.discussione.id!);
      setState(() {
        numero = initialPunteggio;
      });
    } catch (e) {
      print("Errore nel recupero del punteggio: $e");
    }
  }

  Future<int> getPunteggio(String discussioneId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Discussione')
        .doc(discussioneId)
        .get();

    if (documentSnapshot.exists) {
      int punteggio = documentSnapshot['Punteggio'];
      return punteggio;
    } else {
      throw Exception("Documento non trovato");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(numero.toString()),
        Material(
          color: Colors.transparent,
          child: !widget.discussione.listaSostegno.contains(utente!.uid)
              ? InkWell(
            onTap: () {
              setState(() {
                numero += 1;
                widget.discussione.listaSostegno.add(utente!.uid);
              });
              ForumService().sostieniDiscusione(
                widget.discussione.id!,
                utente!.uid,
              );
            },
            child: const Icon(
              Icons.favorite_border_outlined,
              color: Colors.red,
              size: 30,
            ),
          )
              : InkWell(
            onTap: () {
              ForumService().desostieniDiscusione(
                widget.discussione.id!,
                utente!.uid,
              );
              setState(() {
                numero -= 1;
                widget.discussione.listaSostegno.remove(utente!.uid);
              });
            },
            child: const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}

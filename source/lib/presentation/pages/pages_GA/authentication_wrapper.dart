import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_it/data/models/AutenticazioneDAO.dart';
import '../../../application/entity/entity_GA/amministratore_entity.dart';
import '../home_page.dart';
import '../pages_GAM/dashboard.dart';
import 'login_home_page.dart';

class AuthenticationWrapper extends StatefulWidget {
  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkIfAdmin();
  }

  Future<void> _checkIfAdmin() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final email = currentUser.email;
      if (email != null) {
        final firestore = FirebaseFirestore.instance;

        final querySnapshot = await firestore
            .collection("Amministratore")
            .where('Email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            _isAdmin = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    _checkIfAdmin();

    if (firebaseUser != null) {
      // Controlliamo se l'email dell'utente corrente è nella lista degli amministratori
      if (_isAdmin) {
        return Dashboard();
      } else {
        setState(() {
          _isAdmin = false;
        });
        return HomePage();
      }
    } else {
      setState(() {
        _isAdmin = false;
      });
      return LoginPage();
    }
  }
}

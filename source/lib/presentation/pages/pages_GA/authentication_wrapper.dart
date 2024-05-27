import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    if (currentUser != null && currentUser.email != null) {
      final email = currentUser.email;
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection("Amministratore")
          .where('Email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("User is Admin");
        if (mounted) {
          setState(() {
            _isAdmin = true;
          });
        }
      } else {
        print("User is not Admin");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      // Controlliamo se l'email dell'utente corrente è nella lista degli amministratori
      if (_isAdmin) {
        print("Sei un ADMIN");
        setState(() {
          _isAdmin = true;
        });
        return Dashboard();
      } else {
        print("Non sei un ADMIN");
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
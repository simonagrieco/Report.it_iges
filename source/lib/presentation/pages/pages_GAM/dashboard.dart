import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: Image.asset('assets/images/C11_Logo-noscritta.png',
              fit: BoxFit.cover),
          title: Text('', style: TextStyle(color: Colors.black)),
          elevation: 0,
          backgroundColor: Color.fromRGBO(255, 254, 248, 1),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout, color: Colors.black))
          ]),
    );
  }
}

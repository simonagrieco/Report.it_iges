import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:report_it/presentation/pages/pages_GAM/barChartPage.dart';
import 'package:report_it/presentation/pages/pages_GAM/pieChartPage.dart';

import 'italyMap.dart';

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
        title: Text('Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        elevation: 1,
        backgroundColor: Color.fromRGBO(255, 254, 248, 1),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout, color: Colors.black))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Column(
                        children: [
                          SizedBox(height: 30,),
                          Text("Denunce Totali", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          SizedBox(height: 35,),
                          Text("0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.blue),),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text("Mappa d'Italia", style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10,),
                ItalyMap(),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Bar Chart  ", style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
                    Icon(Iconsax.information5, color: Colors.blueAccent,),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: BarChartPage(),
                ),
                SizedBox(
                  height: 400,
                  child: PieChartPage(),
                ),
              ],
            )

        ),
      ),
    );
  }
}



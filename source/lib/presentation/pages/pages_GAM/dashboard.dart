import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:report_it/presentation/pages/pages_GAM/barChartPage.dart';
import 'italyMap.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalDenunces = 0;
  double monthlyAverageDenunces = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotalDenunces();
  }

  Future<void> _calculateTotalDenunces() async {
    final Set<String> italianRegions = {
      'Abruzzo', 'Basilicata', 'Calabria', 'Campania', 'Emilia-Romagna',
      'Friuli-Venezia Giulia', 'Lazio', 'Liguria', 'Lombardia', 'Marche',
      'Molise', 'Piemonte', 'Puglia', 'Sardegna', 'Sicilia', 'Toscana',
      'Trentino-Alto Adige', 'Umbria', "Valle d'Aosta", 'Veneto'
    };

    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Denuncia').get();

      int total = 0;
      for (var doc in querySnapshot.docs) {
        if (doc['RegioneDenunciante'] != null && italianRegions.contains(doc['RegioneDenunciante'])) {
          total += 1;
        }
      }

      // Calcolo della media mensile
      double monthlyAverage = total / 12;

      setState(() {
        totalDenunces = total;
        monthlyAverageDenunces = monthlyAverage;
      });
    } catch (e) {
      print('Error fetching denunces: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Image.asset('assets/images/C11_Logo-noscritta.png',
            fit: BoxFit.cover),
        title: Text('Dashboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatContainer("Denunce totali", totalDenunces),
                    SizedBox(width: 20),
                    _buildStatContainer(
                        "Media mensile", monthlyAverageDenunces.toInt()),
                    // Visualizza la media mensile come intero
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Mappa d'Italia",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                ItalyMap(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("Bar Chart  ",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("Numero di denunce effettuate per ogni regione d'Italia."),
                            );
                          },
                        );
                      },
                      child: Icon(
                        Iconsax.information5,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: BarChartPage(),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildStatContainer(String title, int value) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 35,
          ),
          Text(
            value.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, color: Colors.blue),
          ),
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
    );
  }
}

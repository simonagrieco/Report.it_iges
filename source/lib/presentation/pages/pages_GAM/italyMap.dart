import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:report_it/presentation/pages/pages_GAM/pieChartPage.dart';

class ItalyMap extends StatelessWidget {
  final List<LatLng> capitals = [
    LatLng(45.0703, 7.6869), // Torino
    LatLng(45.7375, 7.3201), // Aosta
    LatLng(45.4642, 9.1900), // Milano
    LatLng(46.0667, 11.1167), // Trento
    LatLng(45.4408, 12.3155), // Venezia
    LatLng(45.6495, 13.7768), // Trieste
    LatLng(44.4056, 8.9463), // Genova
    LatLng(44.4949, 11.3426), // Bologna
    LatLng(43.7696, 11.2558), // Firenze
    LatLng(43.1107, 12.3908), // Perugia
    LatLng(43.6168, 13.5189), // Ancona
    LatLng(41.9028, 12.4964), // Roma
    LatLng(42.3499, 13.3995), // L'Aquila
    LatLng(41.5603, 14.6622), // Campobasso
    LatLng(40.8518, 14.2681), // Napoli
    LatLng(40.6394, 15.8051), // Potenza
    LatLng(41.1171, 16.8719), // Bari
    LatLng(38.9103, 16.5877), // Catanzaro
    LatLng(38.1157, 13.3615), // Palermo
    LatLng(39.2238, 9.1217), // Cagliari
  ];

  final List<String> regionNames = [
    'Piemonte', 'Valle d\'Aosta', 'Lombardia', 'Trentino-Alto Adige', 'Veneto',
    'Friuli-Venezia Giulia', 'Liguria', 'Emilia-Romagna', 'Toscana', 'Umbria',
    'Marche', 'Lazio', 'Abruzzo', 'Molise', 'Campania', 'Basilicata', 'Puglia',
    'Calabria', 'Sicilia', 'Sardegna'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500, // Altezza della mappa
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(41.8719, 12.5674), // Centro dell'Italia
          zoom: 5.55,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: capitals.asMap().entries.map((entry) {
              int index = entry.key;
              LatLng latLng = entry.value;
              return Marker(
                width: 80.0,
                height: 80.0,
                point: latLng,
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PieChartPage(regionName: regionNames[index]),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 25.0,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:report_it/domain/entity/entity_GA/super_utente.dart';
import 'package:report_it/domain/entity/entity_GPSP/prenotazione_entity.dart';
import 'package:report_it/presentation/pages/pages_GPSP/informazioni_prenotazione_page.dart';
import 'package:report_it/presentation/widget/styles.dart';

class PrenotazioneListWidget extends StatefulWidget {
  final List<Prenotazione>? snapshot;
  final SuperUtente utente;
  final Function() update;

  const PrenotazioneListWidget(
      {super.key,
      required this.snapshot,
      required this.utente,
      required this.update});

  @override
  State<PrenotazioneListWidget> createState() => _PrenotazioneListWidgetState(
      snapshot: snapshot, utente: utente, update: update);
}

class _PrenotazioneListWidgetState extends State<PrenotazioneListWidget> {
  _PrenotazioneListWidgetState(
      {required this.snapshot, required this.utente, required this.update});
  List<Prenotazione>? snapshot;
  final SuperUtente utente;
  final Function() update;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (snapshot == null) {
      return const Center(child: Text('Errore'));
    }
    if (snapshot!.isEmpty) {
      return const CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: Center(
              child: Text("Nessuna prenotazione trovata"),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        itemCount: snapshot!.length,
        itemBuilder: (context, index) {
          final item = snapshot![index];
          return Material(
            color: Theme.of(context).backgroundColor,
            child: Column(children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: ThemeText.boxVisualizza,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 75.0,
                        child: ListTile(
                          title: Text(
                            item.id!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                              'Clicca sull\'icona per vedere i dettagli'),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InformazioniPrenotazione(
                                  idPrenotazione: item.id!,
                                  utente: widget.utente),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.info_outline_rounded,
                        ))
                  ],
                ),
              ),
            ]),
          );
        },
      );
    }
  }
}

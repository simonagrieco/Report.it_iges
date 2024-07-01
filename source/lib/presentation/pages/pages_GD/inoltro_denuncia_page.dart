import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:report_it/application/entity/entity_GA/spid_entity.dart';
import 'package:report_it/application/entity/entity_GA/tipo_utente.dart';
import 'package:report_it/application/entity/entity_GD/categoria_denuncia.dart';
import 'package:report_it/application/repository/denuncia_controller.dart';
import '../../../application/entity/entity_GA/super_utente.dart';
import '../../widget/styles.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class InoltroDenuncia extends StatefulWidget {
  final SuperUtente utente;
  final SPID spid;

  InoltroDenuncia({required this.utente, required this.spid});

  @override
  _InoltroDenuncia createState() =>
      _InoltroDenuncia(utente: utente, spid: spid);
}

class _InoltroDenuncia extends State<InoltroDenuncia> {
  _InoltroDenuncia({required this.utente, required this.spid});

  final SuperUtente utente;
  final SPID spid;

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController numberController;
  late TextEditingController regioneController; //AGGIUNTO
  late TextEditingController indirizzoController;
  late TextEditingController capController;
  late TextEditingController provinciaController;
  late TextEditingController emailController;
  late TextEditingController oppressoreController;
  late TextEditingController nomeVittimaController;
  late TextEditingController cognomeVittimaController;
  late TextEditingController descrizioneController;

  //Aggiunto per img, video e doc
  List<File> _selectedFiles = [];
  final ImagePicker _picker = ImagePicker();

  final regexEmail = RegExp(r"^[A-z0-9\.\+_-]+@[A-z0-9\._-]+\.[A-z]{2,6}$");
  final regexIndirizzo = RegExp(r"^[a-zA-Z+\s]+[,]?\s?[0-9]+$");
  final regexCap = RegExp(r"^[0-9]{5}$");
  final regexProvincia = RegExp(r"^[a-zA-Z]{2}$");
  final regexCellulare = RegExp(r"^((00|\+)39[\. ]??)??3\d{2}[\. ]??\d{6,7}$");
  final regexNomeCognome = RegExp(r"^(?=.{1,30}$)[A-Za-zÀ-ÿ]{1,15}( [A-Za-zÀ-ÿ]{1,15})?$/gm");
  final regexDescrizione = RegExp(r"^[\s\S]{0,500}$");

  List<String> regioniItaliane = [
    "Abruzzo",
    "Basilicata",
    "Calabria",
    "Campania",
    "Emilia-Romagna",
    "Friuli Venezia Giulia",
    "Lazio",
    "Liguria",
    "Lombardia",
    "Marche",
    "Molise",
    "Piemonte",
    "Puglia",
    "Sardegna",
    "Sicilia",
    "Toscana",
    "Trentino Alto Adige",
    "Umbria",
    "Valle d'Aosta",
    "Veneto"
  ];

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  String? discriminazione;
  String? vittimaRadio;
  String? consensoRadio;
  String? alreadyFiledRadio;
  bool consensoController = false;
  late bool alreadyFiledController;

  @override
  void initState() {
    nameController = TextEditingController(text: spid.nome);
    surnameController = TextEditingController(text: spid.cognome);
    numberController = TextEditingController(text: spid.numCellulare);
    regioneController = TextEditingController();
    indirizzoController = TextEditingController(text: spid.domicilioFisico);
    capController = TextEditingController();
    provinciaController = TextEditingController(text: spid.provinciaNascita);
    emailController = TextEditingController(text: spid.indirizzoEmail);
    oppressoreController = TextEditingController();
    nomeVittimaController = TextEditingController();
    cognomeVittimaController = TextEditingController();
    descrizioneController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final consensoWidget = Wrap(
      children: [
        Column(
          children: <Widget>[
            const Text(
              "Rilascia il consenso all'Ufficiale di Polizia Giudiziaria di condividere il Suo nome ed altre informazioni personali con altre parti inerenti a questo caso quando così facendo si collabora nell’investigazione e nella risoluzione del Suo reclamo?",
              style: ThemeText.corpoInoltro,
            ),
            RadioListTile(
              title: const Text("Sì"),
              value: "Si",
              groupValue: consensoRadio,
              onChanged: ((value) {
                setState(() {
                  consensoRadio = value.toString();
                  consensoController = true;
                });
              }),
            ),
            RadioListTile(
              title: const Text("No"),
              value: "No",
              groupValue: consensoRadio,
              onChanged: ((value) {
                setState(() {
                  consensoRadio = value.toString();
                });
              }),
            ),
          ],
        ),
        (consensoRadio) == "No"
            ? Flexible(
                flex: 0,
                child: Container(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text("Attenzione!", style: ThemeText.titoloAlert),
                      ),
                      Text(
                        "Bisogna necessariamente accettare il consenso per poter inoltra correttamente tale denuncia.",
                        style: ThemeText.corpoInoltro,
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              )
            : Column(),
        //se il consenso "sì" --> allora il bottone viene mostrato
        (consensoRadio) == "Si"
            ? Container(
                height: 100,
                child: Flexible(
                  flex: 0,
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        child: ElevatedButton(
                          key: Key("InoltraDenuncia"),
                          onPressed: () {
                            addRecord();
                            Navigator.pop(context);

                            Fluttertoast.showToast(
                                msg: "Inoltro avvenuto correttamente!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Colors.grey.shade200,
                                textColor: Colors.black,
                                fontSize: 15.0);
                          },
                          style: ThemeText.bottoneRosso,
                          child: const Text(
                            "Inoltra",
                          ),
                        ),
                      )),
                ),
              )
            : Column(),
      ],
    );

    final vittimaWidget = Wrap(
      children: [
        Column(
          children: <Widget>[
            const Text(
              "Chi ritieni essere stato vittima di discriminazione?",
              style: ThemeText.corpoInoltro,
            ),
            RadioListTile(
              title: const Text("Tu stesso"),
              value: "LeiStesso",
              groupValue: vittimaRadio,
              onChanged: ((value) {
                setState(() {
                  vittimaRadio = value.toString();
                  nomeVittimaController = nameController;
                  cognomeVittimaController = surnameController;
                });
              }),
            ),
            RadioListTile(
              title: const Text("Persona terza"),
              value: "PersonaTerza",
              groupValue: vittimaRadio,
              onChanged: ((value) {
                setState(() {
                  vittimaRadio = value.toString();
                });
              }),
            ),
          ],
        ),
        (vittimaRadio) == "PersonaTerza"
            ? Flexible(
                flex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    const Text(
                      "Scrivi qui il nome della presunta vittima: ",
                      style: ThemeText.corpoInoltro,
                    ),
                    TextFormField(
                      key: ValueKey('Nome vittima'),
                      decoration:
                          const InputDecoration(labelText: 'Nome vittima'),
                      controller: nomeVittimaController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Per favore, inserisci il nome della vittima';
                        } else if (!regexNomeCognome.hasMatch(value)) {
                          return 'Per favore, inserisci un nome valido.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('Cognome vittima'),
                      decoration:
                          const InputDecoration(labelText: 'Cognome vittima'),
                      controller: cognomeVittimaController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Per favore, inserisci il cognome della vittima';
                        } else if (!regexNomeCognome.hasMatch(value)) {
                          return 'Per favore, inserisci un cognome valido.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            : Column(),
      ],
    );

    final alreadyFiledWidget = Wrap(
      children: [
        Column(
          children: <Widget>[
            const Text(
              "Riferire se le segnalazioni riportate sono già state presentate ad un ufficiale di Polizia Giudiziaria e/o al PM sottoforma di denuncia.",
              style: ThemeText.corpoInoltro,
            ),
            RadioListTile(
              title: const Text("Sì"),
              value: "Si",
              groupValue: alreadyFiledRadio,
              onChanged: ((value) {
                setState(() {
                  alreadyFiledRadio = value.toString();
                  alreadyFiledController = true;
                });
              }),
            ),
            RadioListTile(
              title: const Text("No"),
              value: "No",
              groupValue: alreadyFiledRadio,
              onChanged: ((value) {
                setState(() {
                  alreadyFiledRadio = value.toString();
                  alreadyFiledController = false;
                });
              }),
            ),
          ],
        ),
      ],
    );

    return Consumer<SuperUtente?>(
      builder: (context, utente, _) {
        if (utente == null) {
          return const Text("Non sei loggato");
        } else if (utente.tipo != TipoUtente.Utente) {
          return const Text("non hai i permessi per questa funzionalità");
        } else {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: Color.fromRGBO(219, 29, 69, 1),
              ),
              title: const Text(
                "Inoltro denuncia",
                style: ThemeText.titoloSezione,
              ),
              elevation: 3,
              backgroundColor: ThemeText.theme.colorScheme.background,
            ),
            body: Theme(
              data: ThemeData(
                colorScheme: const ColorScheme.light(
                        primary: Color.fromRGBO(219, 29, 69, 1))
                    .copyWith(
                        background: ThemeText.theme.colorScheme.background),
              ),
              child: Stepper(
                controlsBuilder: (context, details) {
                  if (_currentStep == 0) {
                    return Row(
                      children: <Widget>[
                        ElevatedButton(
                          key: Key("Continua1"),
                          onPressed: details.onStepContinue,
                          style: ThemeText.bottoneRosso,
                          child: const Text('Continua', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    );
                  }
                  if (_currentStep == 6) {
                    return TextButton(
                        onPressed: details.onStepCancel,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Indietro',
                            style: TextStyle(color: Colors.black),
                          ),
                        ));
                  } else {
                    return Row(
                      children: <Widget>[
                        ElevatedButton(
                          key: Key("Continua"),
                          onPressed: details.onStepContinue,
                          style: ThemeText.bottoneRosso,
                          child: const Text('Continua', style: TextStyle(color: Colors.white),),
                        ),
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text(
                            'Indietro',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  }
                },
                type: stepperType,
                currentStep: _currentStep,
                // onStepTapped: (step) => tapped(step), <- se lo si abilita, l'utente sarà abilitato a viaggiare tra le sezioni
                onStepContinue: continued,
                onStepCancel: cancel,
                steps: <Step>[
                  Step(
                    title: const Text(
                      "Dati anagrafici",
                      style: ThemeText.titoloInoltro,
                    ),
                    content: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            key: ValueKey('Nome'),
                            decoration:
                                const InputDecoration(labelText: 'Nome'),
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Per favore, inserisci il nome.';
                              } else if (!regexNomeCognome.hasMatch(value)) {
                                return 'Per favore, inserisci un nome valido.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: ValueKey('Cognome'),
                            decoration:
                                const InputDecoration(labelText: 'Cognome'),
                            controller: surnameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Per favore, inserisci il cognome.';
                              } else if (!regexNomeCognome.hasMatch(value)) {
                                return 'Per favore, inserisci un cognome valido.';
                              }
                              return null;
                            },
                          ),
                          //AGGIUNTO
                          TextFormField(
                            key: ValueKey('Regione'),
                            decoration:
                                const InputDecoration(labelText: 'Regione'),
                            controller: regioneController,
                            validator: (value) {
                              String? valueLowerCase = value?.toLowerCase();
                              bool isValidRegion = regioniItaliane.any(
                                  (regione) =>
                                      regione.toLowerCase() == valueLowerCase);

                              if (value!.isEmpty) {
                                return 'Per favore, inserisci la regione.';
                              } else if (!isValidRegion) {
                                return 'Per favore, inserisci una regione valida.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: ValueKey('Indirizzo'),
                            decoration:
                                const InputDecoration(labelText: 'Indirizzo'),
                            controller: indirizzoController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Per favore, inserisci un indirizzo.';
                              } else if (!regexIndirizzo.hasMatch(value)) {
                                return 'Per favore, inserisci un indirizzo valido.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: ValueKey('CAP'),
                            decoration: const InputDecoration(labelText: 'CAP'),
                            controller: capController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Per favore, inserisci il CAP.';
                              } else if (!regexCap.hasMatch(value)) {
                                return 'Per favore, inserisci un CAP valido.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: ValueKey('Provincia'),
                            decoration: const InputDecoration(
                                labelText: 'Sigla provincia'),
                            controller: provinciaController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Per favore, inserisci la provincia.';
                              } else if (!regexProvincia.hasMatch(value)) {
                                return 'Per favore, inserisci una provincia valida.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: ValueKey('Numero telefonico'),
                            keyboardType: TextInputType.phone,
                            controller: numberController,
                            decoration: const InputDecoration(
                                labelText: 'Numero telefonico'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Per favore, inserisci il numero telefonico.';
                              } else if (!regexCellulare.hasMatch(value)) {
                                return 'Per favore, inserisci un numero telefonico valido.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: ValueKey('E-mail'),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: const InputDecoration(
                                labelText: 'Indirizzo e-mail'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Per favore, inserisci l\'indirizzo e-mail';
                              } else if (!regexEmail.hasMatch(value)) {
                                return 'Per favore, inserisci una e-mail valida.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text("Discriminazione",
                        style: ThemeText.titoloInoltro),
                    content: Form(
                      key: _formKey2,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            "Indicare la natura della presunta discriminazione:",
                            style: ThemeText.corpoInoltro,
                          ),
                          RadioListTile(
                            title: const Text("Etnia"),
                            value: "Etnia",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Colore della pelle"),
                            value: "Colore",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Disabilità"),
                            value: "Disabilita",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Età"),
                            value: "Eta",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Orientamento Sessuale"),
                            value: "OrientamentoSessuale",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Religione"),
                            value: "Religione",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Stirpe"),
                            value: "Stirpe",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Genere Sessuale"),
                            value: "Gender",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Identità di genere"),
                            value: "IdentitaDiGenere",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Espressione di genere"),
                            value: "EspressioneDiGenere",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Fede"),
                            value: "Fede",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Storia Personale"),
                            value: "StoriaPersonale",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Reddito"),
                            value: "Reddito",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Abusi"),
                            value: "Abusi",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                          RadioListTile(
                            title: const Text("Aggressione"),
                            value: "Aggressione",
                            groupValue: discriminazione,
                            onChanged: ((value) {
                              setState(() {
                                discriminazione = value.toString();
                              });
                            }),
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title:
                        const Text("Vittima", style: ThemeText.titoloInoltro),
                    content: vittimaWidget,
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text("Oppressore",
                        style: ThemeText.titoloInoltro),
                    content: Form(
                      key: _formKey3,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            "Scrivi qui il nome della persona e/o dell’organizzazione che Lei ritiene abbia compiuto l’azione discriminante",
                            style: ThemeText.corpoInoltro,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            key: ValueKey('Nome oppressore'),
                            decoration: const InputDecoration(
                                labelText: 'Nome oppressore'),
                            controller: oppressoreController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Per favore, inserisci il nome dell\'oppressore';
                              } else if (!regexNomeCognome.hasMatch(value)) {
                                return 'Per favore, inserisci un nome valido.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 3
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text(
                      "Vicenda",
                      style: ThemeText.titoloInoltro,
                    ),
                    content: Form(
                      key: _formKey4,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            "Includere tutti i dettagli specifici come nomi, date, orari, testimoni e qualsiasi altra informazione che potrebbe aiutarci nella nostra indagine in base alle sue affermazioni. Includere inoltre qualsiasi altra documentazione pertinente alla presente denuncia.",
                            style: ThemeText.corpoInoltro,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            key: ValueKey('Vicenda'),
                            decoration: const InputDecoration(
                                labelText: 'Scrivi qui la vicenda'),
                            controller: descrizioneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Per favore, inserisci una descrizione';
                              }  else if (!regexDescrizione.hasMatch(value)) {
                                return 'Per favore, inserisci una descrizione valida.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          //Aggiunto per img
                          Text(
                            "Se in possesso, carica contenuti multimediali relativi alla vicenda (foto, audio, video e/o documenti)",
                            style: ThemeText.corpoInoltro,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: _pickFiles, //richiama metodo
                            child: const Text("Seleziona file"),
                          ),
                          const SizedBox(height: 10),
                          _selectedFiles.isNotEmpty
                              ? Wrap(
                                  children: _selectedFiles.map((file) {
                                    final fileName = file.path.split('/').last;
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: Colors.grey[200],
                                        child: Text(
                                          fileName,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const Text("Nessun file selezionato."),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 4
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text(
                      "Info sulla pratica",
                      style: ThemeText.titoloInoltro,
                    ),
                    content: alreadyFiledWidget,
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 5
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: const Text(
                      "Consenso",
                      style: ThemeText.titoloInoltro,
                    ),
                    content: consensoWidget,
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 6
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                ],
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
          );
        }
      },
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    if ((_currentStep == 1 && discriminazione == null) ||
        (_currentStep == 2 && vittimaRadio == null) ||
        (_currentStep == 5 && alreadyFiledRadio == null)) {
      return;
    }

    if (_currentStep == 3 &&
        (_formKey3.currentState == null ||
            !_formKey3.currentState!.validate())) {
      return;
    }

    if (_currentStep == 4 &&
        (_formKey4.currentState == null ||
            !_formKey4.currentState!.validate())) {
      return;
    }

    _currentStep <= 7 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

//   State<StatefulWidget> createState() {
//     throw UnimplementedError();
//   }

  addRecord() async {
    DenunciaController control = DenunciaController();
    SPID? spidUtente = spid;
    Timestamp convertedDate =
        Timestamp.fromDate(spidUtente.getDataScadenzaDocumento);

    var result = control.addDenunciaControl(
      nomeDenunciante: nameController.text,
      cognomeDenunciante: surnameController.text,
      regioneDenunciante: regioneController.text,
      //AGGIUNTO
      indirizzoDenunciante: indirizzoController.text,
      capDenunciante: capController.text,
      provinciaDenunciante: provinciaController.text,
      cellulareDenunciante: numberController.text,
      emailDenunciante: emailController.text,
      tipoDocDenunciante: spidUtente.tipoDocumento,
      numeroDocDenunciante: spidUtente.numeroDocumento,
      scadenzaDocDenunciante: convertedDate,
      categoriaDenuncia: CategoriaDenuncia.values.byName(discriminazione!),
      nomeVittima: nomeVittimaController.text,
      denunciato: oppressoreController.text,
      descrizione: descrizioneController.text,
      cognomeVittima: cognomeVittimaController.text,
      consenso: consensoController,
      alreadyFiled: alreadyFiledController,
      imageFiles: _selectedFiles, //aggiunto per img
    );

    print(await result);
  }

  //metodo per selezionare foto
  Future<void> _pickFiles() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt ?? 0;
      if (sdkInt <= 32) {
        // Per Android versioni <= 32 (fino ad Android 12)
        if (await Permission.storage.request().isGranted) {
          // Permesso di accesso alla memoria esterna concesso
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.custom,
            allowedExtensions: [
              'jpg',
              'jpeg',
              'png',
              'mp3',
              'mp4',
              'pdf',
              'doc',
              'docx',
              'webp'
            ],
          );
          if (result != null) {
            setState(() {
              _selectedFiles
                  .addAll(result.paths.map((path) => File(path!)).toList());
            });
          }
        } else {
          print("Permessi di accesso alla memoria esterna negati");
        }
      } else {
        // Per Android versioni >= 33 (Android 13 e successivi)
        if (await Permission.photos.request().isGranted) {
          // Permesso di accesso alle foto concesso
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.custom,
            allowedExtensions: [
              'jpg',
              'jpeg',
              'png',
              'mp3',
              'mp4',
              'pdf',
              'doc',
              'docx'
            ],
          );
          if (result != null) {
            setState(() {
              _selectedFiles
                  .addAll(result.paths.map((path) => File(path!)).toList());
            });
          }
        } else {
          print("Permessi di accesso alle foto negati");
        }
      }
    } else {
      // Gestione permessi per iOS o altre piattaforme
      if (await Permission.photos.request().isGranted) {
        // Permesso di accesso alle foto concesso
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: [
            'jpg',
            'jpeg',
            'png',
            'mp3',
            'mp4',
            'pdf',
            'doc',
            'docx'
          ],
        );
        if (result != null) {
          setState(() {
            _selectedFiles
                .addAll(result.paths.map((path) => File(path!)).toList());
          });
        }
      } else {
        print("Permessi di accesso alle foto negati");
      }
    }
  }
}

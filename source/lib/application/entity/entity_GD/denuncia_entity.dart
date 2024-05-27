import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:report_it/application/entity/entity_GA/tipo_ufficiale.dart';
import 'package:report_it/application/entity/entity_GD/categoria_denuncia.dart';
import 'package:report_it/application/entity/entity_GD/stato_denuncia.dart';

class Denuncia {
  String? id, gradoUff;
  String nomeDenunciante,
      cognomeDenunciante,
      regioneDenunciante, //AGGIUNTO
      indirizzoDenunciante,
      capDenunciante,
      provinciaDenunciante,
      cellulareDenunciante,
      emailDenunciante,
      tipoDocDenunciante,
      numeroDocDenunciante,
      nomeVittima,
      cognomeVittima,
      denunciato,
      descrizione;

  TipoUfficiale? tipoUff;

  Timestamp scadenzaDocDenunciante, dataDenuncia;
  GeoPoint? coordCaserma;

  String? nomeCaserma, nomeUff, cognomeUff, idUff, indirizzoCaserma;

  bool consenso = false, alreadyFiled = false;
  String idUtente;
  CategoriaDenuncia categoriaDenuncia;
  StatoDenuncia statoDenuncia;

  // Nuovo campo per gli URL dei file multimediali
  List<String> mediaUrls;

  Denuncia({
      required this.id,
      required this.idUtente,
      required this.nomeDenunciante,
      required this.cognomeDenunciante,
      required this.regioneDenunciante, //AGGIUNTO
      required this.indirizzoDenunciante,
      required this.capDenunciante,
      required this.provinciaDenunciante,
      required this.cellulareDenunciante,
      required this.emailDenunciante,
      required this.tipoDocDenunciante,
      required this.numeroDocDenunciante,
      required this.scadenzaDocDenunciante,
      required this.dataDenuncia,
      required this.categoriaDenuncia,
      required this.nomeVittima,
      required this.denunciato,
      required this.alreadyFiled,
      required this.consenso,
      required this.descrizione,
      required this.statoDenuncia,
      required this.nomeCaserma,
      required this.coordCaserma,
      required this.nomeUff,
      required this.cognomeUff,
      required this.cognomeVittima,
      required this.idUff,
      required this.tipoUff,
      required this.gradoUff,
      required this.indirizzoCaserma,
      required this.mediaUrls, //aggiunto per immagini
      });

  get getId => id;
  set setId(id) => this.id = id;

  get getIdUff => idUff;
  set setIdUff(idUff) => this.idUff = idUff;

  get getNomeDenunciante => nomeDenunciante;
  set setNomeDenunciante(nomeDenunciante) =>
      this.nomeDenunciante = nomeDenunciante;

  get getCognomeDenunciante => cognomeDenunciante;
  set setCognomeDenunciante(cognomeDenunciante) =>
      cognomeDenunciante = cognomeDenunciante;

  get getRegioneDenunciante => regioneDenunciante; //AGGIUNTO
  set setRegioneDenunciante(regioneDenunciante) =>
      this.regioneDenunciante = regioneDenunciante;

  get getIndirizzoDenunciante => indirizzoDenunciante;
  set setIndirizzoDenunciante(indirizzoDenunciante) =>
      this.indirizzoDenunciante = indirizzoDenunciante;

  get getCapDenunciante => capDenunciante;
  set setCapDenunciante(capDenunciante) => this.capDenunciante = capDenunciante;

  get getProvinciaDenunciante => provinciaDenunciante;
  set setProvinciaDenunciante(provinciaDenunciante) =>
      this.provinciaDenunciante = provinciaDenunciante;

  get getCellulareDenunciante => cellulareDenunciante;
  set setCellulareDenunciante(cellulareDenunciante) =>
      this.cellulareDenunciante = cellulareDenunciante;

  get getEmailDenunciante => emailDenunciante;
  set setEmailDenunciante(emailDenunciante) =>
      this.emailDenunciante = emailDenunciante;

  get getTipoDocDenunciante => tipoDocDenunciante;
  set setTipoDocDenunciante(tipoDocDenunciante) =>
      this.tipoDocDenunciante = tipoDocDenunciante;

  get getNomeVittima => nomeVittima;
  set setNomeVittima(nomeVittima) => this.nomeVittima = nomeVittima;

  get getCognomeVittima => cognomeVittima;
  set setCognomeVittima(cognomeVittima) => this.cognomeVittima = cognomeVittima;

  get getDenunciato => denunciato;
  set setDenunciato(denunciato) => this.denunciato = denunciato;

  get getDescrizione => descrizione;
  set setDescrizione(descrizione) => this.descrizione = descrizione;

  get getNomeCaserma => nomeCaserma;
  set setNomeCaserma(nomeCaserma) => this.nomeCaserma = nomeCaserma;

  get getCoordCaserma => coordCaserma;
  set setCoordCaserma(coordCaserma) => this.coordCaserma = coordCaserma;

  get getNomeUff => nomeUff;
  set setNomeUff(nomeUff) => this.nomeUff = nomeUff;

  get getCognomeUff => cognomeUff;
  set setCognomeUff(cognomeUff) => this.cognomeUff = cognomeUff;

  get getDataDenuncia => dataDenuncia;
  set setDataDenuncia(dataDenuncia) => this.dataDenuncia = dataDenuncia;

  get getAlreadyFiled => alreadyFiled;
  set setAlreadyFiled(alreadyFiled) => this.alreadyFiled = alreadyFiled;

  get getIdUtente => idUtente;

  get getIndirizzoCaserma => indirizzoCaserma;
  set setIndirizzoCaserma(indirizzoCaserma) =>
      this.indirizzoCaserma = indirizzoCaserma;


  @override
  String toString() {
    return 'Denuncia{id: $id, nomeDenunciante: $nomeDenunciante, cognomeDenunciante: $cognomeDenunciante, indirizzoDenunciante: $indirizzoDenunciante, capDenunciante: $capDenunciante, provinciaDenunciante: $provinciaDenunciante, cellulareDenunciante: $cellulareDenunciante, emailDenunciante: $emailDenunciante, tipoDocDenunciante: $tipoDocDenunciante, numeroDocDenunciante: $numeroDocDenunciante, nomeVittima: $nomeVittima, cognomeVittima: $cognomeVittima, denunciato: $denunciato, descrizione: $descrizione, scadenzaDocDenunciante: $scadenzaDocDenunciante, dataDenuncia: $dataDenuncia, coordCaserma: $coordCaserma, nomeCaserma: $nomeCaserma, nomeUff: $nomeUff, cognomeUff: $cognomeUff, consenso: $consenso, alreadyFiled: $alreadyFiled, idUtente: $idUtente, categoriaDenuncia: $categoriaDenuncia, statoDenuncia: $statoDenuncia}';
  }
}

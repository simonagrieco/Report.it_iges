import 'package:report_it/application/entity/entity_GA/super_utente.dart';
import 'package:report_it/application/entity/entity_GA/tipo_utente.dart';

class Amministratore extends SuperUtente {
  String password;
  String email;
  String nome;
  String cognome;
  String capAmm;
  String provinciaAmm;
  String indirizzoAmm;
  String cittaAmm;

  get getId => this.id;
  set setId(id) => this.id = id;

  get getPassword => this.password;
  set setPassword(password) => this.password = password;

  get getEmail => this.email;
  set setEmail(email) => this.email = email;


  Amministratore(
      id,
      this.password,
      this.email,
      this.nome,
      this.cognome,
      this.capAmm,
      this.provinciaAmm,
      this.indirizzoAmm,
      this.cittaAmm,
      ) : super(id, TipoUtente.values.byName("Amministratore"));

  factory Amministratore.fromJson(Map<String, dynamic> json) {
    return Amministratore(
      json["ID"],
      json["Password"],
      json["Email"],
      json["Nome"],
      json["Cognome"],
      json["CAP"],
      json["Provincia"],
      json["Indirizzo"],
      json["Città"],
    );
  }

  factory Amministratore.fromMap(map) {
    return Amministratore(
      map["ID"],
      map["Password"],
      map["Email"],
      map["Nome"],
      map["Cognome"],
      map["CAP"],
      map["Provincia"],
      map["Indirizzo"],
      map["Città"],
    );
  }

  Map<String?, dynamic> toMap() {
    return {
      "ID": id,
      "Password": password,
      "Email": email,
      "Nome": nome,
      "Cognome": cognome,
      "CAP": capAmm,
      "Provincia": provinciaAmm,
      "Indirizzo": indirizzoAmm,
      "Città": cittaAmm,
    };
  }
}

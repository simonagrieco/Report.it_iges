import 'package:report_it/application/entity/adapter.dart';
import 'package:report_it/application/entity/entity_GA/amministratore_entity.dart';

class AdapterAmministratore implements Adapter {
  @override
  fromJson(Map<String, dynamic> json) {
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

  @override
  fromMap(map) {
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

  @override
  toMap(object) {
    object = object as Amministratore;
    return {
      "ID": object.id,
      "Password": object.password,
      "Email": object.email,
      "Nome": object.nome,
      "Cognome": object.cognome,
      "CAP": object.capAmm,
      "Provincia": object.provinciaAmm,
      "Indirizzo": object.indirizzoAmm,
      "Città": object.cittaAmm,
    };
  }
}

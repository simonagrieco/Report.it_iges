import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:report_it/application/entity/entity_GA/amministratore_entity.dart';
import 'package:report_it/data/models/AutenticazioneDAO.dart';

import 'loginStandard_test.mocks.dart';

@GenerateMocks([
  AutenticazioneDAO
], customMocks: [
  MockSpec<AutenticazioneDAO>(as: #MockAutenticazioneDAORelaxed),
])
void main() {
  late AutenticazioneDAO daoA;

  setUp(() {
    daoA = MockAutenticazioneDAO();
  });

  Future<String> funzionetest(String email, String password) async {
    final regexEmail = RegExp(r"^[A-z0-9\.\+_-]+@[A-z0-9\._-]+\.[A-z]{2,6}$");
    if (!regexEmail.hasMatch(email)) {
      return "Il formato della e-mail non è stato rispettato";
    }
    final regexPassword = RegExp(
        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&\/]{8,}$"
    );
    when(daoA.RetrieveAmministratoreByEmail(email))
        .thenAnswer((realInvocation) => Future.value(() {
      if (email == "amm111@gmail.com") {
        return Future.value(null);
      } else if (email == "amm@gmail.com" &&
          (password == "PassErrata12*/" || password == "PassErrata")) {
        return Amministratore(
            "id",
            "password",
            email,
            "nome",
            "cognome",
            "cap",
            "provincia",
            "indirizzo",
            "città");
      } else if (email == "amm@gmail.com" && password == "Amm1234@") {
        return Amministratore(
            "id",
            password,
            email,
            "nome",
            "cognome",
            "cap",
            "provincia",
            "indirizzo",
            "città");
      }
      return null;
    }() as FutureOr<Amministratore?>?));

    try {
      var u = await daoA.RetrieveAmministratoreByEmail(email);

      if (u == null) {
        return "L’e-mail non è associata a nessun account";
      }

      if (!regexPassword.hasMatch(password)) {
        return "Il formato della password non è stato rispettato";
      }

      if (u.password != password) {
        return "La password non è corretta";
      }

      return "Corretto";
    } catch (e) {
      return 'invalid-email';
    }
  }

  group("login_standard", () {
    test("TC_GA.2_1", () async {
      String email = "@asd,lolo/.pippo";
      String password = "";

      expect(await funzionetest(email, password),
          "Il formato della e-mail non è stato rispettato");
    });

    test("TC_GA.2_2", () async {
      String email = "amm111@gmail.com";
      String password = "Amm1234@";

      expect(await funzionetest(email, password),
          "L’e-mail non è associata a nessun account");
    });

    test("TC_GA.2_3", () async {
      String email = "amm@gmail.com";
      String password = "PassErrata";

      expect(await funzionetest(email, password), "Il formato della password non è stato rispettato");
    });

    test("TC_GA.2_4", () async {
      String email = "amm@gmail.com";
      String password = "PassErrata12*/";

      expect(await funzionetest(email, password),
          "La password non è corretta");
    });

    test("TC_GA.2_5", () async {
      String email = "amm@gmail.com";
      String password = "Amm1234@";

      expect(await funzionetest(email, password), "Corretto");
    });
  });
}

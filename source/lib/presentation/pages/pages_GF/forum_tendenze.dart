import 'package:flutter/material.dart';
import 'package:report_it/application/repository/forum_controller.dart';
import '../../widget/crealista.dart';
import '../../widget/styles.dart';

class ForumTendenze extends StatefulWidget {
  @override
  _ForumTendenzeState createState() => _ForumTendenzeState();
}

class _ForumTendenzeState extends State<ForumTendenze> {
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tendenza della settimana', style: ThemeText.titoloSezione),
      ),
      body: crealista(
        list: ForumService.PrendiTendenze(),
        Callback: callback,
      ),
    );
  }
}

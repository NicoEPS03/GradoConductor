import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyecto_grado_conductor/Login/NavigationDrawerWidget.dart';

class Ganancias extends StatelessWidget {
  final database = FirebaseDatabase.instance.reference().child('Conductores');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _nombre = 'Jorge';

    return Scaffold(
      drawer: NavigationDrawerWidget(nombre: _nombre),
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset("assets/icons/menu.svg"),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text('Ganancias'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[Text('Ganancias')],
        ),
      ),
    );
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
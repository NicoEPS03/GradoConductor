import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyecto_grado_conductor/Login/NavigationDrawerWidget.dart';
import 'HeaderInicio.dart';

///Pantalla de inicio
class Inicio extends StatelessWidget{
  final auth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instance.reference().child('Conductores');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _nombre = 'Jorge';
    String _apellido = 'Nitales';
    int _generado = 0;

    return Scaffold(
      drawer: NavigationDrawerWidget(
        nombre: _nombre,
      ),
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
        title: Text('Inicio'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          HeaderInicio(size: size, nombre: _nombre, apellido: _apellido, generado: _generado),
          Container(
            child: Stack(children: <Widget>[
              Text(
                'Historial de Pagos',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width / 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
        ],
      )),
    );
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
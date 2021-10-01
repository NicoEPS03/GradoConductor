import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proyecto_grado_conductor/Cuenta/DatosPersonales.dart';
import 'package:proyecto_grado_conductor/Cuenta/FooterCuenta.dart';
import 'package:proyecto_grado_conductor/Login/NavigationDrawerWidget.dart';
import 'HeaderCuenta.dart';

///Pantalla de configuración de cuenta
class Cuenta extends StatelessWidget {
  final database = FirebaseDatabase.instance.reference().child('Pasajeros');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _nombre = 'Jorge';
    String _apellido = 'Nitales';

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
              title: Text('Cuenta'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  HeaderCuenta(size: size),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _nombre + ' ' + _apellido,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width / 18,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return DatosPersonales();
                                }));
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                  ),
                  FooterCuenta(size: size),
                ],
              ),
            ),
          );
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
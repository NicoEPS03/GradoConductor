import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyecto_grado_conductor/Login/NavigationDrawerWidget.dart';
import 'package:proyecto_grado_conductor/Vehiculo/HeaderVehiculo.dart';


class Vehiculo extends StatelessWidget {
  final database = FirebaseDatabase.instance.reference().child('Conductores');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _nombre = 'Jorge';
    String _vehiculo = '010120';

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
        title: Text('Vehículo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HeaderVehiculo(size: size),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Vehiculo No. ' + _vehiculo,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width / 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
            ),
            //FooterCuenta(size: size),
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

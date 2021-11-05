import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proyecto_grado_conductor/Login/NavigationDrawerWidget.dart';
import 'package:proyecto_grado_conductor/Model/EConductor.dart';
import 'package:proyecto_grado_conductor/Vehiculo/FooterVehiculo.dart';
import 'package:proyecto_grado_conductor/Vehiculo/HeaderVehiculo.dart';
import 'package:proyecto_grado_conductor/constants.dart';


class Vehiculo extends StatelessWidget {
  Vehiculo({
    Key? key,
    required this.documento,
  }) : super(key: key);

  String documento;
  final database = FirebaseDatabase.instance.reference().child('Conductores');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _nombre = '';

    //Obtiene los datos del conductor desde firebase
    Future<EConductor> getConductorData(String userId) async {
      return await database.child(userId)
          .once()
          .then((result) {
        final LinkedHashMap value = result.value;
        return EConductor.fromMap(value);
      });
    }

    //Asigna los datos del conductor a las variable a pasar
    getConductor() async{
      EConductor conductor = await getConductorData(documento);
      var nombreCompleto = conductor.nombre;
      if(nombreCompleto.indexOf(" ") == -1){
        _nombre = conductor.nombre;
      }else{
        _nombre = nombreCompleto.substring(0,nombreCompleto.indexOf(" "));
      }
    }

    return FutureBuilder(
        future: getConductor(),
        builder: (_, AsyncSnapshot snapshot) {
        return Scaffold(
          drawer: NavigationDrawerWidget(nombre: _nombre),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kPrimaryColor,
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
                FooterVehiculo(size: size,documento: documento,),
              ],
            ),
          ),
        );
      }
    );
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */

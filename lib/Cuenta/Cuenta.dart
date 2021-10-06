import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proyecto_grado_conductor/Cuenta/DatosPersonales.dart';
import 'package:proyecto_grado_conductor/Cuenta/FooterCuenta.dart';
import 'package:proyecto_grado_conductor/Login/NavigationDrawerWidget.dart';
import 'package:proyecto_grado_conductor/Model/EConductor.dart';
import 'HeaderCuenta.dart';

///Pantalla de configuración de cuenta
class Cuenta extends StatelessWidget {
  Cuenta({
    Key? key,
    required this.documento,
  }) : super(key: key);

  String documento;

  final database = FirebaseDatabase.instance.reference().child('Conductores');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _nombre = '';
    String _apellido = '';

    //Obtiene los datos del conductor desde firebase
    Future<EConductor> getConductorData(String userId) async {
      return await database.child(userId)
          .once()
          .then((result) {
        final LinkedHashMap value = result.value;
        return EConductor.fromMap(value);
      });
    }

    //Asigna los datos del conductor a las variabla a pasar
    getConductor() async{
      EConductor conductor = await getConductorData(documento);
      var nombreCompleto = conductor.nombre;
      var apellidoCompleto = conductor.apellido;
      if(nombreCompleto.indexOf(" ") == -1){
        _nombre = conductor.nombre;
      }else{
        _nombre = nombreCompleto.substring(0,nombreCompleto.indexOf(" "));
      }

      if(apellidoCompleto.indexOf(" ") == -1){
        _apellido = conductor.apellido;
      }else{
        _apellido = apellidoCompleto.substring(0,apellidoCompleto.indexOf(" "));
      }
    }

    return FutureBuilder(
        future: getConductor(),
        builder: (_, AsyncSnapshot snapshot) {
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
                              fontSize: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 18,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return DatosPersonales(documento: documento,);
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
        );
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
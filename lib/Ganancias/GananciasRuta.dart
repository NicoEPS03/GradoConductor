import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_grado_conductor/Cuenta/HeaderCuenta.dart';
import 'package:proyecto_grado_conductor/Ganancias/FooterGanancias.dart';
import 'package:proyecto_grado_conductor/Model/EConductor.dart';
import 'package:proyecto_grado_conductor/Model/ERutaBusConductor.dart';

import '../constants.dart';

class GananciasRuta extends StatelessWidget{

  GananciasRuta({
    Key? key,
    required this.rutaId,
    required this.documento,
  }) : super(key: key);

  String rutaId;
  String documento;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final databaseRutas = FirebaseDatabase.instance.reference().child('RutaBusConductor');
    final database = FirebaseDatabase.instance.reference().child('Conductores');

    String _nomRuta = '';
    int _numPasajero = 0;
    int _ganancias = 0;
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


    //Obtiene los datos del ruta desde firebase
    Future<ERutaBusConductor> getRutaData(String _rutaId) async {
      return await databaseRutas.child(_rutaId)
          .once()
          .then((result) {
        final LinkedHashMap value = result.value;
        print(value);
        return ERutaBusConductor.fromMap(value);
      });
    }

    //Asigna los datos del ruta a las variabla a pasar
    getRuta() async{
      await getConductor();
      ERutaBusConductor ruta = await getRutaData(rutaId);
      _nomRuta = ruta.nomRuta;
      _numPasajero = ruta.numPasajeros;
      _ganancias = ruta.numPasajeros * ruta.valor;
    }

    return FutureBuilder(
        future: getRuta(),
        builder: (_, AsyncSnapshot snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Ganancias por ruta"),
              backgroundColor: kPrimaryColor,
              elevation: 20,
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
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  FooterGanancias(size: size,nombre: _nomRuta,numPasajeros: _numPasajero,ganancias: _ganancias,),
                ],
              ),
            ),
          );
        }
    );
  }
}
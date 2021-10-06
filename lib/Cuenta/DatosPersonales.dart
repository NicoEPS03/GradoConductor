import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_grado_conductor/Model/EConductor.dart';
import '../constants.dart';

///Pantalla de datos personales
class DatosPersonales extends StatefulWidget {
  DatosPersonales({
    Key? key,
    required this.documento,
  }) : super(key: key);

  String documento;
  @override
  _DatosPersonalesState createState() => _DatosPersonalesState(documento);
}

class _DatosPersonalesState extends State<DatosPersonales> {
  _DatosPersonalesState(this.documento);
  String documento;

  final database = FirebaseDatabase.instance.reference().child('Conductores');

  String dropdownValue = 'T.I.';
  var visibility = false;
  var visibility2 = false;

  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _num_documentoController = TextEditingController();
  final _correoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
      _nombreController.text = conductor.nombre;
      _apellidoController.text = conductor.apellido;
      _telefonoController.text = conductor.telefono;
      dropdownValue = conductor.tipoDocumento;
      _num_documentoController.text = conductor.numDocumento;
      _correoController.text = conductor.correo;
    }

    return FutureBuilder(
        future: getConductor(),
        builder: (_, AsyncSnapshot snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Datos personales"),
              backgroundColor: kPrimaryColor,
              elevation: 20,
            ),
            body: Container(
              height: size.height,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: TextFormField(
                            controller: _nombreController,
                            enabled: false,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              hintText: "Nombre",
                              labelText: "Nombre",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: TextFormField(
                            controller: _apellidoController,
                            enabled: false,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              hintText: "Apellidos",
                              labelText: "Apellidos",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: TextFormField(
                            controller: _telefonoController,
                            enabled: false,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.phone,
                                color: kPrimaryColor,
                              ),
                              hintText: "Telefono",
                              labelText: "Telefono",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValue,
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: kPrimaryColor,
                            ),
                            iconSize: 30,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black87),
                            underline: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            onChanged: null,
                            items: <String>[
                              'T.I.',
                              'C.C.',
                              'C.E.',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: TextFormField(
                            controller: _num_documentoController,
                            enabled: false,
                            maxLength: 15,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.badge,
                                color: kPrimaryColor,
                              ),
                              hintText: "N Documento",
                              labelText: "N Documento",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: TextFormField(
                            controller: _correoController,
                            enabled: false,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.email,
                                color: kPrimaryColor,
                              ),
                              hintText: "E-mail",
                              labelText: "E-mail",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_grado_conductor/Login/NavigationDrawerWidget.dart';
import 'package:proyecto_grado_conductor/Model/EConductor.dart';
import 'package:proyecto_grado_conductor/Model/EPasajeros.dart';

import '../constants.dart';

class ReportarPasajero extends StatefulWidget {
  ReportarPasajero({
    Key? key,
    required this.documento,
  }) : super(key: key);

  String documento;

  @override
  _ReportarPasajeroState createState() => _ReportarPasajeroState();
}

class _ReportarPasajeroState extends State<ReportarPasajero> {
  final _codigoController = TextEditingController();
  final _sintomasController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _empresa = '';

  @override
  void dispose() {
    _codigoController.dispose();
    _sintomasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final database = FirebaseDatabase.instance.reference().child('Conductores');
    final databasePasajero = FirebaseDatabase.instance.reference().child('Pasajeros');
    final databaseReporte = FirebaseDatabase.instance.reference().child('Reportes');
    final f = new DateFormat('yyyy-MM-dd');

    String _idPasarPasajero = '';
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
      EConductor conductor = await getConductorData(widget.documento);
      var nombreCompleto = conductor.nombre;
      if(nombreCompleto.indexOf(" ") == -1){
        _nombre = conductor.nombre;
      }else{
        _nombre = nombreCompleto.substring(0,nombreCompleto.indexOf(" "));
      }
      _empresa = conductor.empresaId;
    }

    //Obtiene los datos del pasajero a pasar saldo
    Future<EPasajeros> getPasajeroDataPasar(String documento) async {
      return await databasePasajero.orderByChild("num_documento").equalTo(documento)
          .once()
          .then((result) {
        final LinkedHashMap value = result.value;
        _idPasarPasajero = value.keys.toString().replaceAll("(", "").replaceAll(")", "");
        return EPasajeros.fromMap(value.values.first);
      });
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
              title: Text('Reportar Pasajero'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 30,),
                      Container(
                        child:
                        Text(
                          'INGRESE EL N. DOCUMENTO DE LA PERSONA A QUIEN DESEA REPORTAR POR POSIBLE CONTAGIO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width / 23,
                            fontWeight: FontWeight.bold,),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: TextFormField(
                          controller: _codigoController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El N. Documento es requerido';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.person,
                              color: kPrimaryColor,
                            ),
                            hintText: "N. Documento",
                            labelText: "N. Documento",
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: TextFormField(
                          controller: _sintomasController,
                          maxLines: 8,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Los sintomas son requeridos';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.assignment_outlined,
                              color: kPrimaryColor,
                            ),
                            hintText: "Sintomas",
                            labelText: "Sintomas",
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ProgressButton(
                        defaultWidget: Text("Reportar", style: TextStyle(color: Colors.white),),
                        color: KPrimaryColorLogin,
                        borderRadius: 29,
                        progressWidget: const CircularProgressIndicator(),
                        width: size.width * 0.8,
                        height: size.height * 0.065,
                        onPressed: () async {
                          int score = await Future.delayed(
                              const Duration(milliseconds: 3000), () => 42);
                          // After [onPressed], it will trigger animation running backwards, from end to beginning
                          return () async{
                            if (_formKey.currentState!.validate()) {
                                try {
                                  EPasajeros pasajeroPasar = await getPasajeroDataPasar(_codigoController.text);
                                  var orderRef = databaseReporte.push();
                                  await orderRef.set({
                                    'fecha': f.format(DateTime.now()),
                                    'documentoPasajero': _codigoController.text,
                                    'sintomas': _sintomasController.text,
                                    'empresaId': _empresa
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Reporte existoso')),
                                  );
                                }catch(e){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Documento no encontrado')),
                                  );
                                }
                            }
                          };
                        },
                      ),
                    ]
                ),
              ),
            )
          );
      }
    );
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
import 'dart:collection';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_grado_conductor/Model/ECaja.dart';
import 'package:proyecto_grado_conductor/Model/EConductor.dart';

import '../constants.dart';

///Pie de pagina de la pantalla de vehiculo
class FooterVehiculo extends StatefulWidget {
  FooterVehiculo({
    Key? key,
    required this.size,
    required this.documento,
  }) : super(key: key);

  final Size size;
  String documento;

  @override
  _FooterVehiculoState createState() => _FooterVehiculoState(documento);
}

final database = FirebaseDatabase.instance.reference().child('Conductores');
final databaseCajas = FirebaseDatabase.instance.reference().child('Cajas');

//Obtiene los datos del conductor desde firebase
Future<EConductor> getConductorData(String userId) async {
  return await database.child(userId)
      .once()
      .then((result) {
    final LinkedHashMap value = result.value;
    return EConductor.fromMap(value);
  });
}

//Obtiene los datos del caja a enlazar
Future<ECaja?> getCajaData(String placa) async {
  return await databaseCajas.child(placa)
      .once()
      .then((result) {
    final LinkedHashMap value = result.value;
    if (value['conductorId'].toString().isEmpty){
      return ECaja.fromMap(value);
    }else{
      return null;
    }
  });
}

String _textoFooter = '';
String _vehiculo = '';
IconData _icono = Icons.add;

class _FooterVehiculoState extends State<FooterVehiculo> {
  _FooterVehiculoState(this.documento);
  String documento;
  String _caja = '';

  ScanResult? _scanResult;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e != BarcodeFormat.qr);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  Widget build(BuildContext context) {

    //Asigna los datos del conductor a las variable a pasar
    getConductor() async{
      EConductor conductor = await getConductorData(documento);
      if (conductor.cajaId.isEmpty){
        _vehiculo = 'Vehiculo sin enlazar';
        _textoFooter = 'ENLAZAR VEHICULO';
        _icono = Icons.add;
      }else{
        _textoFooter = 'DESENLAZAR VEHICULO';
        _icono = Icons.clear;
        _caja = conductor.cajaId;
        _vehiculo = 'Vehiculo No. ' + conductor.cajaId;
      }
    }

    return FutureBuilder(
        future: getConductor(),
        builder: (_, AsyncSnapshot snapshot) {
        return Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _vehiculo,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width / 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
            ),
            Container(
              height: widget.size.height * 0.3,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: widget.size.height * 3,
                    width: widget.size.width - 20,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: KSecundaryColor.withOpacity(0.45),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    _textoFooter,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: MediaQuery.of(context).size.width / 17,
                                    ),
                                  )
                              ),
                              SizedBox(height: 50,),
                              FloatingActionButton(
                                onPressed: () async{
                                  if (_textoFooter == 'DESENLAZAR VEHICULO'){
                                    await database.child(documento).update({
                                      'cajaId': ''
                                    });
                                    await databaseCajas.child(_caja).update({
                                      'conductorId': '',
                                      'rutaId': ''
                                    });
                                    setState(() {
                                      _vehiculo = 'Vehiculo sin enlazar';
                                      _textoFooter = 'ENLAZAR VEHICULO';
                                      _icono = Icons.add;
                                    });
                                  }else{
                                    await _scanCode();
                                    if (_scanResult!.rawContent != null){
                                      await database.child(documento).update({'cajaId': _scanResult!.rawContent});
                                      ECaja? caja = await getCajaData(_scanResult!.rawContent);
                                      if (caja != null) {
                                        await databaseCajas.child(_scanResult!.rawContent).update({'conductorId': documento});
                                        setState(() {
                                          _textoFooter = 'DESENLAZAR VEHICULO';
                                          _icono = Icons.clear;
                                          _vehiculo = 'Vehiculo No. ' + _scanResult!.rawContent;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Bus enlazado')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Bus ya enlazado')),
                                        );
                                      }
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Error al enlazar')),
                                      );
                                    }
                                  }
                                },
                                child: Icon(_icono),
                                backgroundColor: kPrimaryColor,
                              ),
                            ]
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(185, 193, 210, 0.8823529411764706)
                          ),
                          height: widget.size.height * 0.3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]
        );
      }
    );
  }

  Future _scanCode() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": "Cancelar",
          "flash_on": "Flash on",
          "flash_off": "Flash off",
        },
        restrictFormat: selectedFormats,
      );
      var result = await BarcodeScanner.scan(options: options);

      setState((){
        _scanResult = result;
      } );
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'Permiso de camara no adquirido';
        });
      } else {
        result.rawContent = 'Error desconocido: $e';
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ScanResult>('_scanResult', _scanResult));
  }
}

/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
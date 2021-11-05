import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_grado_conductor/Ganancias/GananciasRuta.dart';
import 'package:proyecto_grado_conductor/Login/NavigationDrawerWidget.dart';
import 'package:proyecto_grado_conductor/Model/ECaja.dart';
import 'package:proyecto_grado_conductor/Model/EConductor.dart';
import 'package:proyecto_grado_conductor/constants.dart';
import 'package:vibration/vibration.dart';
import 'HeaderInicio.dart';


final databaseRutas = FirebaseDatabase.instance.reference().child('RutaBusConductor');
final f = new DateFormat('yyyy-MM-dd');

///Pantalla de inicio
class Inicio extends StatefulWidget{
  Inicio({
    Key? key,
    required this.documento,
  }) : super(key: key);

  String documento;

  @override
  _InicioState createState() => _InicioState();
}

class AppValueNotifier{
  ValueNotifier ayuda = ValueNotifier(0);

  //Obtiene los datos de la ruta desde firebase
  void getRutaData(String cajaId, context) async {
    return await databaseRutas.orderByChild("fecha").equalTo(f.format(DateTime.now()))
        .once()
        .then((result) async {
      final LinkedHashMap value = result.value;
      num x = 0;
      if(value != null){
        for (int i = 0; i < value.values.length; i++){
          if (value.values.elementAt(i)['conductorId'] == cajaId){
            x = x + (value.values.elementAt(i)['numPasajeros'] * value.values.elementAt(i)['valor']);
          }
        }
      }
      if (ayuda.value != x && ayuda.value > 0){
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          messageText: Text('Ingresó un nuevo pasajero', style: new TextStyle(fontSize: 18,color: Colors.white)),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.green,
        ).show(context);
      }
      ayuda.value = x;
    });
  }
}

class _InicioState extends State<Inicio> {
  final database = FirebaseDatabase.instance.reference().child('Conductores');
  final databaseCajas = FirebaseDatabase.instance.reference().child('Cajas');
  final databasePasaje = FirebaseDatabase.instance.reference().child('ValorPasaje');


  AppValueNotifier appValueNotifier = AppValueNotifier();

  String _nombre = '';
  String _apellido = '';
  String _empresa = '';
  String _caja = '';
  String _boton = 'INICIAR';
  String dropdownValue = 'R1';
  bool _visibility = true;
  int _valorPasaje = 0;


  //Obtiene los datos del conductor desde firebase
  Future<EConductor> getConductorData(String userId) async {
    await databasePasaje.once()
        .then((result) {
      _valorPasaje = result.value;
    });
    return await database.child(userId)
        .once()
        .then((result) {
      final LinkedHashMap value = result.value;
      return EConductor.fromMap(value);
    });
  }
  int numPasajeros = 0;
  //Obtiene los datos del caja desde firebase
  Future<ECaja> getCajaData(String cajaId) async {
    return await databaseCajas.child(cajaId)
        .once()
        .then((result) {
      final LinkedHashMap value = result.value;
      if (value['rutaId'].toString().isNotEmpty){
        setState(() {
          _boton = 'FINALIZAR';
          _visibility = false;
        });
      }
      return ECaja.fromMap(value);
    });
  }

  //Asigna los datos del conductor a las variabla a pasar
  getConductor() async{
    EConductor conductor = await getConductorData(widget.documento);
    appValueNotifier.getRutaData(widget.documento, context);
    if (conductor.cajaId.isNotEmpty){
      await getCajaData(conductor.cajaId);
    }
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
    _empresa = conductor.empresaId;
    _caja = conductor.cajaId;
  }

  late Future future;
  @override
  void initState(){
    future = getConductor();
    super.initState();
  }

  @override
  void Dispose(){
    future;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: NavigationDrawerWidget(
        nombre: _nombre,
      ),
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
        title: Text('Inicio'),
      ),
      body: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            ValueListenableBuilder(
                valueListenable: appValueNotifier.ayuda,
                builder: (context, value, child) {
                  return Column(
                    children: <Widget>[
                      FutureBuilder(
                          future: getConductor(),
                          builder: (_, AsyncSnapshot snapshot) {
                            return HeaderInicio(
                                size: size,
                                nombre: _nombre,
                                apellido: _apellido,
                                generado: int.parse(value.toString()));
                          }
                      ),
                      Visibility(
                        visible: _visibility,
                        child: Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                width: size.width,
                                child: Row(children: [Text('Nombre Ruta')])),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
                                style:
                                const TextStyle(
                                    color: Colors.black87, fontSize: 15),
                                underline: Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'R1',
                                  'R2',
                                  'R3',
                                  'R4',
                                  'R5',
                                  'R6',
                                  'R7',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 60,
                        ),
                        height: size.height * 0.2 - 27,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Ruta',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: size.width * 0.4,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(29),
                                child: FlatButton(
                                  padding:
                                  EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 40),
                                  color: KPrimaryColorLogin,
                                  onPressed: () {
                                    setState(() {
                                      if (_boton == 'FINALIZAR') {
                                        _boton = 'INICIAR';
                                        _visibility = true;
                                        finalizarRuta();
                                      } else {
                                        if (_caja.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'No hay un bus enlazado')),
                                          );
                                        } else {
                                          _boton = 'FINALIZAR';
                                          _visibility = false;
                                          comenzarRuta();
                                        }
                                      }
                                    });
                                  },
                                  child: Text(
                                    _boton,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible: !_visibility,
                        child: Container(
                          child: Text('En curso...'),
                        ),
                      )
                    ],
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

  void comenzarRuta() async{
    var orderRef = databaseRutas.push();
    await orderRef.set({
      'fecha': f.format(DateTime.now()),
      'cajaId': _caja,
      'nomRuta': dropdownValue,
      'numPasajeros': 0,
      'valor': _valorPasaje,
      'conductorId': widget.documento,
      'estado': true,
      'empresaId': _empresa

    });
    await databaseCajas.child(_caja).update({
      'rutaId': orderRef.key
    });
  }

  void finalizarRuta() async{
    ECaja caja = await getCajaData(_caja);
    await databaseRutas.child(caja.rutaId).update({
      'estado': false
    });
    await databaseCajas.child(_caja).update({
      'rutaId': ''
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return GananciasRuta(documento: widget.documento,rutaId: caja.rutaId,);
        }));
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
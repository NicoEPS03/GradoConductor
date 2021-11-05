import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_grado_conductor/Ganancias/FooterGananciasDia.dart';
import 'package:proyecto_grado_conductor/Login/NavigationDrawerWidget.dart';
import 'package:proyecto_grado_conductor/Model/EConductor.dart';
import 'package:proyecto_grado_conductor/constants.dart';

class Ganancias extends StatefulWidget {
  Ganancias({
    Key? key,
    required this.documento,
  }) : super(key: key);

  String documento;

  @override
  _GananciasState createState() => _GananciasState();
}

class _GananciasState extends State<Ganancias> {
  final database = FirebaseDatabase.instance.reference().child('Conductores');
  final databaseRutas = FirebaseDatabase.instance.reference().child('RutaBusConductor');
  final f = new DateFormat('yyyy-MM-dd');

  String _nombre = '';

  num _generado = 0;

  Future<EConductor> getConductorData(String userId) async {
    return await database.child(userId)
        .once()
        .then((result) {
      final LinkedHashMap value = result.value;
      return EConductor.fromMap(value);
    });
  }

  Future<num> getRutaData(String cajaId) async {
    return await databaseRutas.orderByChild("fecha").equalTo(f.format(DateTime.now()))
        .once()
        .then((result) {
      final LinkedHashMap value = result.value;
      num x = 0;
      if(value != null){
        for (int i = 0; i < value.values.length; i++){
          if (value.values.elementAt(i)['conductorId'] == cajaId){
            x = x + (value.values.elementAt(i)['numPasajeros'] * value.values.elementAt(i)['valor']);
          }
        }
      }
      _generado = x;
      return _generado;
    });
  }

  getConductor() async{
    EConductor conductor = await getConductorData(widget.documento);
    await getRutaData(widget.documento);
    var nombreCompleto = conductor.nombre;
    if(nombreCompleto.indexOf(" ") == -1){
      _nombre = conductor.nombre;
    }else{
      _nombre = nombreCompleto.substring(0,nombreCompleto.indexOf(" "));
    }
  }

  late Future future;

  @override
  void initState(){
    future = getConductor();
    super.initState();
  }

  @override
  void Dispose(){
    _generado;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: future,
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
              title: Text('Ganancias'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30,),
                  Container(
                    child:
                    Text(
                      'GANANCIAS TOTALES',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width / 18,
                        fontWeight: FontWeight.bold,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child:
                    Text(
                      '\$' + _generado.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width / 15,
                        fontWeight: FontWeight.bold,),
                    ),
                  ),
                  SizedBox(height: 30,),
                  FooterGananciasDia(size: size,documento: widget.documento,),
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
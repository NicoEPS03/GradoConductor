import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_grado_conductor/Login/NavigationDrawerWidget.dart';
import 'package:proyecto_grado_conductor/Model/EConductor.dart';
import 'package:proyecto_grado_conductor/constants.dart';
import 'HeaderInicio.dart';

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

class _InicioState extends State<Inicio> {
  final database = FirebaseDatabase.instance.reference().child('Conductores');
  final databaseRutas = FirebaseDatabase.instance.reference().child('RutaBusConductor');
  final databaseBus = FirebaseDatabase.instance.reference().child('Buses');
  final f = new DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _nombre = '';
    String _apellido = '';
    String _bus = '';
    int _generado = 0;
    String _boton = 'INICIAR';
    String dropdownValue = 'Plaza de Mercado - La Arboleda';

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
      EConductor conductor = await getConductorData(widget.documento);
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
      _bus = conductor.busId;
    }

    return FutureBuilder(
        future: getConductor(),
        builder: (_,AsyncSnapshot snapshot){
          return Scaffold(
            drawer: NavigationDrawerWidget(
              nombre: _nombre,
            ),
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
              title: Text('Inicio'),
            ),
            body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    HeaderInicio(size: size, nombre: _nombre, apellido: _apellido, generado: _generado),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,),
                        width: size.width,
                        child: Row(children:[Text('Nombre Ruta')])
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,),
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward, color: kPrimaryColor,),
                        iconSize: 30,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black87,fontSize: 20),
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
                          'Plaza de Mercado - La Arboleda',
                          'La Arboleda - Portal de Maria',
                          'Portal de Maria - Cerezos Llano',
                          'Cerezos Llano - Santa Isabel',
                          'Santa Isabel - Terminal',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20,),
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
                                fontSize: MediaQuery.of(context).size.width / 15,
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
                                EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                                color: KPrimaryColorLogin,
                                onPressed: () async {
                                  if(_bus.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('No hay un bus enlazado')),
                                    );
                                  }else{
                                    var orderRef = databaseRutas.push();
                                    await orderRef.set({
                                      'fecha': f.format(DateTime.now()),
                                      'busId': _bus,
                                      'nomRuta': dropdownValue,
                                      'numPasajeros': 0,
                                      'valor': 1550,
                                      'estado': true
                                    });
                                    await databaseBus.child(_bus).update({
                                      'rutaId': orderRef.key
                                    });
                                  }
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
                  ],
                )
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
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_grado_conductor/Model/ERutaBusConductor.dart';

import '../constants.dart';
import 'GananciasRuta.dart';

///Pie de pagina de la pantalla de cuenta
class FooterGananciasDia extends StatelessWidget {
  FooterGananciasDia({
    Key? key,
    required this.size,
    required this.documento,
  }) : super(key: key);

  final Size size;
  final String documento;

  final databaseRuta = FirebaseDatabase.instance.reference().child('RutaBusConductor');
  final f = new DateFormat('yyyy-MM-dd');
  List<ERutaBusConductor> rutas = [];
  List<String> ids = [];

  @override
  Widget build(BuildContext context) {

    //Obtiene los datos del pago del pasjero desde firebase
    Future<List<ERutaBusConductor>> getPagosData() async {
      return await databaseRuta.orderByChild("conductorId").equalTo(documento)
          .once()
          .then((result) async {
        final LinkedHashMap value = result.value;
        for (int i = 0; i < value.values.length; i++){
          DateTime xfec = DateTime.parse(value.values.elementAt(i)['fecha']);
          if (xfec.difference(DateTime.now()).inDays == 0 && value.values.elementAt(i)['estado'] == false){
            ids.add(value.keys.elementAt(i));
            rutas.add(ERutaBusConductor.fromMap(value.values.elementAt(i)));
          }
        }
        return rutas;
      });
    }

    //Asigna los datos del rutas del conductor a las variabla a pasar
    getRutas() async{
      await getPagosData();
    }

    return FutureBuilder(
        future: getRutas(),
        builder: (_,AsyncSnapshot snapshot){
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: rutas.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: size.height * 0.13,
                  child: buildPago(
                    context,
                    documento: documento,
                    rutaId: ids[index],
                    nombre: rutas[index].nomRuta,
                    valor: rutas[index].valor * rutas[index].numPasajeros,
                  ),
                );
              }
          );
        }
    );
  }
}

Widget buildPago(BuildContext context,
    {required String documento,
      required String rutaId,
      required String nombre,
      required int valor}) {


  return Material(
    color: Colors.transparent,
    child: ListTile(
      title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Text(
                      nombre,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize:
                        MediaQuery.of(context).size.width / 20,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      style:  ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 20), primary: kPrimaryColor),
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return GananciasRuta(documento: documento,rutaId: rutaId);
                            }));
                      },
                      child: const Text('Ver'),
                    ),
                  ]
              ),
              Text(
                  '\$' + valor.toString(),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize:
                  MediaQuery.of(context).size.width / 24,
                ),
              )
            ],
          )),
    ),
  );
}

/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
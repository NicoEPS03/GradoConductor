import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

///Pie de pagina de la pantalla de cuenta
class FooterGanancias extends StatelessWidget {
  const FooterGanancias({
    Key? key,
    required this.size,
    required this.nombre,
    required this.numPasajeros,
    required this.ganancias
  }) : super(key: key);

  final Size size;
  final String nombre;
  final int numPasajeros;
  final int ganancias;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.39,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: size.height * 0.39,
            width: size.width - 20,
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
                    color: kPrimaryColorCuenta,
                    width: size.width - 20,
                    height: size.height * 0.13,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Nombre ruta',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width / 17,
                              ),
                            ),
                            Text(
                            nombre,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize:
                                    MediaQuery.of(context).size.width / 20,
                              ),
                            )
                          ],
                        ))),
                Container(
                    color: kPrimaryColorCuenta,
                    width: size.width - 20,
                    height: size.height * 0.13,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Ganancias totales',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                MediaQuery.of(context).size.width / 17,
                              ),
                            ),
                            Text(
                              ganancias.toString(),
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize:
                                MediaQuery.of(context).size.width / 20,
                              ),
                            )
                          ],
                        ))),
                Container(
                    color: kPrimaryColorCuenta,
                    width: size.width - 20,
                    height: size.height * 0.13,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Cantidad de pasajeros',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                MediaQuery.of(context).size.width / 17,
                              ),
                            ),
                            Text(
                              numPasajeros.toString(),
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize:
                                MediaQuery.of(context).size.width / 20,
                              ),
                            )
                          ],
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
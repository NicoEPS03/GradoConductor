import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

///Cabecera de la pantalla de inicio
class HeaderInicio extends StatelessWidget {

  const HeaderInicio({
    Key? key,
    required this.size,
    required this.nombre,
    required this.apellido,
    required this.generado,
  }) : super(key: key);

  final Size size;
  final String nombre;
  final String apellido;
  final int generado;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 60,
            ),
            height: size.height * 0.2 - 27,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  nombre + ' ' + apellido,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 15,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  '\$' + generado.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 16),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: size.height / 15.3,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              child: Column(
                children: <Widget>[
                  Text(
                    'Generado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 24,
                    ),
                  ),
                ],
              ),
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
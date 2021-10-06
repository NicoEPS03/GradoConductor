import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_grado_conductor/Cuenta/Cuenta.dart';
import 'package:proyecto_grado_conductor/Ganancias/Ganancias.dart';
import 'package:proyecto_grado_conductor/Login/Inicio.dart';
import 'package:proyecto_grado_conductor/Provider/NavigationProvider.dart';
import 'package:proyecto_grado_conductor/Vehiculo/Vehiculo.dart';
import 'package:proyecto_grado_conductor/constants.dart';
import 'package:proyecto_grado_conductor/Model/NavigationItem.dart';

class Menu extends StatelessWidget {
  Menu({
    Key? key,
    required this.documento,
  }) : super(key: key);
  String documento;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => NavigationProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MainPage(documento),
    ),
  );

}

class MainPage extends StatefulWidget {
  MainPage(this._documento);
  String _documento;
  @override
  _MainPageState createState() => _MainPageState(_documento);
}

class _MainPageState extends State<MainPage> {
  _MainPageState(this._documento);
  String _documento;

  @override
  Widget build(BuildContext context) => buildPages();

  /// Función que cambia la pantalla del menú lateral
  Widget buildPages(){
    final provider = Provider.of<NavigationProvider>(context);
    final navigationItem = provider.navigationItem;

    switch (navigationItem){
      case NavigationItem.inicio:
        return Inicio(documento: _documento,);
      case NavigationItem.ganancias:
        return Ganancias();
      case NavigationItem.vehiculo:
        return Vehiculo(documento: _documento,);
      case NavigationItem.configuracion:
        return Cuenta(documento: _documento,);
    }
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
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
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => NavigationProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MainPage(),
    ),
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => buildPages();

  /// Función que cambia la pantalla del menú lateral
  Widget buildPages(){
    final provider = Provider.of<NavigationProvider>(context);
    final navigationItem = provider.navigationItem;

    switch (navigationItem){
      case NavigationItem.inicio:
        return Inicio();
      case NavigationItem.ganancias:
        return Ganancias();
      case NavigationItem.vehiculo:
        return Vehiculo();
      case NavigationItem.configuracion:
        return Cuenta();
    }
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
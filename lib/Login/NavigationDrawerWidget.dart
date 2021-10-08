import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_grado_conductor/Model/NavigationItem.dart';
import 'package:proyecto_grado_conductor/Provider/NavigationProvider.dart';
import '../constants.dart';

///Dibujo de las opciones en el menu lateral
class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({
    Key? key,
    required this.nombre,
  }) : super(key: key);

  final String nombre;

  static final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) => Drawer(
        child: Container(
          color: kPrimaryColor,
          child: ListView(
            children: <Widget>[
              Container(
                padding: padding,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    buildHeader(
                      context,
                      name: nombre,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Opciones',
                          style: TextStyle(
                              fontSize: 21,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    buildMenuItem(
                      context,
                      item: NavigationItem.inicio,
                      text: 'Inicio',
                      icon: Icons.home,
                    ),
                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.ganancias,
                      text: 'Ganancias del día',
                      icon: Icons.money,
                    ),
                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.vehiculo,
                      text: 'Vehículo',
                      icon: Icons.directions_bus,
                    ),
                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.reporta,
                      text: 'Reportar',
                      icon: Icons.account_circle,
                    ),
                    const SizedBox(height: 24),
                    Divider(color: Colors.white70),
                    const SizedBox(height: 24),
                    buildMenuItem(
                      context,
                      item: NavigationItem.configuracion,
                      text: 'Configuración',
                      icon: Icons.settings,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  ///Diseño de cada opción en el menú lateral
  Widget buildMenuItem(BuildContext context,
      {required NavigationItem item,
      required String text,
      required IconData icon}) {
    final color = Colors.white;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(text, style: TextStyle(color: color, fontSize: 16)),
        onTap: () => selectItem(context, item),
      ),
    );
  }

  ///Función que redirigue a la pantalla requerida en el menu
  void selectItem(BuildContext context, NavigationItem item) {
    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.setNavigationItem(item);
  }

  ///Diseño cabecera en el menu lateral
  Widget buildHeader(
    BuildContext context, {
    required String name
  }) =>
      Material(
        color: Colors.transparent,
        child: Container(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
import 'package:flutter/material.dart';
import 'package:proyecto_grado_conductor/Model/NavigationItem.dart';

///Función para notificar el cambio de pantalla y mostrar la nueva pantalla
class NavigationProvider extends ChangeNotifier {
  ///Se escoge la pantalla a mostrar primero después de logearse
  NavigationItem _navigationItem = NavigationItem.inicio;

  NavigationItem get navigationItem => _navigationItem;

  void setNavigationItem(NavigationItem navigationItem) {
    _navigationItem = navigationItem;

    notifyListeners();
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
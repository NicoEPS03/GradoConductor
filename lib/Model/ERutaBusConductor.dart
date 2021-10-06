class ERutaBusConductor{
  DateTime fecha;
  String busId;
  String nomRuta;
  int numPasajeros;
  int valor;
  bool estado;

  ERutaBusConductor({
    required this.fecha,
    required this.busId,
    required this.nomRuta,
    required this.numPasajeros,
    required this.valor,
    required this.estado
  });

  Map<String, Object> toMap(){
    return {
      'fecha' : fecha,
      'busId' : busId,
      'nomRuta' : nomRuta,
      'numPasajeros' : numPasajeros,
      'valor' : valor,
      'estado' : estado
    };
  }

  static ERutaBusConductor fromMap(Map value){
    return ERutaBusConductor(
        fecha: value['fecha'],
        busId: value['busId'],
        nomRuta: value['nomRuta'],
        numPasajeros: value['numPasajeros'],
        valor: value['valor'],
        estado: value['estado']
    );
  }
}
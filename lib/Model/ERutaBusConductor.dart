class ERutaBusConductor{
  String fecha;
  String cajaId;
  String nomRuta;
  int numPasajeros;
  int valor;
  bool estado;

  ERutaBusConductor({
    required this.fecha,
    required this.cajaId,
    required this.nomRuta,
    required this.numPasajeros,
    required this.valor,
    required this.estado
  });

  Map<String, Object> toMap(){
    return {
      'fecha' : fecha,
      'cajaId' : cajaId,
      'nomRuta' : nomRuta,
      'numPasajeros' : numPasajeros,
      'valor' : valor,
      'estado' : estado
    };
  }

  static ERutaBusConductor fromMap(Map value){
    return ERutaBusConductor(
        fecha: value['fecha'],
        cajaId: value['cajaId'],
        nomRuta: value['nomRuta'],
        numPasajeros: value['numPasajeros'],
        valor: value['valor'],
        estado: value['estado']
    );
  }
}
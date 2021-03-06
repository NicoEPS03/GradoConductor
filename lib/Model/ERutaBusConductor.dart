class ERutaBusConductor{
  String fecha;
  String cajaId;
  String nomRuta;
  int numPasajeros;
  int valor;
  String conductorId;
  bool estado;
  String empresaId;

  ERutaBusConductor({
    required this.fecha,
    required this.cajaId,
    required this.nomRuta,
    required this.numPasajeros,
    required this.valor,
    required this.conductorId,
    required this.estado,
    required this.empresaId
  });

  Map<String, Object> toMap(){
    return {
      'fecha' : fecha,
      'cajaId' : cajaId,
      'nomRuta' : nomRuta,
      'numPasajeros' : numPasajeros,
      'valor' : valor,
      'conductorId' : conductorId,
      'estado' : estado,
      'empresaId' : empresaId
    };
  }

  static ERutaBusConductor fromMap(Map value){
    return ERutaBusConductor(
        fecha: value['fecha'],
        cajaId: value['cajaId'],
        nomRuta: value['nomRuta'],
        numPasajeros: value['numPasajeros'],
        valor: value['valor'],
        conductorId: value['conductorId'],
        estado: value['estado'],
        empresaId: value['empresaId']
    );
  }
}
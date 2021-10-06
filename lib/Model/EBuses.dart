class EBuses{
  String placa;
  String empresaId;
  String cajaId;
  String conductorId;
  String rutaId;
  bool estado;

  EBuses({
    required this.placa,
    required this.empresaId,
    required this.cajaId,
    required this.conductorId,
    required this.rutaId,
    required this.estado
  });

  Map<String, Object> toMap(){
    return {
      'placa' : placa,
      'empresaId' : empresaId,
      'cajaId' : cajaId,
      'conductorId' : conductorId,
      'rutaId' : rutaId,
      'estado' : estado
    };
  }

  static EBuses fromMap(Map value){
    return EBuses(
        placa: value['placa'],
        empresaId: value['empresaId'],
        cajaId: value['cajaId'],
        conductorId: value['conductorId'],
        rutaId: value['rutaId'],
        estado: value['estado']
    );
  }
}
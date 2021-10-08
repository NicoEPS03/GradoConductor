class EPasajeros {
  String nombre;
  String apellido;
  String telefono;
  String num_documento;
  String correo;
  String clave;
  int saldo;
  String id_NFC;
  bool estado;

  EPasajeros({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.num_documento,
    required this.correo,
    required this.clave,
    required this.saldo,
    required this.id_NFC,
    required this.estado
  });

  Map<String, Object> toMap(){
    return {
      'nombre' : nombre,
      'apellido' : apellido,
      'telefono' : telefono,
      'num_documento' : num_documento,
      'correo' : correo,
      'clave' : clave,
      'saldo' : saldo,
      'id_NFC' : id_NFC,
      'estado' : estado
    };
  }

  static EPasajeros fromMap(Map value){
    return EPasajeros(
        nombre: value['nombre'],
        apellido: value['apellido'],
        telefono: value['telefono'],
        num_documento: value['num_documento'],
        correo: value['correo'],
        clave: value['clave'],
        saldo: value['saldo'],
        id_NFC: value['id_NFC'],
        estado: value['estado']
    );
  }
}
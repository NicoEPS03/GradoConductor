class EConductor{
  String nombre;
  String apellido;
  String telefono;
  String tipoDocumento;
  String numDocumento;
  String correo;
  String clave;
  String busId;
  String empresaId;
  bool estado;

  EConductor({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.tipoDocumento,
    required this.numDocumento,
    required this.correo,
    required this.clave,
    required this.busId,
    required this.empresaId,
    required this.estado
  });

  Map<String, Object> toMap(){
    return {
      'nombre' : nombre,
      'apellido' : apellido,
      'telefono' : telefono,
      'tipoDocumento' : tipoDocumento,
      'numDocumento' : numDocumento,
      'correo' : correo,
      'clave' : clave,
      'bus' : busId,
      'empresaId' : empresaId,
      'estado' : estado
    };
  }

  static EConductor fromMap(Map value){
    return EConductor(
        nombre: value['nombre'],
        apellido: value['apellido'],
        telefono: value['telefono'],
        tipoDocumento: value['tipoDocumento'],
        numDocumento: value['numDocumento'],
        correo: value['correo'],
        clave: value['clave'],
        busId: value['busId'],
        empresaId: value['empresaId'],
        estado: value['estado']
    );
  }
}
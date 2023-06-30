class Agendamiento {
  final int id;
  final String cancha;
  final String fecha;
  final String usuario;

  Agendamiento({
    required this.id,
    required this.cancha,
    required this.fecha,
    required this.usuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'cancha': cancha,
      'fecha': fecha,
      'usuario': usuario,
    };
  }

  factory Agendamiento.fromMap(Map<String, dynamic> map) {
    return Agendamiento(
      id: map['id'],
      cancha: map['cancha'],
      fecha: map['fecha'],
      usuario: map['usuario'],
    );
  }
}

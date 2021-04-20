// To parse this JSON data, do
//
//     final aplicacion = aplicacionFromJson(jsonString);

import 'dart:convert';

Aplicacion aplicacionFromJson(String str) => Aplicacion.fromJson(json.decode(str));

String aplicacionToJson(Aplicacion data) => json.encode(data.toJson());

class Aplicacion {
    Aplicacion({
        this.oid,
        this.nombre,
        this.icono,
        this.paquete,
        this.modulo,
    });

    String oid;
    String nombre;
    String icono;
    String paquete;
    String modulo;

    factory Aplicacion.fromJson(Map<String, dynamic> json) => Aplicacion(
        oid: json["oid"],
        nombre: json["nombre"],
        icono: json["icono"],
        paquete: json["paquete"],
        modulo: json["modulo"],
    );

    Map<String, dynamic> toJson() => {
        "oid": oid,
        "nombre": nombre,
        "icono": icono,
        "paquete": paquete,
        "modulo": modulo,
    };
}

import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:suweb_login/ambientes.dart' as global;
import 'package:suweb_login/dominio/modeloApps_model.dart';

import 'preferenciasdeusario.dart';
final String urlBase = global.url;

// Clase que contiene los servicios de la clase login
class ServiciosLogin {
  final String url = urlBase + 'funcionesLogin.php';
  final prefs = PreferenciasUsuario();

  final String urlLogin = urlBase + 'funcionesLogin.php';

  Future<Map<dynamic,dynamic>> iniciarSesion(
      String usuario,
      String clave,
      String cmbCasa,
      String cmbEmpresa,
      String cmbCiudad,
      String cmbOficina,
      String cmbSeccion) async {
    var datosForm={
        "usuario": usuario,
        "clave": clave,
        "cmbCasa": cmbCasa,
        "cmbEmpresa": cmbEmpresa,
        "cmbCiudad": cmbCiudad,
        "cmbOficina": cmbOficina,
        "cmbSeccion": cmbSeccion
      };
     
    var data = {
      "funcionphp": "iniciarSesion",
      "datosForm": json.encode(datosForm)
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlLogin, data: encodedData);
    final decodeData = jsonDecode(response.data);
    print(decodeData);

  
    return decodeData;
  }
   final urlApps = urlBase+"controladores/funcionesNotificacionesPush.php";
   List _aplicaciones= new List();
   Future<List<Aplicacion>> listarApps() async {
    var data = {
      "funcionphp": "listarApps",
      "dispositivo": "movil",
      
    };
    var dio = Dio();
    final encodedData = FormData.fromMap(data);
    // make POST request
    Response response = await dio.post(urlApps, data: encodedData);
    final decodeData = jsonDecode(response.data);
    if (!decodeData.isEmpty){
      var list = decodeData['appsValores'] as List;
      var _aplicaciones = list.map((i) => Aplicacion.fromJson(i)).toList();

      return _aplicaciones;

    }
    

    return _aplicaciones;
  }
}

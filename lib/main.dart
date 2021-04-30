import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'aplicacion/home_pagina.dart';
import 'aplicacion/login_pagina.dart';
import 'infraestructua/preferenciasdeusario.dart';
import 'infraestructua/proveedorusuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}
class StorageClass {
  Future<String> get localPath async {
    final dir = await  getExternalStorageDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    print('$path/db.txt');
    return File('$path/db.txt');
    
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      print(body);
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("$data");
    
  }
}


class MyApp extends StatefulWidget {
 
   
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  @override

  void initState() {
    super.initState();
   
  }

  @override 
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InformacionUsuario()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: _route(),
        navigatorKey: navigatorKey,
        routes: {
           'login': (context) => LoginPagina(),
           'homeUsuario': (context) => HomeUsuario(storage: StorageClass(),),
        },
      )
    );
  }

  /* 
    This function return the route to navigate
    after phone starts 
  */
  _route<String>() {
    final userPreferences = new PreferenciasUsuario();
    // Routes Switch
    if (userPreferences.logeado == true ) {
      var route = 'homeUsuario';
     
      return route;
    } else {
      return 'login';
    }
  }

  /*
    This function checks if the current enviroment is development or production
    development : return true
    production : return false
  */
 
}

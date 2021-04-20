/* Flutter dependencies */
import 'dart:ui';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suweb_login/ambientes.dart' as global;
import 'package:suweb_login/dominio/modeloApps_model.dart';
import 'package:suweb_login/infraestructua/preferenciasdeusario.dart';
import 'package:suweb_login/infraestructua/serviciosLogin_services.dart';

import '../main.dart';
import 'menuDrawer_widget.dart';

class HomeUsuario extends StatefulWidget {
  final StorageClass storage;
  final String seccion;
  HomeUsuario({Key key, @required this.storage,this.seccion}) : super(key: key);

  @override
  HomeUsuarioState createState() => HomeUsuarioState();
}

class HomeUsuarioState extends State<HomeUsuario> {
  final prefs = PreferenciasUsuario();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Application app;
  
 
  @override
  // guardo en el documento global la información del usuario.
  void initState() {
    widget.storage.writeData(
        '["${prefs.codigo}","${prefs.ciudad}","${prefs.oficina}","${prefs.seccion}","${prefs.idSeccion}","${prefs.oidOficinaTercero}"]');
    widget.storage.readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuWidget(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, size.height * 0.2, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.thLarge,
                      color: Colors.red,
                      size: 40,
                    ),
                    title: Text(
                      'Mis aplicaciones',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _scaffoldKey.currentState.openDrawer(),
                  child: Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image(
                          image: NetworkImage(
                            global.url + 'images/USUARIO_ICONO.png',
                          ),
                          width: size.width * 0.25,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 300, 0, 0),
            child: CardAPlicaciones(),
          ),
        ],
      ),
    );
  }
}

class CardAPlicaciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final servicesProvider = ServiciosLogin();
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: NetworkImage(global.url + 'images/FONDO.png'),
        fit: BoxFit.cover,
      )),
      child: FutureBuilder(
          future: servicesProvider.listarApps(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Aplicacion>> snapshot) {
            if (snapshot.hasData) {
              final aplicaciones = snapshot.data;
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: aplicaciones.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new _Card(aplicaciones[index]);
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  // obtiene la informacion de la app instalada

}

class _Card extends StatelessWidget {
  final Aplicacion app;
  _Card(this.app);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(app.icono);
    return Center(
      child: Stack(
        children: <Widget>[
          Positioned(
              child: Column(
            children: <Widget>[
              new RawMaterialButton(
                  onPressed: () => {DeviceApps.openApp(app.paquete)},
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: size.width * 0.17,
                    backgroundImage: NetworkImage(global.url + app.icono),
                  )),
              Text(app.nombre,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.bold)),
            ],
          ))
        ],
      ),
    );
  }
}

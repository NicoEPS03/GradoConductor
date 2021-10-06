import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_grado_conductor/Login/Menu.dart';
import 'package:proyecto_grado_conductor/Model/EConductor.dart';
import '../constants.dart';

///Pantalla de logeo
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var visibility = false;
  final database = FirebaseDatabase.instance.reference().child('Conductores');

  final _documentoController = TextEditingController();
  final _claveController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _documentoController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //Obtiene los datos del conductor
    Future<EConductor?> getConductorData(String documento, String clave) async {
        return await database.child(documento)
            .once()
            .then((result) {
          final LinkedHashMap value = result.value;
          if (value['clave'] != clave){
            return null;
          }else{
            return EConductor.fromMap(value);
          }
        });
    }

    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/main_top.png",
                  width: size.width * 0.4,
                )),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        cursorColor: kPrimaryColor,
                        controller: _documentoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El documento es requerido';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: KPrimaryColorLogin,
                          ),
                          hintText: "Documento",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _claveController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El contraseña es requerida';
                          }
                          return null;
                        },
                        obscureText: !this.visibility,
                        cursorColor: KPrimaryColorLogin,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          icon: Icon(
                            Icons.lock,
                            color: KPrimaryColorLogin,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              visibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: KPrimaryColorLogin,
                            ),
                            onPressed: () {
                              setState(() {
                                this.visibility = !this.visibility;
                              });
                            },
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FlatButton(
                          padding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                          color: KPrimaryColorLogin,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                EConductor? conductor = await getConductorData(_documentoController.text, _claveController.text);
                                if (conductor != null){
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<Null>(
                                      builder: (BuildContext context){
                                        return new Menu(documento: conductor.numDocumento,);
                                      })
                                      , (Route<dynamic> route) => false);
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Credenciales incorrectas')),
                                  );
                                }
                              } catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Credenciales incorrectas')),
                                );
                              }
                            }
                          },
                          child: Text(
                            "Ingresar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/login_bottom.png",
                  width: size.width * 0.4,
                ))
          ],
        ),
      ),
    );
  }
}
/*        _   _       __  _   _
 /|/ / / ` / / /  / /  /_/ /_`
/ | / /_, /_/ /_,/ /  / / ._/  /_/|/|//_/
 */
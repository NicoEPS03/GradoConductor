import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:proyecto_grado_pasajero/Login/Menu.dart';
import '../constants.dart';

///Pantalla de logeo
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var visibility = false;
  final auth = FirebaseAuth.instance;

  final _correoController = TextEditingController();
  final _claveController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _correoController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                        controller: _correoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El e-mail es requerido';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: KPrimaryColorLogin,
                          ),
                          hintText: "E-mail",
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
                                await auth.signInWithEmailAndPassword(email: _correoController.text , password: _claveController.text);
                                if(auth.currentUser!.emailVerified == true){
                                  /*Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<Null>(
                                      builder: (BuildContext context){
                                        return new Menu();
                                      })
                                      , (Route<dynamic> route) => false);*/
                                  /*Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return Menu();
                                      }));*/
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Cuenta sin verificar')),
                                  );
                                  auth.currentUser!.sendEmailVerification();
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Email no registrado')),
                                  );
                                } else if (e.code == 'wrong-password') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Contraseña incorrecta')),
                                  );
                                }
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
            //asdas
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
import 'dart:async';
import 'dart:math' as math;

import 'package:app_faro_lago/constants/constants.dart';
import 'package:app_faro_lago/myWidgets/custom_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../myWidgets/my_text_field.dart';

//TODO: ADD PASSWORD RECOVERY
class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  Offset offset = Offset.zero;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool switcher = true;
  bool waiting = false;
  String message = "Inicio de sesión";
  final _auth = FirebaseAuth.instance;
  late StreamSubscription<User?> newLog;
  void isLogged() async {
    newLog = _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.pushNamed(context, "MainScreen");
      }
    });
  }

  @override
  void dispose() {
    newLog.cancel();
    super.dispose();
  }

  @override
  void initState() {
    isLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      color: kRed,
      inAsyncCall: waiting,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: kGrey,
            appBar: AppBar(
              title: Text(
                message,
                style: kSubTextWhite,
              ),
              backgroundColor: kRed,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MyTextField(
                      keyboardType: TextInputType.emailAddress,
                      labelText: "Digite su correo @",
                      messageController: emailController,
                      borderRadius: 25,
                      borderSideColor: kWhite,
                    ),
                    MyTextField(
                      keyboardType: TextInputType.emailAddress,
                      labelText: "Digite su contraseña",
                      messageController: passwordController,
                      borderRadius: 25,
                      borderSideColor: kWhite,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Registrarse",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        SizedBox(
                          width: deviceWidth * .02,
                        ),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                              inactiveThumbColor: kRed,
                              inactiveTrackColor: kRed.withOpacity(0.75),
                              activeColor: kRed,
                              activeTrackColor: kRed.withOpacity(0.75),
                              value: switcher,
                              onChanged: (value) {
                                setState(() {
                                  switcher = !switcher;
                                });
                              }),
                        ),
                        SizedBox(
                          width: deviceWidth * .02,
                        ),
                        const Text(
                          "Iniciar sesión",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        )
                      ],
                    ),
                    SizedBox(
                      height: deviceHeight * .08,
                    ),
                    Cbuttons(
                        onPressed: () async {
                          setState(() {
                            waiting = true;
                          });
                          bool fields = true;
                          if (passwordController.value.text == "") {
                            setState(() {
                              Alert(
                                title: "Espacio vacío",
                                style: AlertStyle(
                                  isCloseButton: false,
                                  overlayColor: kGrey.withOpacity(0.5),
                                  backgroundColor: kGrey,
                                  alertBorder: const ContinuousRectangleBorder(
                                    side: BorderSide(color: kRed, width: 3),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                    ),
                                  ),
                                  titleStyle: kSubTextWhite,
                                  descStyle: kSubTextWhite,
                                ),
                                desc: "Debe ingresar una contraseña",
                                context: context,
                                buttons: [
                                  DialogButton(
                                    child: const Icon(
                                      Icons.clear,
                                      size: 25,
                                      color: kWhite,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 120,
                                    color: kRed,
                                  )
                                ],
                              ).show();
                              waiting = false;
                            });
                            fields = false;
                          }
                          if (emailController.value.text == "") {
                            setState(() {
                              Alert(
                                title: "Campo vacío",
                                style: AlertStyle(
                                  isCloseButton: false,
                                  overlayColor: kGrey.withOpacity(0.5),
                                  backgroundColor: kGrey,
                                  alertBorder: const ContinuousRectangleBorder(
                                    side: BorderSide(color: kRed, width: 3),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                    ),
                                  ),
                                  titleStyle: kSubTextWhite,
                                  descStyle: kSubTextWhite,
                                ),
                                desc: "Debe ingresar un correo electrónico",
                                context: context,
                                buttons: [
                                  DialogButton(
                                    child: const Icon(
                                      Icons.clear,
                                      size: 25,
                                      color: kWhite,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    width: 120,
                                    color: kRed,
                                  )
                                ],
                              ).show();
                              waiting = false;
                            });
                            fields = false;
                          }
                          if (switcher) {
                            if (fields) {
                              try {
                                UserCredential userCredential =
                                    await _auth.signInWithEmailAndPassword(
                                        email: emailController.value.text,
                                        password:
                                            passwordController.value.text);
                                setState(() {
                                  waiting = !waiting;
                                });
                                newLog.cancel();
                                Navigator.pushNamed(context, "MainScreen");
                              } on FirebaseAuthException catch (e) {
                                //print(e);
                                if (e.code == 'user-not-found') {
                                  setState(() {
                                    Alert(
                                      title: "Usuario no encontrado",
                                      style: AlertStyle(
                                        isCloseButton: false,
                                        overlayColor: kGrey.withOpacity(0.5),
                                        backgroundColor: kGrey,
                                        alertBorder:
                                            const ContinuousRectangleBorder(
                                          side:
                                              BorderSide(color: kRed, width: 3),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                          ),
                                        ),
                                        titleStyle: kSubTextWhite,
                                        descStyle: kSubTextWhite,
                                      ),
                                      desc:
                                          "No se encontró un usuario asociado a este correo electrónico",
                                      context: context,
                                      buttons: [
                                        DialogButton(
                                          child: const Icon(
                                            Icons.clear,
                                            size: 25,
                                            color: kWhite,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                          color: kRed,
                                        )
                                      ],
                                    ).show();
                                    waiting = !waiting;
                                  });
                                } else if (e.code == 'wrong-password') {
                                  setState(() {
                                    Alert(
                                      title: "Contraseña incorrecta",
                                      style: AlertStyle(
                                        isCloseButton: false,
                                        overlayColor: kGrey.withOpacity(0.5),
                                        backgroundColor: kGrey,
                                        alertBorder:
                                            const ContinuousRectangleBorder(
                                          side:
                                              BorderSide(color: kRed, width: 3),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                          ),
                                        ),
                                        titleStyle: kSubTextWhite,
                                        descStyle: kSubTextWhite,
                                      ),
                                      desc:
                                          "Esta contraseña no perteneca al correo digitado",
                                      context: context,
                                      buttons: [
                                        DialogButton(
                                          child: const Icon(
                                            Icons.clear,
                                            size: 25,
                                            color: kWhite,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                          color: kRed,
                                        )
                                      ],
                                    ).show();
                                    waiting = !waiting;
                                  });
                                } else if (e.code == "invalid-email") {
                                  setState(() {
                                    Alert(
                                      title: "Correo inválido",
                                      style: AlertStyle(
                                        isCloseButton: false,
                                        overlayColor: kGrey.withOpacity(0.5),
                                        backgroundColor: kGrey,
                                        alertBorder:
                                            const ContinuousRectangleBorder(
                                          side:
                                              BorderSide(color: kRed, width: 3),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                          ),
                                        ),
                                        titleStyle: kSubTextWhite,
                                        descStyle: kSubTextWhite,
                                      ),
                                      desc: "Debe ingresar un correo válido",
                                      context: context,
                                      buttons: [
                                        DialogButton(
                                          child: const Icon(
                                            Icons.clear,
                                            size: 25,
                                            color: kWhite,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                          color: kRed,
                                        )
                                      ],
                                    ).show();

                                    waiting = !waiting;
                                  });
                                } else {
                                  setState(() {
                                    Alert(
                                      title: "Error iniciando sesión",
                                      style: AlertStyle(
                                        isCloseButton: false,
                                        overlayColor: kGrey.withOpacity(0.5),
                                        backgroundColor: kGrey,
                                        alertBorder:
                                            const ContinuousRectangleBorder(
                                          side:
                                              BorderSide(color: kRed, width: 3),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                          ),
                                        ),
                                        titleStyle: kSubTextWhite,
                                        descStyle: kSubTextWhite,
                                      ),
                                      desc:
                                          "Hubo un error iniciando sesión inténtelo nuevamente",
                                      context: context,
                                      buttons: [
                                        DialogButton(
                                          child: const Icon(
                                            Icons.clear,
                                            size: 25,
                                            color: kWhite,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                          color: kRed,
                                        )
                                      ],
                                    ).show();

                                    waiting = !waiting;
                                  });
                                }
                              }
                            }
                          } else {
                            if (fields) {
                              try {
                                UserCredential userCredential =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: emailController.value.text,
                                        password:
                                            passwordController.value.text);
                                setState(() {
                                  waiting = !waiting;
                                });
                                newLog.cancel();
                                Navigator.pushNamed(context, "MainScreen");
                              } on FirebaseAuthException catch (e) {
                                //print(e);
                                if (e.code == 'weak-password') {
                                  setState(() {
                                    Alert(
                                      title: "Contraseña débil",
                                      style: AlertStyle(
                                        isCloseButton: false,
                                        overlayColor: kGrey.withOpacity(0.5),
                                        backgroundColor: kGrey,
                                        alertBorder:
                                            const ContinuousRectangleBorder(
                                          side:
                                              BorderSide(color: kRed, width: 3),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                          ),
                                        ),
                                        titleStyle: kSubTextWhite,
                                        descStyle: kSubTextWhite,
                                      ),
                                      desc:
                                          "La contraseña debe tener 6 carácteres",
                                      context: context,
                                      buttons: [
                                        DialogButton(
                                          child: const Icon(
                                            Icons.clear,
                                            size: 25,
                                            color: kWhite,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                          color: kRed,
                                        )
                                      ],
                                    ).show();
                                    waiting = !waiting;
                                  });
                                } else if (e.code == 'email-already-in-use') {
                                  setState(() {
                                    Alert(
                                      title: "Correo ya existente",
                                      style: AlertStyle(
                                        isCloseButton: false,
                                        overlayColor: kGrey.withOpacity(0.5),
                                        backgroundColor: kGrey,
                                        alertBorder:
                                            const ContinuousRectangleBorder(
                                          side:
                                              BorderSide(color: kRed, width: 3),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                          ),
                                        ),
                                        titleStyle: kSubTextWhite,
                                        descStyle: kSubTextWhite,
                                      ),
                                      desc: "Ese correo ya está registrado",
                                      context: context,
                                      buttons: [
                                        DialogButton(
                                          child: const Icon(
                                            Icons.clear,
                                            size: 25,
                                            color: kWhite,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                          color: kRed,
                                        )
                                      ],
                                    ).show();
                                    waiting = !waiting;
                                  });
                                } else if (e.code == "invalid-email") {
                                  setState(() {
                                    Alert(
                                      title: "Correo inválido",
                                      style: AlertStyle(
                                        isCloseButton: false,
                                        overlayColor: kGrey.withOpacity(0.5),
                                        backgroundColor: kGrey,
                                        alertBorder:
                                            const ContinuousRectangleBorder(
                                          side:
                                              BorderSide(color: kRed, width: 3),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                          ),
                                        ),
                                        titleStyle: kSubTextWhite,
                                        descStyle: kSubTextWhite,
                                      ),
                                      desc: "Debe ingresar un correo válido",
                                      context: context,
                                      buttons: [
                                        DialogButton(
                                          child: const Icon(
                                            Icons.clear,
                                            size: 25,
                                            color: kWhite,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          width: 120,
                                          color: kRed,
                                        )
                                      ],
                                    ).show();
                                    waiting = !waiting;
                                  });
                                } else {
                                  Alert(
                                    title: "Error iniciando sesión",
                                    style: AlertStyle(
                                      isCloseButton: false,
                                      overlayColor: kGrey.withOpacity(0.5),
                                      backgroundColor: kGrey,
                                      alertBorder:
                                          const ContinuousRectangleBorder(
                                        side: BorderSide(color: kRed, width: 3),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                        ),
                                      ),
                                      titleStyle: kSubTextWhite,
                                      descStyle: kSubTextWhite,
                                    ),
                                    desc:
                                        "Hubo un error iniciando sesión inténtelo nuevamente",
                                    context: context,
                                    buttons: [
                                      DialogButton(
                                        child: const Icon(
                                          Icons.clear,
                                          size: 25,
                                          color: kWhite,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                        color: kRed,
                                      )
                                    ],
                                  ).show();
                                  setState(() {
                                    waiting = !waiting;
                                  });
                                }
                              }
                            }
                          }
                        },
                        backgroundColor: kRed,
                        child: const Icon(
                          Icons.check_rounded,
                          size: 30,
                          color: kWhite,
                        ),
                        padding: 15,
                        borderRadius: 25)
                  ],
                ),
              ),
            ),
          ),
          AnimatedSlide(
            offset: offset,
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeInOut,
            child: Scaffold(
              backgroundColor: kGrey,
              body: OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 50,
                          ),
                          height: deviceHeight,
                          width: deviceWidth,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/Fondo.jpeg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Ganadera\nFaro del\nLago",
                                    style: kMainText,
                                    textAlign: TextAlign.left,
                                    textScaleFactor: 2.5,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: deviceHeight * .15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Cbuttons(
                                    onPressed: () {
                                      setState(() {
                                        offset -= const Offset(1, 0);
                                      });
                                    },
                                    backgroundColor: kRed,
                                    padding: 15.0,
                                    borderRadius: 25,
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: Image.asset(
                                        "images/161-trending-flat-outline.gif",
                                        color: kWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 50,
                          ),
                          height: deviceHeight,
                          width: deviceWidth,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/Fondo.jpeg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Ganadera\nFaro del\nLago",
                                    style: kMainText,
                                    textAlign: TextAlign.left,
                                    textScaleFactor: 2.5,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: deviceHeight * .15,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Cbuttons(
                                    onPressed: () async {
                                      setState(() {
                                        offset = const Offset(0, 1);
                                      });
                                    },
                                    backgroundColor: kRed,
                                    padding: 15.0,
                                    borderRadius: 25,
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: Image.asset(
                                        "images/161-trending-flat-outline.gif",
                                        color: kWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

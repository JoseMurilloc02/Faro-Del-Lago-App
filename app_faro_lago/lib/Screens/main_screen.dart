import 'dart:async';

import 'package:app_faro_lago/myWidgets/custom_buttons.dart';
import 'package:app_faro_lago/myWidgets/menu_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants/constants.dart';
import '../myWidgets/animal_cards.dart';

//TODO: Pantalla estadísticas de la finca(cantidad vacas preñadas, Cantidad total de animales,) TODAVÍA NO
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<AnimalCard> listAnimals = [];
  String textType = "Código vaca";
  final _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> _animalSubscription;
  bool addButton = false;
  bool menuButton = true;
  bool firstStream = true;
  final animalCodeController = TextEditingController();
  final partosCodeController = TextEditingController();
  final momCodeController = TextEditingController();
  final sexCodeController = TextEditingController();
  final terneroController = TextEditingController();
  final embarazoController = TextEditingController();
  String dateCow = "";
  String doctorVisit = "";
  String partoDate = "";
  String dateTernero = "Sin ternero";
  String animalType = "Vaca";
  List<String> listOfAnimals = ["Toro", "Vaca", "Ternero"];
  late User? currentUser;
  void choiceAction(String choice) async {
    if (choice == "Cerrar sesión") {
      _auth.signOut();
      _animalSubscription.cancel();
      print("Disposed suscriptor");
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  Future<void> getCurrentUserUID() async {
    currentUser = _auth.currentUser;
  }

  String calculatePregnant(int estimatedDays, String doctorDate) {
    if (estimatedDays != 0) {
      List dateSplit = doctorDate.split("-");
      var date1 = DateTime(int.parse(dateSplit[0]), int.parse(dateSplit[1]),
          int.parse(dateSplit[2]));
      var now = DateTime.now();
      int difference = now.difference(date1).inDays + estimatedDays;
      return difference.toString();
    } else {
      return "0";
    }
  }

  void getAnimalData() async {
    String? userUID = currentUser?.uid;
    var snapshot = await ref.child(userUID!).child("RegistroAnimales").get();
    //print(snapshot.value);
    Map<dynamic, dynamic> animals = snapshot.value as Map<dynamic, dynamic>;
    animals.forEach((key, value) {
      if (value["tipoAnimal"] == "Vaca") {
        Map codeTernero = value["CantidadTerneros"];
        final animalCard = AnimalCard(
            color: kGrey,
            borderRadius: 15.0,
            description: [
              Text(
                "Código: $key",
                style: kSubTextWhite,
                textScaleFactor: .9,
                textAlign: TextAlign.start,
              ),
              Text(
                "Tipo de animal: ${value["tipoAnimal"]}",
                style: kSubTextWhite,
                textScaleFactor: .9,
                textAlign: TextAlign.start,
              ),
              Text(
                "Ternero: ${codeTernero.values.first}",
                style: kSubTextWhite,
                textScaleFactor: 1.0,
                textAlign: TextAlign.start,
              ),
              Text(
                "Días embarazo: ${calculatePregnant(int.parse(value["díasEmbarazo"].toString()), value["visitaMédico"].toString())}",
                style: kSubTextWhite,
                textScaleFactor: 1.0,
                textAlign: TextAlign.start,
              ),
            ],
            onPressed: () {
              Alert(
                title: "Descripción general",
                style: AlertStyle(
                  alertPadding: const EdgeInsets.all(10),
                  isCloseButton: false,
                  isButtonVisible: false,
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
                content: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Código animal: $key",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Tipo de animal: ${value["tipoAnimal"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Ternero: ${codeTernero.values.first} \n Fecha de nacimiento ternero: ${codeTernero.keys.first}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Fecha de ingreso: ${value["FechaIngreso"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Cantidad de partos: ${value["NumeroPartos"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Días de embarazo: ${calculatePregnant(int.parse(value["díasEmbarazo"].toString()), value["visitaMédico"].toString())}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Ultima fecha de Parto: ${value["fechaParto"].first}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Ultima visita médico: ${value["visitaMédico"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                      ],
                    ),
                  ),
                ),
                context: context,
              ).show();
            });
        setState(() {
          listAnimals.add(animalCard);
        });
      } else if (value["tipoAnimal"] == "Ternero") {
        final animalCard = AnimalCard(
            color: kGrey,
            borderRadius: 15.0,
            description: [
              Text(
                "Código: $key",
                style: kSubTextWhite,
                textScaleFactor: .9,
                textAlign: TextAlign.start,
              ),
              Text(
                "Tipo de animal: ${value["tipoAnimal"]}",
                style: kSubTextWhite,
                textScaleFactor: .9,
                textAlign: TextAlign.start,
              ),
              Text(
                "Sexo: ${value["sexoTernero"]}",
                style: kSubTextWhite,
                textScaleFactor: .9,
                textAlign: TextAlign.start,
              ),
              Text(
                "Código Madre: ${value["codigoMadre"]}",
                style: kSubTextWhite,
                textScaleFactor: .9,
                textAlign: TextAlign.start,
              ),
            ],
            onPressed: () {
              Alert(
                title: "Descripción general",
                style: AlertStyle(
                  alertPadding: const EdgeInsets.all(10),
                  isCloseButton: false,
                  isButtonVisible: false,
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
                content: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Código animal: $key",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Tipo de animal: ${value["tipoAnimal"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Nacimiento: ${value["FechaIngreso"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Código Madre: ${value["codigoMadre"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Sexo: ${value["sexoTernero"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Ultima visita médico: ${value["visitaMédico"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                      ],
                    ),
                  ),
                ),
                context: context,
              ).show();
            });
        setState(() {
          listAnimals.add(animalCard);
        });
      } else {
        final animalCard = AnimalCard(
            color: kGrey,
            borderRadius: 15.0,
            description: [
              Text(
                "Código: $key",
                style: kSubTextWhite,
                textScaleFactor: .9,
                textAlign: TextAlign.start,
              ),
              Text(
                "Tipo de animal: ${value["tipoAnimal"]}",
                style: kSubTextWhite,
                textScaleFactor: .9,
                textAlign: TextAlign.start,
              ),
            ],
            onPressed: () {
              Alert(
                title: "Descripción general",
                style: AlertStyle(
                  alertPadding: const EdgeInsets.all(10),
                  isCloseButton: false,
                  isButtonVisible: false,
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
                content: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Código animal: $key",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Tipo de animal: ${value["tipoAnimal"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Fecha de ingreso finca: ${value["FechaIngreso"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Ultima visita médico: ${value["visitaMédico"]}",
                          style: kSubTextWhite,
                          textScaleFactor: .9,
                        ),
                      ],
                    ),
                  ),
                ),
                context: context,
              ).show();
            });
        setState(() {
          listAnimals.add(animalCard);
        });
      }
    });
  }

  @override
  void initState() {
    getCurrentUserUID();
    getAnimalData();
    String? userUID = currentUser?.uid;
    //TODO: ELIMINATE THIS LISTENER AND MAKE THE CARD FROM THE UPLOAD BUTTON
    _animalSubscription =
        ref.child(userUID!).child("RegistroAnimales").onValue.listen((event) {
      var newListOfAnimals = event.snapshot.value;
      if (firstStream) {
        firstStream = false;
      } else {
        //print(newListOfAnimals);
        listAnimals.clear();
        Map<dynamic, dynamic> animals =
            newListOfAnimals as Map<dynamic, dynamic>;
        animals.forEach((key, value) {
          if (value["tipoAnimal"] == "Vaca") {
            //print(value["CantidadTerneros"]);
            Map codeTernero = value["CantidadTerneros"];
            final animalCard = AnimalCard(
                color: kGrey,
                borderRadius: 15.0,
                description: [
                  Text(
                    "Código: $key",
                    style: kSubTextWhite,
                    textScaleFactor: .9,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Tipo de animal: ${value["tipoAnimal"]}",
                    style: kSubTextWhite,
                    textScaleFactor: .9,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Ternero: ${codeTernero.values.first}",
                    style: kSubTextWhite,
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Días embarazo: ${calculatePregnant(int.parse(value["díasEmbarazo"].toString()), value["visitaMédico"].toString())}",
                    style: kSubTextWhite,
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.start,
                  ),
                ],
                onPressed: () {
                  Alert(
                    title: "Descripción general",
                    style: AlertStyle(
                      alertPadding: const EdgeInsets.all(10),
                      isCloseButton: false,
                      isButtonVisible: false,
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
                    content: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Código animal: $key",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Tipo de animal: ${value["tipoAnimal"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Ternero: ${codeTernero.values.first} Fecha de nacimiento: ${codeTernero.keys.first}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Fecha de ingreso: ${value["FechaIngreso"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Cantidad de partos: ${value["NumeroPartos"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Días de embarazo: ${calculatePregnant(int.parse(value["díasEmbarazo"].toString()), value["visitaMédico"].toString())}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Ultima fecha de Parto: ${value["fechaParto"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Ultima visita médico: ${value["visitaMédico"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                          ],
                        ),
                      ),
                    ),
                    context: context,
                  ).show();
                });
            setState(() {
              listAnimals.add(animalCard);
            });
          } else if (value["tipoAnimal"] == "Ternero") {
            final animalCard = AnimalCard(
                color: kGrey,
                borderRadius: 15.0,
                description: [
                  Text(
                    "Código: $key",
                    style: kSubTextWhite,
                    textScaleFactor: .9,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Tipo de animal: ${value["tipoAnimal"]}",
                    style: kSubTextWhite,
                    textScaleFactor: .9,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Sexo: ${value["sexoTernero"]}",
                    style: kSubTextWhite,
                    textScaleFactor: .9,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Código Madre: ${value["codigoMadre"]}",
                    style: kSubTextWhite,
                    textScaleFactor: .9,
                    textAlign: TextAlign.start,
                  ),
                ],
                onPressed: () {
                  Alert(
                    title: "Descripción general",
                    style: AlertStyle(
                      alertPadding: const EdgeInsets.all(10),
                      isCloseButton: false,
                      isButtonVisible: false,
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
                    content: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Código animal: $key",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Tipo de animal: ${value["tipoAnimal"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Nacimiento: ${value["FechaIngreso"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Código Madre: ${value["codigoMadre"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Sexo: ${value["sexoTernero"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Ultima visita médico: ${value["visitaMédico"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                          ],
                        ),
                      ),
                    ),
                    context: context,
                  ).show();
                });
            setState(() {
              listAnimals.add(animalCard);
            });
          } else {
            final animalCard = AnimalCard(
                color: kGrey,
                borderRadius: 15.0,
                description: [
                  Text(
                    "Código: $key",
                    style: kSubTextWhite,
                    textScaleFactor: .9,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Tipo de animal: ${value["tipoAnimal"]}",
                    style: kSubTextWhite,
                    textScaleFactor: .9,
                    textAlign: TextAlign.start,
                  ),
                ],
                onPressed: () {
                  Alert(
                    title: "Descripción general",
                    style: AlertStyle(
                      alertPadding: const EdgeInsets.all(10),
                      isCloseButton: false,
                      isButtonVisible: false,
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
                    content: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Código animal: $key",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Tipo de animal: ${value["tipoAnimal"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Fecha de ingreso finca: ${value["FechaIngreso"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Ultima visita médico: ${value["visitaMédico"]}",
                              style: kSubTextWhite,
                              textScaleFactor: .9,
                            ),
                          ],
                        ),
                      ),
                    ),
                    context: context,
                  ).show();
                });
            setState(() {
              listAnimals.add(animalCard);
            });
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animalSubscription.cancel();
    print("Disposed suscriptor");
    super.dispose();
  }

//TODO: ADD TOTAL OF ANIMALS
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        _animalSubscription.cancel();
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: kGrey,
        appBar: AppBar(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          //TODO: CHANGE THIS LINE TITLE "Filtrado: $textType"
          title: const Text(
            "Administración Ganado",
            style: kSubTextWhite,
            textScaleFactor: 1.1,
          ),
          actions: [
            PopupMenuButton(
              color: kGrey,
              iconSize: 15,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 15,
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return {"Cerrar sesión"}.map(
                  (String choice) {
                    return PopupMenuItem<String>(
                      textStyle: kSubTextWhite,
                      value: choice,
                      child: Text(
                        choice,
                      ),
                    );
                  },
                ).toList();
              },
            )
          ],
          backgroundColor: kRed,
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: listAnimals,
                  ),
                ),
              ),
              Visibility(
                visible: addButton,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: deviceWidth,
                    height: deviceHeight,
                    decoration: BoxDecoration(
                      border: Border.all(color: kWhite, width: 4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Material(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: kGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: deviceHeight,
                          child: ListView(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Material(
                                    shape: const CircleBorder(),
                                    color: kRed,
                                    elevation: 5.0,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(4.0),
                                      onPressed: () {
                                        setState(() {
                                          addButton = !addButton;
                                          menuButton = !menuButton;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 25,
                                        color: kWhite,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: deviceWidth < deviceHeight
                                        ? deviceWidth * .03
                                        : deviceWidth * .2,
                                  ),
                                  const Text(
                                    "Añadir elemento",
                                    style: kMainText,
                                    textScaleFactor: 1.5,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Tipo de animal",
                                    style: kSubTextWhite,
                                    //textScaleFactor: .9,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Material(
                                    borderRadius: BorderRadius.circular(15),
                                    elevation: 15,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kRed,
                                        borderRadius: BorderRadius.circular(15),
                                        border:
                                            Border.all(color: kWhite, width: 2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: DropdownButton<String>(
                                          underline: Container(),
                                          elevation: 25,
                                          alignment:
                                              AlignmentDirectional.center,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          dropdownColor: kRed,
                                          value: animalType,
                                          iconSize: 25,
                                          iconEnabledColor: kWhite,
                                          style: kSubTextWhite,
                                          onChanged: (String? newValue) async {
                                            setState(() {
                                              animalType = newValue!;
                                            });
                                          },
                                          items: listOfAnimals
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2.5, 5, 2.5, 10),
                                                child: Text(
                                                  value,
                                                  textAlign: TextAlign.center,
                                                  style: kSubTextWhite,
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(15),
                                color: kRed,
                                elevation: 15,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: animalCodeController,
                                  style: kSubTextWhite,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    hintText: "Ingrese código animal",
                                    hintStyle: kSubTextWhite,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: kWhite, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: kWhite, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {},
                                  // decoration:
                                  //     kTextFieldDecoration.copyWith(hintText: "Enter your email"),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Visibility(
                                visible: animalType == "Vaca" ? true : false,
                                child: Material(
                                  borderRadius: BorderRadius.circular(15),
                                  color: kRed,
                                  elevation: 20,
                                  child: TextField(
                                    controller: partosCodeController,
                                    style: kSubTextWhite,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      hintText: "Ingrese # partos",
                                      hintStyle: kSubTextWhite,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kWhite, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kWhite, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {},
                                    // decoration:
                                    //     kTextFieldDecoration.copyWith(hintText: "Enter your email"),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: animalType == "Vaca" ? true : false,
                                child: const SizedBox(
                                  height: 20,
                                ),
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(15),
                                color: kRed,
                                elevation: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: kWhite, width: 2),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          theme: const DatePickerTheme(
                                              headerColor: kRed,
                                              backgroundColor: kGrey,
                                              doneStyle: kSubTextWhite,
                                              cancelStyle: kSubTextWhite,
                                              itemStyle: kSubTextWhite),
                                          showTitleActions: true,
                                          minTime: DateTime(1920, 1, 1),
                                          maxTime: DateTime.now(),
                                          onChanged: (date) {
                                        //print('change $date');
                                      }, onConfirm: (date) async {
                                        //print('confirm $date');
                                        setState(() {
                                          dateCow = date.year.toString() +
                                              "-" +
                                              date.month.toString() +
                                              "-" +
                                              date.day.toString();
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.es);
                                    },
                                    child: animalType != "Ternero"
                                        ? Text(
                                            dateCow != ""
                                                ? dateCow
                                                : "Fecha de ingreso a la Finca",
                                            style: kSubTextWhite,
                                            //textScaleFactor: .9,
                                          )
                                        : Text(
                                            dateCow != ""
                                                ? dateCow
                                                : "Fecha de nacimiento",
                                            style: kSubTextWhite,
                                            //textScaleFactor: .9,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Visibility(
                                visible: animalType == "Vaca" ? true : false,
                                child: Material(
                                  borderRadius: BorderRadius.circular(15),
                                  color: kRed,
                                  elevation: 15,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: terneroController,
                                    style: kSubTextWhite,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      hintText: "Ingrese código ternero",
                                      hintStyle: kSubTextWhite,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kWhite, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kWhite, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {},
                                    // decoration:
                                    //     kTextFieldDecoration.copyWith(hintText: "Enter your email"),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: animalType == "Vaca" ? true : false,
                                child: const SizedBox(
                                  height: 20,
                                ),
                              ),
                              Visibility(
                                visible: animalType == "Vaca" ? true : false,
                                child: Material(
                                  borderRadius: BorderRadius.circular(15),
                                  color: kRed,
                                  elevation: 15,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border:
                                          Border.all(color: kWhite, width: 2),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            theme: const DatePickerTheme(
                                                headerColor: kRed,
                                                backgroundColor: kGrey,
                                                doneStyle: kSubTextWhite,
                                                cancelStyle: kSubTextWhite,
                                                itemStyle: kSubTextWhite),
                                            showTitleActions: true,
                                            minTime: DateTime(1920, 1, 1),
                                            maxTime: DateTime.now(),
                                            onChanged: (date) {
                                          //print('change $date');
                                        }, onConfirm: (date) async {
                                          //print('confirm $date');
                                          setState(() {
                                            dateTernero = date.year.toString() +
                                                "-" +
                                                date.month.toString() +
                                                "-" +
                                                date.day.toString();
                                          });
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.es);
                                      },
                                      child: Text(
                                        dateTernero != "Sin ternero"
                                            ? dateTernero
                                            : "Fecha nacimiento ternero",
                                        style: kSubTextWhite,
                                        //textScaleFactor: .9,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: animalType == "Vaca" ? true : false,
                                child: const SizedBox(
                                  height: 20,
                                ),
                              ),
                              Visibility(
                                visible: animalType == "Vaca" ? true : false,
                                child: Material(
                                  borderRadius: BorderRadius.circular(15),
                                  color: kRed,
                                  elevation: 15,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: embarazoController,
                                    style: kSubTextWhite,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      hintText: "Ingrese días de embarazo",
                                      hintStyle: kSubTextWhite,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kWhite, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kWhite, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {},
                                    // decoration:
                                    //     kTextFieldDecoration.copyWith(hintText: "Enter your email"),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: animalType == "Vaca" ? true : false,
                                child: const SizedBox(
                                  height: 20,
                                ),
                              ),
                              Visibility(
                                visible: animalType == "Ternero" ? true : false,
                                child: Material(
                                  borderRadius: BorderRadius.circular(15),
                                  color: kRed,
                                  elevation: 20,
                                  child: TextField(
                                    controller: momCodeController,
                                    style: kSubTextWhite,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      hintText: "Ingrese código de la madre",
                                      hintStyle: kSubTextWhite,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kWhite, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kWhite, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {},
                                    // decoration:
                                    //     kTextFieldDecoration.copyWith(hintText: "Enter your email"),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: animalType == "Ternero" ? true : false,
                                child: const SizedBox(
                                  height: 20,
                                ),
                              ),
                              Visibility(
                                visible: animalType == "Ternero" ? true : false,
                                child: Material(
                                  borderRadius: BorderRadius.circular(15),
                                  color: kRed,
                                  elevation: 20,
                                  child: TextField(
                                    controller: sexCodeController,
                                    style: kSubTextWhite,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                      hintText: "Sexo ternero",
                                      hintStyle: kSubTextWhite,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kWhite, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kWhite, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {},
                                    // decoration:
                                    //     kTextFieldDecoration.copyWith(hintText: "Enter your email"),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: animalType == "Ternero" ? true : false,
                                child: const SizedBox(
                                  height: 20,
                                ),
                              ),
                              Material(
                                borderRadius: BorderRadius.circular(15),
                                color: kRed,
                                elevation: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: kWhite, width: 2),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          theme: const DatePickerTheme(
                                              headerColor: kRed,
                                              backgroundColor: kGrey,
                                              doneStyle: kSubTextWhite,
                                              cancelStyle: kSubTextWhite,
                                              itemStyle: kSubTextWhite),
                                          showTitleActions: true,
                                          minTime: DateTime(1920, 1, 1),
                                          maxTime: DateTime.now(),
                                          onChanged: (date) {
                                        //print('change $date');
                                      }, onConfirm: (date) async {
                                        //print('confirm $date');
                                        setState(() {
                                          doctorVisit = date.year.toString() +
                                              "-" +
                                              date.month.toString() +
                                              "-" +
                                              date.day.toString();
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.es);
                                    },
                                    child: Text(
                                      doctorVisit != ""
                                          ? doctorVisit
                                          : "Fecha de visita médico",
                                      style: kSubTextWhite,
                                      //textScaleFactor: .9,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Cbuttons(
                                      onPressed: () async {
                                        String? userUID = currentUser?.uid;
                                        if (animalCodeController.value.text ==
                                            "") {
                                          Alert(
                                            title: "Espacios vacíos",
                                            style: AlertStyle(
                                              isCloseButton: false,
                                              overlayColor:
                                                  kGrey.withOpacity(0.5),
                                              backgroundColor: kGrey,
                                              alertBorder:
                                                  const ContinuousRectangleBorder(
                                                side: BorderSide(
                                                    color: kRed, width: 3),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  topLeft: Radius.circular(15),
                                                ),
                                              ),
                                              titleStyle: kSubTextWhite,
                                              descStyle: kSubTextWhite,
                                            ),
                                            desc:
                                                "Por favor ingrese código del animal",
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
                                        } else if (dateCow == "") {
                                          Alert(
                                            title: "Espacios vacíos",
                                            style: AlertStyle(
                                              isCloseButton: false,
                                              overlayColor:
                                                  kGrey.withOpacity(0.5),
                                              backgroundColor: kGrey,
                                              alertBorder:
                                                  const ContinuousRectangleBorder(
                                                side: BorderSide(
                                                    color: kRed, width: 3),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                  topRight: Radius.circular(15),
                                                  topLeft: Radius.circular(15),
                                                ),
                                              ),
                                              titleStyle: kSubTextWhite,
                                              descStyle: kSubTextWhite,
                                            ),
                                            desc:
                                                "Por favor ingrese fecha de nacimiento o llegada a la finca",
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
                                        } else {
                                          if (animalType == "Vaca") {
                                            ref
                                                .child(userUID!)
                                                .child("RegistroAnimales")
                                                .child(animalCodeController
                                                    .value.text)
                                                .set({
                                              "tipoAnimal": animalType,
                                              "NumeroPartos":
                                                  partosCodeController
                                                              .value.text ==
                                                          ""
                                                      ? "Sin partos"
                                                      : partosCodeController
                                                          .value.text,
                                              "FechaIngreso": dateCow,
                                              //TODO: añadir y validar más de un ternero TODAVÍA NO
                                              "CantidadTerneros": {
                                                dateTernero: terneroController
                                                            .value.text ==
                                                        ""
                                                    ? "Sin Ternero"
                                                    : terneroController
                                                        .value.text
                                              },
                                              "fechaParto": [dateTernero],
                                              "visitaMédico": doctorVisit == ""
                                                  ? "Sin visitas"
                                                  : doctorVisit,
                                              "díasEmbarazo": embarazoController
                                                          .value.text ==
                                                      ""
                                                  ? 0
                                                  : embarazoController
                                                      .value.text,
                                            });
                                          } else if (animalType == "Ternero") {
                                            if (sexCodeController.value.text ==
                                                "") {
                                              Alert(
                                                title: "Espacios vacíos",
                                                style: AlertStyle(
                                                  isCloseButton: false,
                                                  overlayColor:
                                                      kGrey.withOpacity(0.5),
                                                  backgroundColor: kGrey,
                                                  alertBorder:
                                                      const ContinuousRectangleBorder(
                                                    side: BorderSide(
                                                        color: kRed, width: 3),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15),
                                                      topLeft:
                                                          Radius.circular(15),
                                                    ),
                                                  ),
                                                  titleStyle: kSubTextWhite,
                                                  descStyle: kSubTextWhite,
                                                ),
                                                desc:
                                                    "Por favor ingrese sexo del ternero",
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
                                            } else if (momCodeController
                                                    .value.text ==
                                                "") {
                                              Alert(
                                                title: "Espacios vacíos",
                                                style: AlertStyle(
                                                  isCloseButton: false,
                                                  overlayColor:
                                                      kGrey.withOpacity(0.5),
                                                  backgroundColor: kGrey,
                                                  alertBorder:
                                                      const ContinuousRectangleBorder(
                                                    side: BorderSide(
                                                        color: kRed, width: 3),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(15),
                                                      bottomRight:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15),
                                                      topLeft:
                                                          Radius.circular(15),
                                                    ),
                                                  ),
                                                  titleStyle: kSubTextWhite,
                                                  descStyle: kSubTextWhite,
                                                ),
                                                desc:
                                                    "Por favor ingrese código de la madre",
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
                                            } else {
                                              ref
                                                  .child(userUID!)
                                                  .child("RegistroAnimales")
                                                  .child(animalCodeController
                                                      .value.text)
                                                  .set({
                                                "tipoAnimal": animalType,
                                                "FechaIngreso": dateCow,
                                                "visitaMédico":
                                                    doctorVisit == ""
                                                        ? "Sin visitas"
                                                        : doctorVisit,
                                                "codigoMadre": momCodeController
                                                    .value.text,
                                                "sexoTernero": sexCodeController
                                                    .value.text,
                                              });
                                            }
                                          } else {
                                            ref
                                                .child(userUID!)
                                                .child("RegistroAnimales")
                                                .child(animalCodeController
                                                    .value.text)
                                                .set({
                                              "tipoAnimal": animalType,
                                              "FechaIngreso": dateCow,
                                              "visitaMédico": doctorVisit == ""
                                                  ? "Sin visitas"
                                                  : doctorVisit,
                                            });
                                          }
                                          setState(() {
                                            addButton = !addButton;
                                            menuButton = !menuButton;
                                            embarazoController.clear();
                                            animalCodeController.clear();
                                            terneroController.clear();
                                            partosCodeController.clear();
                                            momCodeController.clear();
                                            sexCodeController.clear();
                                            dateTernero = "";
                                            dateCow = "";
                                            doctorVisit = "";
                                          });
                                        }
                                      },
                                      backgroundColor: Colors.green,
                                      child: Image.asset(
                                        "images/49-upload-file-outline.gif",
                                        color: kWhite,
                                        height: 30,
                                      ),
                                      padding: 15,
                                      borderRadius: 15),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: menuButton,
          child: MenuButton(
              deviceHeight: deviceHeight,
              mainButtonColor: kRed,
              firstButtonColor: kRed,
              secondButtonColor: kRed,
              mainButtonChild: const Icon(
                Icons.menu,
                size: 30,
                color: kWhite,
              ),
              firstButtonChild: const Icon(
                Icons.add,
                size: 30,
                color: kWhite,
              ),
              secondButtonChild: Image.asset(
                "images/42-search-outline.gif",
                color: kWhite,
                height: 30,
              ),
              borderRadius: 15,
              onPressFist: () {
                setState(() {
                  addButton = !addButton;
                  menuButton = !menuButton;
                });
              },
              onPressSecond: () {}),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
import 'package:app_faro_lago/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../myWidgets/custom_buttons.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;
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
  List allTerneros = [];
  late User? currentUser;
  String oldCode = "";
  bool firstTime = true;
  Future<void> getCurrentUserUID() async {
    currentUser = _auth.currentUser;
  }

  @override
  void initState() {
    getCurrentUserUID();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime) {
      firstTime = false;
      Map<String, dynamic>? animalData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      print(animalData);
      setState(() {
        animalData.forEach((key, value) {
          if (value != null) {
            if (key == "code") {
              oldCode = value.toString();
              animalCodeController.text = value.toString();
            } else if (key == "partos") {
              partosCodeController.text = value;
            } else if (key == "entrance") {
              dateCow = value;
            } else if (key == "calf") {
              terneroController.text = value;
            } else if (key == "calfBornDate") {
              dateTernero = value;
            } else if (key == "pregnancyDays") {
              embarazoController.text = value;
            } else if (key == "medicVisit") {
              doctorVisit = value;
            } else if (key == "motherCode") {
              momCodeController.text = value;
            } else if (key == "calfSex") {
              sexCodeController.text = value;
            }
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, "MainScreen");
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
          backgroundColor: kRed,
          title: const Text(
            "Modificar datos",
            style: kSubTextWhite,
            textScaleFactor: 1.3,
          ),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                  top: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Tipo de animal",
                      style: kSubTextWhite,
                      textScaleFactor: 1.1,
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
                          border: Border.all(color: kWhite, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: DropdownButton<String>(
                            underline: Container(),
                            elevation: 25,
                            alignment: AlignmentDirectional.center,
                            borderRadius: BorderRadius.circular(15),
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
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                alignment: AlignmentDirectional.center,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  color: kRed,
                  elevation: 15,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: animalCodeController,
                    style: kSubTextWhite,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      hintText: "Ingrese código animal",
                      hintStyle: kSubTextWhite,
                      alignLabelWithHint: true,
                      label: Container(
                        decoration: BoxDecoration(
                          color: kRed,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                          "Código animal",
                          style: kSubTextWhite,
                          textScaleFactor: 1.1,
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kWhite, width: 2.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kWhite, width: 2.0),
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: kRed,
                    elevation: 20,
                    child: TextField(
                      controller: partosCodeController,
                      style: kSubTextWhite,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        hintText: "Ingrese # partos",
                        hintStyle: kSubTextWhite,
                        label: Container(
                          decoration: BoxDecoration(
                            color: kRed,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "Cantidad de partos",
                            style: kSubTextWhite,
                            textScaleFactor: 1.1,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.0),
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Material(
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
                            maxTime: DateTime.now(), onChanged: (date) {
                          //debugPrint('change $date');
                        }, onConfirm: (date) async {
                          //debugPrint('confirm $date');
                          setState(() {
                            dateCow = date.year.toString() +
                                "-" +
                                date.month.toString() +
                                "-" +
                                date.day.toString();
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.es);
                      },
                      child: animalType != "Ternero"
                          ? Text(
                              dateCow != ""
                                  ? "Fecha ingreso: $dateCow"
                                  : "Fecha de ingreso a la Finca",
                              style: kSubTextWhite,
                              textScaleFactor: 1.1,
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              dateCow != ""
                                  ? "Fecha nacimiento: $dateCow"
                                  : "Fecha de nacimiento",
                              style: kSubTextWhite,
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.1,
                            ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: animalType == "Vaca" ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: kRed,
                    elevation: 15,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: terneroController,
                      style: kSubTextWhite,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        hintText: "Ingrese código ternero",
                        hintStyle: kSubTextWhite,
                        label: Container(
                          decoration: BoxDecoration(
                            color: kRed,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "Código ternero",
                            style: kSubTextWhite,
                            textScaleFactor: 1.1,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.0),
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
              ),
              Visibility(
                visible: animalType == "Vaca" ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Material(
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
                              maxTime: DateTime.now(), onChanged: (date) {
                            //debugPrint('change $date');
                          }, onConfirm: (date) async {
                            //debugPrint('confirm $date');
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
                              ? "Nacimiento ternero: $dateTernero"
                              : "Fecha nacimiento ternero",
                          style: kSubTextWhite,
                          textScaleFactor: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: animalType == "Vaca" ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: kRed,
                    elevation: 15,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: embarazoController,
                      style: kSubTextWhite,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        hintText: "Ingrese días de embarazo",
                        hintStyle: kSubTextWhite,
                        label: Container(
                          decoration: BoxDecoration(
                            color: kRed,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "Días embarazo",
                            style: kSubTextWhite,
                            textScaleFactor: 1.1,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.0),
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
              ),
              Visibility(
                visible: animalType == "Ternero" ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
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
                        hintText: "Ingrese código madre",
                        hintStyle: kSubTextWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.0),
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
              ),
              Visibility(
                visible: animalType == "Ternero" ? true : false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
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
                          borderSide: BorderSide(color: kWhite, width: 2.0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kWhite, width: 2.0),
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Material(
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
                            maxTime: DateTime.now(), onChanged: (date) {
                          //debugPrint('change $date');
                        }, onConfirm: (date) async {
                          //debugPrint('confirm $date');
                          setState(() {
                            doctorVisit = date.year.toString() +
                                "-" +
                                date.month.toString() +
                                "-" +
                                date.day.toString();
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.es);
                      },
                      child: Text(
                        doctorVisit != ""
                            ? "Visita médico: $doctorVisit"
                            : "Fecha de visita médico",
                        style: kSubTextWhite,
                        textScaleFactor: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Cbuttons(
                      onPressed: () async {
                        String? userUID = currentUser?.uid;
                        if (animalCodeController.value.text == "") {
                          Alert(
                            title: "Espacios vacíos",
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
                            desc: "Por favor ingrese código del animal",
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
                        } else if (dateCow == "") {
                          Alert(
                            title: "Espacios vacíos",
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
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                                color: kRed,
                              )
                            ],
                          ).show();
                        } else {
                          if (oldCode != animalCodeController.value.text) {
                            ref
                                .child(userUID!)
                                .child("RegistroAnimales")
                                .child(oldCode)
                                .remove();
                          }
                          if (animalType == "Vaca") {
                            ref
                                .child(userUID!)
                                .child("RegistroAnimales")
                                .child(animalCodeController.value.text)
                                .set({
                              "code":
                                  int.parse(animalCodeController.value.text),
                              "tipoAnimal": animalType,
                              "NumeroPartos":
                                  partosCodeController.value.text == ""
                                      ? "Sin partos"
                                      : partosCodeController.value.text,
                              "FechaIngreso": dateCow,
                              //TODO: añadir y validar más de un ternero TODAVÍA NO
                              "CantidadTerneros": {
                                dateTernero: terneroController.value.text == ""
                                    ? "Sin Ternero"
                                    : terneroController.value.text
                              },
                              "fechaParto": [dateTernero],
                              "visitaMédico": doctorVisit == ""
                                  ? "Sin visitas"
                                  : doctorVisit,
                              "díasEmbarazo":
                                  embarazoController.value.text == ""
                                      ? 0
                                      : embarazoController.value.text,
                            });
                          } else if (animalType == "Ternero") {
                            if (sexCodeController.value.text == "") {
                              Alert(
                                title: "Espacios vacíos",
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
                                desc: "Por favor ingrese sexo del ternero",
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
                            } else if (momCodeController.value.text == "") {
                              Alert(
                                title: "Espacios vacíos",
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
                                desc: "Por favor ingrese código de la madre",
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
                            } else {
                              ref
                                  .child(userUID!)
                                  .child("RegistroAnimales")
                                  .child(animalCodeController.value.text)
                                  .set({
                                "code":
                                    int.parse(animalCodeController.value.text),
                                "tipoAnimal": animalType,
                                "FechaIngreso": dateCow,
                                "visitaMédico": doctorVisit == ""
                                    ? "Sin visitas"
                                    : doctorVisit,
                                "codigoMadre": momCodeController.value.text,
                                "sexoTernero": sexCodeController.value.text,
                              });
                            }
                          } else {
                            ref
                                .child(userUID!)
                                .child("RegistroAnimales")
                                .child(animalCodeController.value.text)
                                .set({
                              "code":
                                  int.parse(animalCodeController.value.text),
                              "tipoAnimal": animalType,
                              "FechaIngreso": dateCow,
                              "visitaMédico": doctorVisit == ""
                                  ? "Sin visitas"
                                  : doctorVisit,
                            });
                          }
                          setState(() {
                            embarazoController.clear();
                            animalCodeController.clear();
                            terneroController.clear();
                            partosCodeController.clear();
                            momCodeController.clear();
                            sexCodeController.clear();
                            dateTernero = "Sin ternero";
                            dateCow = "";
                            doctorVisit = "";
                            Navigator.pushNamed(context, "MainScreen");
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
    );
  }
}

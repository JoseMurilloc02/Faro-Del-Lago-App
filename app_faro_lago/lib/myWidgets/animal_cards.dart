import 'package:app_faro_lago/constants/constants.dart';
import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final List<Widget> description;
  const AnimalCard(
      {Key? key,
      required this.color,
      required this.borderRadius,
      required this.onPressed,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 20,
        color: kGrey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: description,
              ),
              const SizedBox(
                width: 25.0,
              ),
              Flexible(
                child: TextButton(
                  onPressed: onPressed,
                  child: const Text(
                    "Más detalles",
                    style: kSubTextWhite,
                    textScaleFactor: .9,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

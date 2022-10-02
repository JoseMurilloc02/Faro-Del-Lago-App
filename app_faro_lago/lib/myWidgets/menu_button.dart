import 'package:app_faro_lago/myWidgets/custom_buttons.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  final double deviceHeight;
  final Color mainButtonColor;
  final Widget mainButtonChild;
  final Color firstButtonColor;
  final Widget firstButtonChild;
  final Color secondButtonColor;
  final Widget secondButtonChild;
  final double borderRadius;
  final VoidCallback onPressFist;
  final VoidCallback onPressSecond;

  const MenuButton(
      {Key? key,
      required this.deviceHeight,
      required this.mainButtonColor,
      required this.firstButtonColor,
      required this.secondButtonColor,
      required this.mainButtonChild,
      required this.firstButtonChild,
      required this.secondButtonChild,
      required this.borderRadius,
      required this.onPressFist,
      required this.onPressSecond})
      : super(key: key);

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController aniController;
  late Animation animation;
  bool switcher = false;
  @override
  void initState() {
    aniController = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: this);
    animation = animation =
        CurvedAnimation(parent: aniController, curve: Curves.easeInOut);
    aniController.forward();
    aniController.addListener(() {
      setState(() {
        animation.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    aniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: switcher,
          child: AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: 1.0 - animation.value,
                child: Transform.translate(
                  offset:
                      Offset(0, animation.value * widget.deviceHeight * 0.04),
                  child: child,
                ),
              );
            },
            child: Cbuttons(
                onPressed: widget.onPressSecond,
                backgroundColor: widget.secondButtonColor,
                borderRadius: widget.borderRadius,
                padding: 15.0,
                child: widget.secondButtonChild),
          ),
        ),
        SizedBox(
          height: widget.deviceHeight * .02,
        ),
        Visibility(
          visible: switcher,
          child: AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: 1.0 - animation.value,
                child: Transform.translate(
                  offset:
                      Offset(0, animation.value * widget.deviceHeight * 0.02),
                  child: child,
                ),
              );
            },
            child: Cbuttons(
                onPressed: widget.onPressFist,
                backgroundColor: widget.firstButtonColor,
                borderRadius: widget.borderRadius,
                padding: 15.0,
                child: widget.firstButtonChild),
          ),
        ),
        SizedBox(
          height: widget.deviceHeight * .02,
        ),
        Cbuttons(
          onPressed: () async {
            if (switcher) {
              await aniController.forward();
              setState(() {
                switcher = false;
              });
            } else {
              setState(() {
                switcher = true;
              });
              await aniController.reverse();
            }
          },
          backgroundColor: widget.mainButtonColor,
          borderRadius: widget.borderRadius,
          padding: 15.0,
          child: widget.mainButtonChild,
        ),
      ],
    );
  }
}

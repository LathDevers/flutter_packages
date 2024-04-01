import 'package:flutter/material.dart';

Color color1 = const Color(0xffeeeff5);
Color color2 = const Color(0xff2a2b2f);
Color color3 = Colors.white;
Color color4 = Colors.black;
Color color5 = const Color(0xff151618);
Color color6 = const Color(0xfffafbfd);
Color color7 = const Color(0xffdadee6);
Color color8 = const Color(0xff222325);
Color color9 = const Color(0xfff9fafe);
Color color10 = const Color(0xff303135);

BoxShadow boxShadow1 = const BoxShadow(
  color: Color(0xffdadee6), // color7
  offset: Offset(0, 10),
  blurRadius: 10,
  spreadRadius: 0,
);
BoxShadow boxShadow2 = const BoxShadow(
  color: Color(0xff222325), // color8
  offset: Offset(0, 10),
  blurRadius: 10,
  spreadRadius: 0,
);
BoxShadow boxShadow3 = const BoxShadow(
  color: Color(0xfff9fafe), // color9
  offset: Offset(0, -10),
  blurRadius: 10,
  spreadRadius: 0,
);
BoxShadow boxShadow4 = const BoxShadow(
  color: Color(0xff303135), // color10
  offset: Offset(0, -10),
  blurRadius: 10,
  spreadRadius: 0,
);
BoxShadow boxShadow5 = const BoxShadow(
  color: Color(0xffdadee6), // color7
  offset: Offset(0, -10),
  blurRadius: 10,
  spreadRadius: 0,
);
BoxShadow boxShadow6 = const BoxShadow(
  color: Color(0xff222325), // color8
  offset: Offset(0, -10),
  blurRadius: 10,
  spreadRadius: 0,
);
BoxShadow boxShadow7 = const BoxShadow(
  color: Color(0xfff9fafe), // color9
  offset: Offset(0, 10),
  blurRadius: 10,
  spreadRadius: 0,
);
BoxShadow boxShadow8 = const BoxShadow(
  color: Color(0xff303135), // color10
  offset: Offset(0, 10),
  blurRadius: 10,
  spreadRadius: 0,
);

class OTPStyleButton extends StatefulWidget {
  const OTPStyleButton({super.key, this.onTap, this.borderRadius, required this.child, this.fillColor});

  final void Function()? onTap;
  final BorderRadiusGeometry? borderRadius;
  final Widget child;
  final Color? fillColor;

  @override
  State<OTPStyleButton> createState() => OTPStyleButtonState();
}

class OTPStyleButtonState extends State<OTPStyleButton> {
  String value = '';
  bool isPushed = false;

  @override
  Widget build(BuildContext context) {
    final bool light = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (TapDownDetails d) => setState(() => isPushed = true),
      onTapUp: (TapUpDetails d) => setState(() => isPushed = false),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: widget.fillColor ?? (light ? color1 : color2),
          borderRadius: widget.borderRadius,
          boxShadow: isPushed ? selectedShadow(light) : shadow(light),
        ),
        duration: const Duration(milliseconds: 10),
        margin: const EdgeInsets.all(8),
        child: widget.child,
      ),
    );
  }

  List<BoxShadow> shadow(bool light) {
    return [
      BoxShadow(
        color: light ? color7 : color8,
        offset: const Offset(0, 10),
        blurRadius: 10,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: light ? color9 : color10,
        offset: const Offset(0, -10),
        blurRadius: 10,
        spreadRadius: 0,
      )
    ];
  }

  List<BoxShadow> selectedShadow(bool light) {
    return [
      BoxShadow(
        color: light ? color7 : color8,
        offset: const Offset(0, -10),
        blurRadius: 10,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: light ? color9 : color10,
        offset: const Offset(0, 10),
        blurRadius: 10,
        spreadRadius: 0,
      )
    ];
  }
}

import 'package:otp_button/numberpad.dart';
import 'package:flutter/material.dart';

class NumberPadScaffold extends StatelessWidget {
  const NumberPadScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final bool light = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: light ? color1 : color2,
      body: const SafeArea(child: NumberPad()),
    );
  }
}

class NumberPad extends StatefulWidget {
  const NumberPad({super.key});

  @override
  State<NumberPad> createState() => NumberPadState();
}

class NumberPadState extends State<NumberPad> {
  String value = '';

  @override
  Widget build(BuildContext context) {
    final bool light = Theme.of(context).brightness == Brightness.light;
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Center(
            child: Container(
              width: 200,
              height: 30,
              decoration: BoxDecoration(color: color3, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(color: color4),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: otpPINInput(light),
        ),
      ],
    );
  }

  Widget otpPINInput(bool light) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              wrapper(1, light),
              wrapper(2, light),
              wrapper(3, light),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              wrapper(4, light),
              wrapper(5, light),
              wrapper(6, light),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              wrapper(7, light),
              wrapper(8, light),
              wrapper(9, light),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              wrapper(0, light),
            ],
          ),
        ],
      ),
    );
  }

  Widget wrapper(int number, bool light) {
    const double size = 50;
    return OTPStyleButton(
      borderRadius: BorderRadius.circular(size),
      onTap: () => setState(() => value = '$value$number'),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            '$number',
            style: TextStyle(
              color: light ? color5 : color6,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

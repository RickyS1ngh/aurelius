import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  const CustomRadioButton(
      this.text, this.parentIndex, this.index, this.setIndex,
      {super.key});
  final String text;
  final int parentIndex;
  final int index;
  final void Function(int) setIndex;

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  int? indexOfButton;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .30,
      child: OutlinedButton(
          style: ButtonStyle(
              backgroundColor: widget.parentIndex == indexOfButton
                  ? const WidgetStatePropertyAll(
                      Color(0xFFa68a64),
                    )
                  : null),
          onPressed: () {
            setState(() {
              indexOfButton = widget.index;
            });

            widget.setIndex(widget.index);
          },
          child: Text(
            widget.text,
            style: const TextStyle(
                fontFamily: 'Cinzel',
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}

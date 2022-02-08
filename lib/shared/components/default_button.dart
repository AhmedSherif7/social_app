import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.width = double.infinity,
    this.background = Colors.blue,
    this.isUpperCase = false,
    this.radius = 3.0,
    required this.function,
    required this.text,
  }) : super(key: key);

  final double width;
  final Color background;
  final bool isUpperCase;
  final double radius;
  final Function() function;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );
  }
}

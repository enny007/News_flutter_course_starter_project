import 'package:flutter/material.dart';

class TabsWidget extends StatelessWidget {
  const TabsWidget(
      {super.key,
      required this.text,
      required this.color,
      required this.fct,
      required this.fontSize});
  final String text;
  final Color color;
  final Function()? fct;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fct,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

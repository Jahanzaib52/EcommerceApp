import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final double widthRatio;
  final String label;
  final Function()? onPressed;
  const YellowButton({
    Key? key,required this.widthRatio,required this.label,required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width * widthRatio,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.yellow,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(label,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),),
      ),
    );
  }
}

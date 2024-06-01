import 'package:flutter/material.dart';

class StaticsModel extends StatelessWidget {
  final String label;
  final dynamic labelValue;
  final int digitAfterDecimal;
  const StaticsModel(
      {super.key,
      required this.labelValue,
      required this.label,
      required this.digitAfterDecimal});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: Center(
            child: ValueAnimation(
              count: labelValue,
              digitAfterDecimal: digitAfterDecimal,
            ),
            // child: Text(
            //   labelValue,
            //   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            // ),
          ),
        ),
        Container(
          height: 75,
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
          ),
          child: Center(
              child: Text(label.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }
}

class ValueAnimation extends StatefulWidget {
  final dynamic count;
  final int digitAfterDecimal;
  const ValueAnimation(
      {super.key, required this.count, required this.digitAfterDecimal});

  @override
  State<ValueAnimation> createState() => _ValueAnimationState();
}

class _ValueAnimationState extends State<ValueAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation = controller;
    setState(() {
      animation =
          Tween(begin: animation.value, end: widget.count).animate(controller);
    });
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Text(
            animation.value.toStringAsFixed(widget.digitAfterDecimal),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          );
        });
  }
}

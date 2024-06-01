import 'package:flutter/material.dart';

import '../minor_screen/subcateg_products.dart';

class SliderBar extends StatelessWidget {
  final String mainCategName;
  const SliderBar({
    Key? key,required this.mainCategName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(0.25),
            borderRadius: BorderRadius.circular(50),
          ),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                mainCategName=="Beauty"? const Text(""): const Text(
                  "<<",
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10
                  ),
                ),
                Text(
                  mainCategName,
                  style: const TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10
                  ),
                ),
                mainCategName=="Men"? const Text(""):const Text(
                  ">>",
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubCategModel extends StatelessWidget {
  final String mainCategName;
  final String subCategName;
  final String asset;
  final String assaetLabel;
  const SubCategModel({
    Key? key,
    required this.mainCategName,
    required this.subCategName,
    required this.asset,
    required this.assaetLabel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategProducts(
              subCategName: subCategName,
              maincategName: mainCategName,
            ),
          ),
        );
      },
      child: Column(
        children: [
          SizedBox(
            height: 70,
            width: 70,
            child: Image(
                image:
                    AssetImage(asset)),
          ),
          Text(assaetLabel,
          style: const TextStyle(
            fontSize: 12,
          ),),
        ],
      ),
    );
  }
}

class CategHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategHeaderLabel({
    Key? key,required this.headerLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        headerLabel,
        style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5),
      ),
    );
  }
}

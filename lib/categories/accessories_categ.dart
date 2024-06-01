import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widgets/categ_widgets.dart';

class AccessoriesCategory extends StatelessWidget {
  const AccessoriesCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CategHeaderLabel(
                  headerLabel: "Accessories",
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: GridView.count(
                    mainAxisSpacing: 50,
                    crossAxisSpacing: 15,
                    crossAxisCount: 3,
                    children: List.generate(
                      accessories.length-1,
                      (index) {
                        return SubCategModel(
                          mainCategName: "accessories",
                          subCategName: accessories[index+1],
                          asset: "images/accessories/accessories$index.jpg",
                          assaetLabel: accessories[index+1],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          right: 0,
          bottom: 0,
          child: SliderBar(
            mainCategName: "Accessories",
          ),
        ),
      ],
    );
  }
}
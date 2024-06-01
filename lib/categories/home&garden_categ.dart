import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widgets/categ_widgets.dart';

class HomeGarden extends StatelessWidget {
  const HomeGarden({Key? key}) : super(key: key);

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
                  headerLabel: "Home & Garden",
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: GridView.count(
                    mainAxisSpacing: 50,
                    crossAxisSpacing: 15,
                    crossAxisCount: 3,
                    children: List.generate(
                      homeandgarden.length-1,
                      (index) {
                        return SubCategModel(
                          mainCategName: "home & garden",
                          subCategName: homeandgarden[index+1],
                          asset: "images/homegarden/home$index.jpg",
                          assaetLabel: homeandgarden[index+1],
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
            mainCategName: "Home & Garden",
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

import '../categories/accessories_categ.dart';
import '../categories/bags_categ.dart';
import '../categories/beauty_categ.dart';
import '../categories/electronics_categ.dart';
import '../categories/home&garden_categ.dart';
import '../categories/kids_categ.dart';
import '../categories/men_categ.dart';
import '../categories/shoes_categ.dart';
import '../categories/women_categ.dart';
import '../widgets/fake_screen.dart';

List<ItemsData> items = [
  ItemsData(label: "Men"),
  ItemsData(label: "women"),
  ItemsData(label: "Shoes"),
  ItemsData(label: "Bags"),
  ItemsData(label: "Electronics"),
  ItemsData(label: "Accessories"),
  ItemsData(label: "Home & Garden"),
  ItemsData(label: "Kids"),
  ItemsData(label: "Beauty"),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  int tappedIndex = 0;
  final PageController pageController = PageController();
  @override
  void initState() {
    for(var element in items){
      element.isSelected=false;
      setState(() {
        items[0].isSelected=true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const FakeSearch(),
      ),
      body: Stack(
        children: [
          Positioned(bottom: 0, left: 0, child: sideNavigator(size)),
          Positioned(bottom: 0, right: 0, child: categView(size)),
        ],
      ),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.2,
      child: ListView.builder(
        itemCount: items.length,
        //itemCount: maincateg.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              pageController.animateToPage(
                index,
                duration: const Duration(
                  seconds: 1,
                ),
                curve: Curves.easeInOut,
              );
              /*for(var element in items){
                element.isSelected=false;
              }
              setState(() {
                items[index].isSelected = true;
              });*/
            },
            child: Container(
              height: 100,
              color: items[index].isSelected == true
                  ? Colors.white
                  : Colors.grey.shade300,
              child: Center(
                child: Text(items[index].label),
              ),
            ),
            /*onTap: () {
              setState(() {
                tappedIndex=index;
              });
            },
            child: Container(
              height: 100,
              color: tappedIndex==index?Colors.white:Colors.grey.shade300,
              child: Text(maincateg[index]),
            ),*/
          );
        },
      ),
    );
  }

  Widget categView(Size size) {
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.8,
      color: Colors.white,
      child: PageView(
        controller: pageController,
        onPageChanged: (index) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[index].isSelected = true;
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          MenCategory(),
          WomenCateg(),
          ShoesCategory(),
          BagsCategory(),
          ElectronicsCategory(),
          AccessoriesCategory(),
          HomeGarden(),
          KidsCategory(),
          BeautyCategory(),
        ],
      ),
    );
  }
}

class ItemsData {
  late String label;
  bool isSelected;
  ItemsData({required this.label, this.isSelected = false});
}

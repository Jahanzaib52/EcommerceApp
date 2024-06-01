import 'package:flutter/material.dart';
import 'package:pakbazzar/galleries/accessories_gallery.dart';
import 'package:pakbazzar/galleries/bags_gallery.dart';
import 'package:pakbazzar/galleries/beauty_gallery.dart';
import 'package:pakbazzar/galleries/electronics_gallery.dart';
import 'package:pakbazzar/galleries/homegarden_gallery.dart';
import 'package:pakbazzar/galleries/kids_gallery.dart';
import 'package:pakbazzar/galleries/men_gallery.dart';
import 'package:pakbazzar/galleries/shoes_gallery.dart';
import 'package:pakbazzar/galleries/women_gallery.dart';

import '../widgets/fake_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,//.withOpacity(0.5),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const FakeSearch(),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.yellow,
            indicatorWeight: 5,
            //indicatorPadding: EdgeInsets.all(10),
            tabs: [
              RepeatedTab(label: "Men"),
              RepeatedTab(label: "Women"),
              RepeatedTab(label: "Shoes"),
              RepeatedTab(label: "Bags"),
              RepeatedTab(label: "Electronics"),
              RepeatedTab(label: "Accessories"),
              RepeatedTab(label: "Home & Garden"),
              RepeatedTab(label: "Kids"),
              RepeatedTab(label: "Beauty"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //Center(child: Text("Men Screen")),
            const MenGalleryScreen(),
            const WomenGalleryScreen(),
            ShoesGalleryScreen(),
            const BagsGalleryScreen(),
            const ElectronicsGalleryScreen(),
            const AccessoriesGalleryScreen(),
            const HomeGardenGalleryScreen(),
            const KidsGalleryScreen(),
            const BeautyGalleryScreen(),
          ],
        ),
      ),
    );
  }
}



class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}

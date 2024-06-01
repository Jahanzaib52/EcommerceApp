import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/dashboard_components/my_store.dart';
import 'package:pakbazzar/widgets/alert_dialog.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';

import '../dashboard_components/edit_business.dart';
import '../dashboard_components/manage_products.dart';
import '../dashboard_components/suplier_balance.dart';
import '../dashboard_components/suplier_orders.dart';
import '../dashboard_components/suplier_statics.dart';

List<String> cardLabel = [
  "MY STORE",
  "ORDERS",
  "EDIT PROFILE",
  "MANAGE PRODUCTS",
  "BALANCE",
  "STATICS"
];
List<IconData> cardIcons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Widget> onBoardingScreens = const [
    MyStore(),
    SupplierOrders(),
    EditBusiness(),
    ManageProducts(),
    SupplierBalance(),
    SupplierStatics(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBarTitle(title: "Dashboard"),
        actions: [
          IconButton(
            onPressed: () {
              MyAlertDialog.showMyDialog(
                context: context,
                title: "Logout",
                content: "Are you sure you want to logout?",
                onTabNo: (){Navigator.pop(context);},
                onTabYes: ()async{
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, "welcome_screen");
                },
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          children: List.generate(
            6,
            (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => onBoardingScreens[index],
                    ),
                  );
                },
                child: Card(
                  color: Colors.blueGrey.withOpacity(0.7),
                  shadowColor: Colors.purpleAccent.shade200,
                  elevation: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cardIcons[index],
                        size: 50,
                        color: Colors.yellow,
                      ),
                      Text(
                        cardLabel[index],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

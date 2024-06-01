import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pakbazzar/auth/customer_login.dart';
import 'package:pakbazzar/auth/supplier_login.dart';
import 'package:pakbazzar/auth/supplier_signup.dart';
import 'package:pakbazzar/main_screen/customer_home.dart';
import 'package:pakbazzar/auth/customer_signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pakbazzar/main_screen/onboarding_screen.dart';
import 'package:pakbazzar/providers/cart_provider.dart';
import 'package:pakbazzar/providers/sql_helper.dart';
import 'package:pakbazzar/providers/wish_provider.dart';
import 'package:provider/provider.dart';


import 'main_screen/suplier_home.dart';
import 'main_screen/welcome_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SQLHelper.database;
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyDBBjX8V8--FYMJ6GR7tUw-ps_mx7nhLi8",
            appId: "1:780081743631:android:6addedbba2da5efd41207a",
            messagingSenderId: "780081743631",
            projectId: "pakbazaar-540c8",
            storageBucket: "gs://pakbazaar-540c8.appspot.com",
          ),
        )
      : await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Cart>(create: (context) => Cart()),
      ChangeNotifierProvider<Wish>(create: (context)=>Wish()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "onboarding_screen",
        routes: {
          "onboarding_screen":(context)=>const OnBoardingScreen(),
          "welcome_screen": (context) => const WelcomeScreen(),
          "supplier_home": (context) => const SupplierHomeScreen(),
          "customer_home": (context) => const CustomerHomeScreen(),
          "customer_signup": (context) => const CustomerSignup(),
          "customer_login": (context) => const CustomerLogin(),
          "supplier_signup": (context) => const SupplierSignup(),
          "supplier_login": (context) => const SupplierLogin(),
        });
  }
}

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/galleries/shoes_gallery.dart';
import 'package:pakbazzar/minor_screen/hot_deals_screen.dart';
import 'package:pakbazzar/minor_screen/subcateg_products.dart';

enum Offer {
  watches,
  shoes,
  sale,
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  Timer? countDown;
  int second = 3;
  void startTimer() {
    countDown = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        second--;
      });
      if (second < 0) {
        stopTimer();
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushReplacementNamed(context, "customer_home");
        } else {
          Navigator.pushReplacementNamed(context, "welcome_screen");
        }
      }
    });
  }

  void stopTimer() {
    countDown!.cancel();
  }

  late int selectedRandomIndex;
  void selectRandomOffer() {
    Random random = Random();
    selectedRandomIndex = random.nextInt(Offer.values.length);
    print(selectedRandomIndex);
    print(Offer.values[selectedRandomIndex]);
  }

  void navigateToOffer() {
    switch (Offer.values[selectedRandomIndex]) {
      case Offer.watches:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategProducts(
              fromonBoarding: true,
              subCategName: "smart watch",
              maincategName: "electronics",
            ),
          ),
          (route) => false,
        );
        break;
      case Offer.shoes:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ShoesGalleryScreen(
              fromonBoarding: true,
            ),
          ),
          (route) => false,
        );
        break;
      case Offer.sale:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HotDealsScreen(
              maxDiscount: maxDiscount!,
            ),
          ),
          (route) => false,
        );
    }
  }

  List<int> discountList = [];
  int? maxDiscount;
  void getDiscount() {
    FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var document in querySnapshot.docs) {
        discountList.add(document["discount"]);
        setState(() {
          maxDiscount = discountList.reduce(max);
        });
      }
    });
  }

  late AnimationController animationController;
  late Animation tweenAnimation;

  @override
  void initState() {
    super.initState();
    startTimer();
    selectRandomOffer();
    getDiscount();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    tweenAnimation = ColorTween(begin: Colors.black, end: Colors.red)
        .animate(animationController);
    tweenAnimation.addListener(() {
      setState(() {});
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              startTimer();
              navigateToOffer();
            },
            child: Image.asset(
              fit: BoxFit.cover,
              "images/onboarding/${Offer.values[selectedRandomIndex].toString().replaceAll("Offer.", "")}.JPEG",
            ),
          ),
          Positioned(
            top: 35,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                stopTimer();
                if (FirebaseAuth.instance.currentUser != null) {
                  Navigator.pushReplacementNamed(context, "customer_home");
                } else {
                  Navigator.pushReplacementNamed(context, "welcome_screen");
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Colors.blueGrey.withOpacity(0.4))),
              child: second > 0
                  ? Text(
                      "Skip | $second",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : const Text(
                      "Skip | ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          Offer.values[selectedRandomIndex] == Offer.sale
              ? Positioned(
                  top: 225,
                  right: 80,
                  child: AnimatedOpacity(
                    opacity: animationController.value,
                    duration: const Duration(microseconds: 100),
                    child: Text(
                      maxDiscount.toString() + "%",
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 75,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            bottom: 75,
            child: AnimatedBuilder(
              animation: animationController.view,
              builder: (context, child) {
                return Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  color: tweenAnimation.value,
                  child: child,
                );
              },
              child: const Center(
                child: Text(
                  "SHOP NOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

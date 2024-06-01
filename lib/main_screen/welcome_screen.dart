
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/yellow.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

const colorsList = [
  Colors.yellowAccent,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.teal,
];
const style = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  fontFamily: "Acme",
);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/inapp/bgimage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedTextKit(
                isRepeatingAnimation: true,
                repeatForever: true,
                animatedTexts: [
                  ColorizeAnimatedText(
                    "WELCOME",
                    textStyle: style,
                    colors: colorsList,
                  ),
                  ColorizeAnimatedText(
                    "Duck Store",
                    textStyle: style,
                    colors: colorsList,
                  ),
                ],
              ),
              /*const Text(
                "Welcome",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow),
              ),*/
              const SizedBox(
                height: 150,
                child: Image(
                  image: AssetImage("images/inapp/logo.jpg"),
                ),
              ),
              SizedBox(
                height: 60,
                child: DefaultTextStyle(
                  style: style,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    isRepeatingAnimation: true,
                    animatedTexts: [
                      RotateAnimatedText('BUY'),
                      RotateAnimatedText('SHOP'),
                      RotateAnimatedText('DUCK STORE'),
                    ],
                  ),
                ),
              ),
              /*const Text(
                "Duck Shop",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow),
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: const Text(
                          "Suppliers Only",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: const BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedBuilder(
                              animation: controller.view,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: controller.value * 2 * pi,
                                  child: child,
                                );
                              },
                              child: Image.asset(
                                "images/inapp/logo.jpg",
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                            ),
                            YellowButton(
                              widthRatio: 0.25,
                              label: "Login",
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, "supplier_login");
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: YellowButton(
                                widthRatio: 0.25,
                                label: "SignUp",
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "supplier_signup");
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: const BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: YellowButton(
                            widthRatio: 0.25,
                            label: "Login",
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, "customer_login");
                            },
                          ),
                        ),
                        YellowButton(
                          widthRatio: 0.25,
                          label: "SignUp",
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, "customer_signup");
                          },
                        ),
                        AnimatedBuilder(
                          animation: controller.view,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: controller.value * 2 * pi,
                              child: child,
                            );
                          },
                          child: Image.asset(
                            "images/inapp/logo.jpg",
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SocialLogin(
                        label: "Google",
                        child: Image.asset("images/inapp/google.jpg"),
                        onPressed: () {},
                      ),
                      SocialLogin(
                        label: "Facebook",
                        child: Image.asset("images/inapp/facebook.jpg"),
                        onPressed: () {},
                      ),
                      processing == true
                          ? const CircularProgressIndicator(color: Colors.purple,)
                          : SocialLogin(
                              label: "Guest",
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                setState(() {
                                  processing = true;
                                });
                                await FirebaseAuth.instance.signInAnonymously();
                                /*final _uid =
                                    FirebaseAuth.instance.currentUser!.uid;
                                final _image=AssetImage("images/inapp/guest.jpg");
                          f_storage.Reference reference=f_storage.FirebaseStorage.instance.ref("cust-images/$_uid.jpg");
                          await reference.putFile(file);*/
                                await FirebaseFirestore.instance
                                    .collection("anonymous")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set({
                                  "name": "Guest",
                                  "email": "example@email.com",
                                  "profile_image": "",
                                  "phone": "ex +92xxxxxxxxxx",
                                  "address": "",
                                  "customer_uid":
                                      FirebaseAuth.instance.currentUser!.uid,
                                });
                                Navigator.pushReplacementNamed(
                                    context, "customer_home");
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialLogin extends StatelessWidget {
  final String label;
  final Widget child;
  final Function() onPressed;
  const SocialLogin({
    Key? key,
    required this.label,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: child,
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

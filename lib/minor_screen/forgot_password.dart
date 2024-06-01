import 'package:flutter/material.dart';
import 'package:pakbazzar/classes/auth_repo.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';
import 'package:pakbazzar/widgets/yellow.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //late String email;
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool processing=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
        title: const AppBarTitle(title: "Forgot Password"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Center(
                child: Text(
                  "To reset your password\n\nPlease enter your email address\nand click on the button",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Email";
                  } else if (value.isValidEmail() == false) {
                    return "Please enter valid email";
                  }
                  return null;
                },
                controller: emailController,
                decoration: InputDecoration(
                  label: const Text("Email"),
                  hintText: "Enter your Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.purple,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurpleAccent,
                      width: 2,
                    ),
                  ),
                ),
              ),
              processing==true?
              const CircularProgressIndicator():
              YellowButton(
                widthRatio: 0.4,
                label: "Send Reset Link",
                onPressed: () async{
                  if (formKey.currentState!.validate()){
                    setState(() {
                      processing=true;
                    });
                    await AuthRepo.sendPasswordResetEmail(emailController.text);
                    Navigator.pushNamed(context, "customer_login");
                  } else {
                    print("Not Valid");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^[a-zA-Z0-9]+[\_\-\.]*[a-zA-Z0-9]*[@][a-z]{2,}[\.][a-zA-Z0-9]{2,3}$')
        .hasMatch(this);
  }
}

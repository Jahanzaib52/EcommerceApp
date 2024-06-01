import 'package:flutter/material.dart';


class AuthButton extends StatelessWidget {
  final String buttonLabel;
  final Function() onPressed;
  const AuthButton({
    Key? key,required this.buttonLabel,required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.75,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll<Color>(Colors.purple),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonLabel,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class HaveAccount extends StatelessWidget {
  final String accountInfo;
  final String buttonLabel;
  final Function() onPressed;
  const HaveAccount({
    Key? key,required this.accountInfo,required this.buttonLabel,required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          accountInfo,
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            buttonLabel,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const AuthHeaderLabel({
    Key? key,required this.headerLabel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headerLabel,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Icon(
          Icons.home_work,
          size: 40,
          color: Colors.black,
        ),
      ],
    );
  }
}

var textFormDecoration=InputDecoration(
                        labelText: "Full Name",
                        hintText: "Enter your full Name",
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
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      );

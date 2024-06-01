import 'package:flutter/material.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';

class EditBusiness extends StatelessWidget {
  const EditBusiness({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBarTitle(title: "EditBusiness"),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
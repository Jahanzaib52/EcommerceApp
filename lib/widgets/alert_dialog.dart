import 'package:flutter/cupertino.dart';

class MyAlertDialog {
  static void showMyDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function() onTabNo,
    required Function() onTabYes,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const Text("No"),
              onPressed: onTabNo,
            ),
            CupertinoDialogAction(
              child: const Text("Yes"),
              onPressed: onTabYes,
            ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiHelper {
  static void showLoadingDialouge(BuildContext context, String text) {
    AlertDialog loadingDialouge = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 25.0,
          ),
          Text(text),
        ],
      ),
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return loadingDialouge;
        }));
  }

  static void showAlertDialouge(
      BuildContext context, String title, String content) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    );
  }
}

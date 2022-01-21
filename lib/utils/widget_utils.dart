import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutteroc/utils/app_colors.dart';

class WidgetUtils {
  static void showFlushBar(
      {required BuildContext context,
      String? title,
      String? message,
      Duration duration = const Duration(seconds: 3),
      bool isDismissible = true,
      FlushbarDismissDirection dismissDirection =
          FlushbarDismissDirection.HORIZONTAL}) {
    Flushbar(
      title: title,
      message: message,
      duration: duration,
      isDismissible: isDismissible,
      dismissDirection: dismissDirection,
    )..show(context);
  }

  static void showProgressDialog(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(
                  color: AppColors.blue,
                ),
                Container(
                    margin: EdgeInsets.only(left: 10), child: Text(message)),
              ],
            ),
          );
        });
  }

  static void unFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
  }
}

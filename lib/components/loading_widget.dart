import 'package:flutter/material.dart';
import 'package:flutteroc/utils/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String loadingText;

  LoadingWidget({Key? key, this.loadingText = 'Đang xử lý...'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: SizedBox(
                child: CircularProgressIndicator(
                  color: AppColors.blue,
                ),
                width: 32,
                height: 32,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Đang xử lý...'),
            )
          ],
        ),
      ),
    );
  }
}

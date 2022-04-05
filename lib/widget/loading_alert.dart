import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';

class LoadingAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      insetPadding: EdgeInsets.symmetric(horizontal: 150, vertical: 150),
      content: Container(
          alignment: Alignment.center,
          height: 50,
          width: 100,
          child: Center(
            child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(LightColors.mainBlue),
            ),
          )),
    );
  }
}

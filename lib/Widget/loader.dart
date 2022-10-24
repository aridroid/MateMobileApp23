import 'package:flutter/material.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';

class Loader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.3),
      child: const SizedBox(
        height: 35,
        width: 35,
        child: CircularProgressIndicator(
          backgroundColor: MateColors.activeIcons,
          valueColor: AlwaysStoppedAnimation<Color>(
             Color(0xFF707070),
          ),
        ),
      ),
    );
  }
}
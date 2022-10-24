import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../asset/Colors/MateColors.dart';



class SendInvitationButton extends StatelessWidget {
  final String text;

  SendInvitationButton(this.text);

  @override
  Widget build(BuildContext context) {
    return  Container(
      height:30.0.sp,
      alignment: Alignment.center,
      width: 250.5.sp,
      decoration: BoxDecoration(color: MateColors.activeIcons, borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(width: 3, color: Colors.white, style: BorderStyle.none)),
      margin: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 10),
      child: Text(
        text,
        style:TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.5.sp),
      ),
    );
  }
}

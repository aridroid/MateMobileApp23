import 'package:mate_app/Model/ChatModel.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatRow extends StatelessWidget {
  ChatModel chatModelObject;

  ChatRow(this.chatModelObject);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.0, left: 15.0, right: 10.0),
            padding: EdgeInsets.all(8.0),
            // color: Colors.grey.withOpacity(0.5),
            decoration: BoxDecoration(
              color: Colors.grey[800]!.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatModelObject.user!,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: MateColors.activeIcons),
                ),
                Text(chatModelObject.msg!,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w100,
                        color: Colors.white)),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  width: double.infinity,
                  child: Text(chatModelObject.date!,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w100,
                          color: Colors.white)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

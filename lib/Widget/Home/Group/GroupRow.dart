import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/Screen/Chat/ChatScreen.dart';
import 'package:flutter/material.dart';

class GroupRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(ChatScreen.chatScreenRoute),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              title: Text(
                'Calculus Study Group',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: MateColors.activeIcons),
              ),
              subtitle: Text("2 Unread Message",
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey[50])),
              trailing: Text("12 arriave",
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey[50])),
            ),
          ),
          Divider(
            thickness: 0.3,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

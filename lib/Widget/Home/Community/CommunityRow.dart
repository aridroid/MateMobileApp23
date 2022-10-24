import 'package:flutter/material.dart';

class CommunityRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListTile(
            leading: Container(
                width: device.size.width * 0.2,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    "https://cdn.pixabay.com/photo/2016/03/31/23/37/bird-1297727__340.png",
                  ),
                )),
            title: Text('Uc Berkeley Model UN IR Club Info Session £1',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[50])),
            subtitle: Text("This is the Subtitle of the system",
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w100,
                    color: Colors.grey[50])),
            trailing: Text("Fri 2020",
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
    );
  }
}

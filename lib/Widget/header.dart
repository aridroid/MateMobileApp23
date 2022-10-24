import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Container(
      key: _scaffoldKey,
      child: Column(
        children: [
          Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Selector<AuthUserProvider, String>(
                    selector: (ctx, authUserProvider) =>
                        authUserProvider.authUserPhoto,
                    builder: (ctx, data, _) {
                      return Container(
                        width: 45,
                        height: 45,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                            data,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Image.asset(
                  "lib/asset/logo.png",
                  //color: Colors.white,
                  width: 50,
                  height: 30,
                ),
                IconButton(
                    icon: Icon(Icons.chat_bubble),
                    color: MateColors.activeIcons,
                    onPressed: () {})
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[700],
          )
        ],
      ),
    );
  }
}

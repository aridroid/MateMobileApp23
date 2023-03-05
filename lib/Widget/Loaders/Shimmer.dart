import 'package:get/get.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:shimmer/shimmer.dart';

Widget userDetailLoader() {
  return SizedBox(
    child: Shimmer.fromColors(
      baseColor: Colors.white38,
      highlightColor: Colors.white70,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0.0, 10.0),
                            blurRadius: 10.0),
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: CircleAvatar(
                      child: Text('X'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Text(
                  "Loading...",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                        child: Text("X",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    Center(
                        child: Text(0 > 1 ? 'Followers' : 'Follower',
                            style: TextStyle(color: Colors.white))),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Center(
                        child: Text("X",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    Center(
                        child: Text(
                      'Following',
                      style: TextStyle(color: Colors.white),
                    )),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              thickness: 1,
              color: Colors.white24,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Loading Details...',
                style: TextStyle(fontSize: 30, color: Colors.white),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Loading....",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget tabHeadingLoader() {
  return Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Shimmer.fromColors(
        baseColor: Colors.white38,
        highlightColor: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Loading...'),
              Text('Loading...'),
              Text('Loading...'),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget myClassLoader() {
  return SizedBox(
    child: Shimmer.fromColors(
      baseColor: Colors.white38,
      highlightColor: Colors.white70,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (_, index) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  "Loading...",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  color: Colors.amber,
                  icon: Icon(
                    Icons.details,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
              Divider(
                color: MateColors.activeIcons,
              )
            ],
          );
        },
      ),
    ),
  );
}

final ThemeController themeController = Get.find<ThemeController>();

Widget timelineLoader() {
  return SizedBox(
    child: Shimmer.fromColors(
        baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
        highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://placehold.it/90x90',
                        ),
                      ),
                      title: Text('Loading name...',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              color: MateColors.activeIcons)),
                      subtitle: Text(
                        'Loading Location...',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Loading description...',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        "lib/asset/molla.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.grey[50],
                              size: 18,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(
                              Icons.mail_outline,
                              color: Colors.grey[50],
                              size: 18,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(
                              Icons.bookmark_border,
                              color: Colors.grey[50],
                              size: 18,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.grey[50],
                              size: 18,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.grey[50],
                              size: 18,
                            ),
                            onPressed: () {}),
                      ],
                    ),
                    Divider(
                      color: MateColors.activeIcons,
                    )
                  ],
                ),
              );
            })),
  );
}

Widget userListLoader() {
  return Shimmer.fromColors(
      baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
      highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://placehold.it/90x90",
              ),
            ),
            title: Text("Loading Name...",
                style: TextStyle(
                    fontFamily: 'Quicksand', color: MateColors.activeIcons)),
            subtitle: Text(
              'Loading Detail...',
              style: TextStyle(color: Colors.white54),
            ),
          );
        },
      ));
}


Widget aboutSectionLoader() {
  return SizedBox(
    child: Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.black54,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://placehold.it/90x90',
                        ),
                      ),
                      title: Text('Loading name...',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              color: MateColors.activeIcons)),
                      subtitle: Text(
                        'Loading Location...',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Loading description...',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        "lib/asset/molla.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.grey[50],
                              size: 18,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(
                              Icons.mail_outline,
                              color: Colors.grey[50],
                              size: 18,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(
                              Icons.bookmark_border,
                              color: Colors.grey[50],
                              size: 18,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.grey[50],
                              size: 18,
                            ),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.grey[50],
                              size: 18,
                            ),
                            onPressed: () {}),
                      ],
                    ),
                    Divider(
                      color: MateColors.activeIcons,
                    )
                  ],
                ),
              );
            })),
  );
}




class GroupLoader extends StatelessWidget {
  const GroupLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 15,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10,right: 0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 12.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                    ),
                    Container(
                      width: double.infinity,
                      height: 12.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 40,),
            ],
          ),
        ),
      ),
    );
  }
}
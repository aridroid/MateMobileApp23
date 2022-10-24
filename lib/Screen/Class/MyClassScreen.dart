import 'package:mate_app/Providers/UserClassProvider.dart';
import 'package:mate_app/Screen/Class/MyClassDetailScreen.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';

class MyClassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 0), () {
      if (Provider.of<UserClassProvider>(context, listen: false)
              .joinedClasses
              .length ==
          0) {
        Provider.of<UserClassProvider>(context, listen: false).userClasses();
      }
    });

    return Scaffold(
      backgroundColor: myHexColor,
      body: Consumer<UserClassProvider>(
        builder: (ctx, myClass, _) {
          if (myClass.myClassLoaderStatus) {
            return myClassLoader();
          }

          return RefreshIndicator(
            onRefresh: () {
              return myClass.userClasses();
            },
            child: ListView.builder(
              itemCount: myClass.joinedClasses.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(MyClassDetailScreen.routeName, arguments: {
                      "classDetail": myClass.joinedClasses[index],
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          "${myClass.joinedClasses[index].courseIdentifier} ${myClass.joinedClasses[index].semester} ${myClass.joinedClasses[index].year}",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${myClass.joinedClasses[index].courseTitle}",
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
                      Padding(
                        padding: const EdgeInsets.only(left: 70.0),
                        child: Text(
                          'Assignments: ${myClass.joinedClasses[index].assignments.length.toString()}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Divider(
                        color: MateColors.activeIcons,
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:mate_app/Model/JoinedClass.dart';
import 'package:mate_app/Screen/Class/AddAssignmentScreen.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:flutter/material.dart';

class MyClassDetailScreen extends StatelessWidget {
  static final String routeName = '/my-class-detail';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, JoinedClass>;

    return Scaffold(
      backgroundColor: myHexColor,
      appBar: AppBar(
        title: Text(
            "${routeArgs["classDetail"].courseIdentifier.toString()} ${routeArgs["classDetail"].semester.toString()} ${routeArgs["classDetail"].year.toString()}"),
      ),
      body: ListView.builder(
        itemCount: routeArgs["classDetail"].assignments.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: Text(
              "${index + 1}",
              style: TextStyle(color: Colors.white),
            ),
            title: Text(
              "${routeArgs["classDetail"].assignments[index].name}",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "Due Date: ${routeArgs["classDetail"].assignments[index].dueDate}",
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AddAssignmentScreen.routeName, arguments: {
            "class_id": routeArgs["classDetail"].id,
            "courseIdentifier": routeArgs["classDetail"].courseIdentifier,
            "title": routeArgs["classDetail"].courseTitle
          });
        },
      ),
    );
  }
}

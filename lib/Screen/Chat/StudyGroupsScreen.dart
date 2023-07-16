import 'package:mate_app/Providers/StudyGroupProvider.dart';
import 'package:mate_app/Screen/Chat/ChatScreen.dart';
import 'package:mate_app/Screen/Chat/GroupController.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class StudyGroupsScreen extends StatelessWidget {
  static final String routeName = '/study-groups';
  GroupController _controller = Get.put(GroupController());

  Widget body() {
    return Consumer<StudyGroupProvider>(
      builder: (ctx, studyGroupProvider, _) {
        return RefreshIndicator(
          onRefresh: () {
            return studyGroupProvider.fetchStudyGrops(page: "all");
          },
          child: ListView.builder(
            itemCount: studyGroupProvider.studyGrops.length,
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {
                  _controller.checkAndGoToChatPage(studyGroupProvider.studyGrops[index], ctx);
                  /*Navigator.of(ctx)
                      .pushNamed(ChatScreen.chatScreenRoute, arguments: {
                    "studyGroup": studyGroupProvider.studyGrops[index],
                  });*/
                },
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text("${index + 1}"),
                  ),
                  title: Text(
                    studyGroupProvider.studyGrops[index].name!,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    "${studyGroupProvider.studyGrops[index].members!.length} member",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Provider.of<StudyGroupProvider>(context, listen: false)
          .fetchStudyGrops(page: "all");
    });

    return Scaffold(
      backgroundColor: myHexColor,
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: body(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Create A Study Group",
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: myHexColor,
      title: Text("Study Groups"),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                  cursorColor: Colors.cyanAccent,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[50],
                    ),
                    labelText: "Search groups...",
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.grey, width: 0.3),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:mate_app/Providers/FollowerProvider.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Screen/chat1/screens/allUsersScreen.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/chat1/personalChatPage.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:sizer/sizer.dart';


class FollowersScreen extends StatefulWidget {
  static final String routeName = '/followers';


  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {

  String searchText="";

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: myHexColor,
        appBar: AppBar(
          backgroundColor: myHexColor,
          title: Text('Followers', style: TextStyle(fontSize: 16.0.sp),),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(color: Colors.white, fontSize: 11.7.sp),
                      cursorColor: Colors.cyanAccent,
                      onChanged: (value) {
                        searchText = value;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[50],
                          size: 16,
                        ),
                        labelText: "Follower Search",
                        contentPadding: EdgeInsets.symmetric(vertical: -5),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelStyle: TextStyle(color: Colors.white, fontSize: 13.3.sp),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.person_search,
                        color: Colors.grey[50],
                        size: 20.0.sp,
                      ),
                      onPressed: () => Get.to(() => AllUsersScreen())
                  ),
                ],
              ),
            ),
            Expanded(child: FollowersScreenData(searchText: searchText,)),
          ],
        )
    );
  }
}

class FollowersScreenData extends StatefulWidget {
  final String searchText;

  const FollowersScreenData({Key? key, required this.searchText}) : super(key: key);

  @override
  _FollowersScreenDataState createState() => _FollowersScreenDataState();
}

class _FollowersScreenDataState extends State<FollowersScreenData> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), (){
      Provider.of<FollowerProvider>(context, listen: false).fetchFollowers();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<FollowerProvider>(
      builder: (ctx, followerProvider, _){

        if(followerProvider.followerLoaderStatus){
          return userListLoader();
        }

        return ListView.builder(
          itemCount: followerProvider.followers.length,
          itemBuilder: (ctx, index) {
            return Visibility(
              visible: widget.searchText.isNotEmpty? followerProvider.followers[index].name!.toLowerCase().contains(widget.searchText.trim().toLowerCase()): true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                      "id": followerProvider.followers[index].id,
                      "name": followerProvider.followers[index].name,
                      "photoUrl": followerProvider.followers[index].photoUrl,
                      "firebaseUid": followerProvider.followers[index].firebaseUid
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        followerProvider.followers[index].photoUrl!,
                      ),
                    ),
                    title: Text(followerProvider.followers[index].name!,
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            color: MateColors.activeIcons,
                            fontSize: 13.3.sp)),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}




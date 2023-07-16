import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Screen/Profile/ProfileScreen.dart';
import '../../Screen/Profile/UserProfileScreen.dart';
import '../../Utility/Utility.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../services/database_service.dart';
import '../services/dynamicLinkService.dart';
import 'chat_page.dart';
import 'groupDescriptionPage.dart';
import 'groupDescriptionShowpage.dart';
import 'groupMembersPage.dart';

class GroupDetailsBeforeJoining extends StatefulWidget {
  final String groupId;

  const GroupDetailsBeforeJoining({Key? key,required this.groupId}) : super(key: key);

  @override
  _GroupDetailsBeforeJoiningState createState() => _GroupDetailsBeforeJoiningState();
}

class _GroupDetailsBeforeJoiningState extends State<GroupDetailsBeforeJoining> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  User currentUser = FirebaseAuth.instance.currentUser!;
  ThemeController themeController = Get.find<ThemeController>();
  bool isLoadedGroup = false;
  QuerySnapshot? searchResultSnapshot;
  User? _user;

  String? groupName;
  String? groupIcon;

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    DatabaseService().getAllGroups().then((snapshot) {
      searchResultSnapshot = snapshot;
      setState(() {
        isLoadedGroup = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        return Future.value(true);
      },
      child: Scaffold(
        key: _key,
        backgroundColor: themeController.isDarkMode?backgroundColor:Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context, true);
              //return Future.value(true);
            },
            icon: Icon(Icons.arrow_back,color: MateColors.activeIcons),
          ),
          backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
          iconTheme: IconThemeData(
            color: MateColors.activeIcons,
          ),
          actions: [
            InkWell(
              onTap: ()async{
                String response  = await DynamicLinkService.buildDynamicLink(
                    groupId: widget.groupId,
                    groupName: groupName!,
                    groupIcon: groupIcon!,
                    userName: _user!.displayName!
                );
                if(response!=null){
                  Share.share(response);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20,left: 20),
                child: Image.asset(
                  "lib/asset/icons/share.png",
                  height: 19,
                  width: 19,
                  color: MateColors.activeIcons,
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: DatabaseService().getGroupDetails(widget.groupId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Future.delayed(Duration.zero,(){
                  groupName = snapshot.data?['groupName'];
                  groupIcon = snapshot.data?['groupIcon']??"";
                });
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          snapshot.data?['groupIcon']!=""?
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: MateColors.activeIcons,
                            backgroundImage: NetworkImage(snapshot.data?['groupIcon']),
                          ):
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: MateColors.activeIcons,
                            child: Text(snapshot.data?['groupName'].substring(0, 1).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 28.5.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20,left: 16,right: 16),
                              child: Text(snapshot.data?['groupName'],
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style:  TextStyle(fontSize: 17,fontFamily: "Poppins",fontWeight: FontWeight.w700,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 10),
                            child: Text("${snapshot.data!['members'].length} ${snapshot.data?['members'].length<2 ? "member": "members"}",
                              style:  TextStyle(fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w400,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                      thickness: 2,
                      height: 0,
                    ),
                    !snapshot.data?['members'].contains(_user!.uid + '_' + _user!.displayName!)?
                    Container(
                      height: 40,
                      width: 120,
                      margin: EdgeInsets.only(left: 16,right: 16,bottom: 0,top: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: MateColors.activeIcons,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        onPressed: ()async{
                          await DatabaseService(uid: _user!.uid).togglingGroupJoin(snapshot.data?["groupId"], snapshot.data!["groupName"].toString(), Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName!);
                          _showScaffold('Successfully joined the group "${snapshot.data?["groupName"].toString()}"');
                          Future.delayed(Duration(milliseconds: 100), () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(
                              groupId: snapshot.data?["groupId"],
                              userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName!,
                              groupName: snapshot.data!["groupName"].toString(),
                                memberList : snapshot.data!["members"],
                            )));
                          });
                        },
                        child: Text("Join this group",
                          style: TextStyle(
                            color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ):Offstage(),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 16,right: 16,top: 20),
                      padding: EdgeInsets.fromLTRB(20,20,20,0),
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupMembersPage(groupId: widget.groupId,addPerson: snapshot.data!['members'].contains(_user!.uid + '_' + _user!.displayName!),)));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${snapshot.data?['members'].length} ${snapshot.data?['members'].length<2 ? "member": "members"}",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                            ),
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(top: 8,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data?['members'].length>5?5:snapshot.data?['members'].length,
                                      itemBuilder: (context, index) {
                                        return FutureBuilder<DocumentSnapshot>(
                                            future: DatabaseService().getUsersDetails(snapshot.data?['members'][index].split("_")[0]),
                                            builder: (context, snapshot1) {
                                              if(snapshot1.hasData){
                                                return Padding(
                                                  padding: EdgeInsets.only(left: index==0?0:16),
                                                  child: InkWell(
                                                    onTap: (){
                                                      if(snapshot1.data!.get('uuid')!=null){
                                                        if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data!.get('uuid')) {
                                                          Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                        } else {
                                                          Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                              arguments: {"id": snapshot1.data!.get('uuid'),
                                                                "name": snapshot1.data!.get('displayName'),
                                                                "photoUrl": snapshot1.data!.get('photoURL'),
                                                                "firebaseUid": snapshot1.data!.get('uid')
                                                              });
                                                        }
                                                      }
                                                    },
                                                    child: snapshot1.data!.get('photoURL')!=null?
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(
                                                        snapshot1.data!.get('photoURL'),
                                                      ),
                                                    ):
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      child: Text(snapshot.data!['members'][index].split('_')[1].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                                    ),
                                                  ),
                                                );
                                              }
                                              else if(snapshot1.connectionState == ConnectionState.waiting){
                                                return SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: Center(
                                                    child: LinearProgressIndicator(
                                                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                      minHeight: 3,
                                                      backgroundColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                    ),
                                                  ),
                                                );
                                              }
                                              return SizedBox();
                                            }
                                        );
                                      }),
                                  snapshot.data!['members'].length>5?
                                  Text("+${snapshot.data!['members'].length - 5}",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeController.isDarkMode?MateColors.subTitleTextLight:MateColors.subTitleTextLight,),
                                  ):Offstage(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    snapshot.data!['members'].contains(_user!.uid + '_' + _user!.displayName!)?
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 20),
                      padding: EdgeInsets.fromLTRB(20,20,20,20),
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Community description",
                            style: TextStyle(letterSpacing: 0.1,fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          (snapshot.data!['description']==null || snapshot.data!['description']=="")?
                          InkWell(
                            splashColor:  Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDescriptionPage(
                              groupId: snapshot.data!['groupId'],
                              description: snapshot.data!['description'] ?? "",
                            ))),
                            child: Text("Add group description",
                              style:  TextStyle(fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w400,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                            ),
                          ):
                          InkWell(
                            splashColor:  Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDescriptionShowPage(
                              groupId: snapshot.data!['groupId'],
                              description: snapshot.data!['description'] ?? "",
                              descriptionCreatorName: snapshot.data!['descriptionCreatorName']??"",
                              descriptionCreatorImage: snapshot.data!['descriptionCreatorImage']??"",
                              descriptionCreationTime: snapshot.data!['descriptionCreationTime']??0,
                            ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data!['description'].toString().length>100?
                                snapshot.data!['description'].toString().substring(0,100) + "...":
                                snapshot.data!['description'].toString(),
                                  style:  TextStyle(fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w400,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                                ),
                                if(snapshot.data!['description'].toString().length>100)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text("See more",
                                      style: TextStyle(fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: MateColors.activeIcons,),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ):Offstage(),
                   SizedBox(
                     height: 20,
                   ),
                    if(isLoadedGroup)
                      Padding(
                        padding: const EdgeInsets.only(left: 16,bottom: 16,top: 10),
                        child: Text("Communities you might be interested in",
                          style: TextStyle(letterSpacing: 0.1,fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                        ),
                      ),
                    if(isLoadedGroup)
                      Container(
                        height: 170,
                        margin: EdgeInsets.only(bottom: 16),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(left: 16,right: 0),
                          scrollDirection: Axis.horizontal,
                          itemCount: searchResultSnapshot!.docs.length,
                          itemBuilder: (context, index) {
                            if(searchResultSnapshot!.docs[index]["isPrivate"] != null){
                              if(searchResultSnapshot!.docs[index]["isPrivate"] == false && !searchResultSnapshot!.docs[index]["members"].contains(_user!.uid + '_' + _user!.displayName!)){
                                  if(searchResultSnapshot!.docs[index]["groupName"].toString().contains(snapshot.data!['groupName'][0]) || searchResultSnapshot!.docs[index]["admin"].toString().contains(snapshot.data!['admin'])){
                                    return InkWell(
                                      onTap: (){
                                        if(searchResultSnapshot!.docs[index]["members"].contains(_user!.uid + '_' + _user!.displayName!)){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(
                                            groupId: snapshot.data!["groupId"],
                                            userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName!,
                                            totalParticipant: snapshot.data!["members"].length.toString(),
                                            photoURL: snapshot.data!['groupIcon'],
                                            groupName: snapshot.data!["groupName"].toString(),
                                            memberList : snapshot.data!["members"],
                                          )));
                                        }else{
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupDetailsBeforeJoining(groupId: searchResultSnapshot!.docs[index]["groupId"],)));
                                        }
                                      },
                                      child: groupTile(
                                          Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName!,
                                          searchResultSnapshot!.docs[index]["groupId"],
                                          searchResultSnapshot!.docs[index]["groupName"].toString(),
                                          searchResultSnapshot!.docs[index]["admin"],
                                          searchResultSnapshot!.docs[index]["members"].length,
                                          searchResultSnapshot!.docs[index]["maxParticipantNumber"],
                                          searchResultSnapshot!.docs[index]["isPrivate"],
                                          searchResultSnapshot!.docs[index]["members"].contains(_user!.uid + '_' + _user!.displayName!),
                                          searchResultSnapshot!.docs[index]["groupIcon"]
                                      ),
                                    );
                                  }else{
                                    return Container();
                                  }
                              }else{
                                return Container();
                              }
                            }else{
                              return Container();
                            }
                          },
                        ),
                      ),
                  ],
                );
              } else
                return Center(child: Text("Oops! Something went wrong! \nplease trey again..", style: TextStyle(fontSize: 10.9.sp)));
            }),
      ),
    );
  }

  Widget groupTile(String userName, String groupId, String groupName, String admin, int totalParticipant, int maxParticipant, bool isPrivate, bool _isJoined, String imageURL) {
    return Container(
      width: 130,
      margin: EdgeInsets.only(right: 20,bottom: 10,top: 10),
      padding: EdgeInsets.only(top: 25,left: 0,right: 0),
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          imageURL!=""?
          CircleAvatar(
            radius: 24,
            backgroundColor: MateColors.activeIcons,
            backgroundImage: NetworkImage(imageURL),
          ):
          CircleAvatar(
            radius: 24,
            backgroundColor: MateColors.activeIcons,
            child: Text(groupName.toLowerCase().substring(0, 1).toUpperCase(), textAlign: TextAlign.center,
              style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Text(
              groupName,
              style: TextStyle(overflow: TextOverflow.ellipsis,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              "${totalParticipant} members",
              style: TextStyle(fontFamily: "Poppins",fontSize: 12.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }


  void _showScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(milliseconds: 1500),
      content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0, color: MateColors.activeIcons)),
    ));
  }

}

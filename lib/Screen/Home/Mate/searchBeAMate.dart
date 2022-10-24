import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Model/beAMatePostsModel.dart';
import 'package:mate_app/Providers/beAMateProvider.dart';
import 'package:mate_app/Services/beAMateService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Widget/Home/Mate/beAMateRow.dart';
import '../../../Widget/Home/Mate/findAMateRow.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';

class SearchBeAMate extends StatefulWidget {
  const SearchBeAMate({Key key}) : super(key: key);

  @override
  _SearchBeAMateState createState() => _SearchBeAMateState();
}

class _SearchBeAMateState extends State<SearchBeAMate> {
  ThemeController themeController = Get.find<ThemeController>();
  ScrollController _scrollController;
  int _page;
  List<Result> _beAMatePostsDataList = [];
  TextEditingController _textEditingController = TextEditingController();
  Future<BeAMatePostsModel> future;
  bool enterFutureBuilder = false;
  bool doingPagination = false;
  BeAMateService _beAMateService = BeAMateService();
  BeAMateProvider beAMateProvider;



  @override
  void initState() {
    super.initState();
    getStoredValue();
    beAMateProvider = Provider.of<BeAMateProvider>(context,listen: false);
    _page = 1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero, () {
          _page += 1;
          print('scrolled to bottom page is now $_page');
          future = _beAMateService.searchBeAMate(text: _textEditingController.text,page: _page,token: token);
        });
      }
    }
  }


  String token = "";
  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
  }


  Timer _throttle;
  _onSearchChanged() {
    if (_throttle?.isActive??false) _throttle?.cancel();
    _throttle = Timer(const Duration(milliseconds: 200), () {
      if(_textEditingController.text.length>2){
        fetchData();
      }
    });
  }

  fetchData()async{
    _page = 1;
    future = _beAMateService.searchBeAMate(text: _textEditingController.text,page: _page,token: token);
    future.then((value) {
      setState(() {
        doingPagination = false;
      });
      Future.delayed(Duration(milliseconds: 100),(){
        setState(() {
          enterFutureBuilder = true;
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _textEditingController,
          onChanged: (value){
            if(value.length>2){
              _onSearchChanged();
            }
          },
          style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
            ),
            hintText: "Search",
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
              child: Image.asset(
                "lib/asset/homePageIcons/searchPurple@3x.png",
                height: 10,
                width: 10,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
            ),
            suffixIcon: InkWell(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16,right: 15),
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w700,
                    color: MateColors.activeIcons,
                  ),
                ),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 3,color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 3,color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
            ),
          ),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          FutureBuilder<BeAMatePostsModel>(
            future: future,
            builder: (context,snapshot){
              if(snapshot.hasData){
                if(snapshot.data.success==true || doingPagination==true){
                  if(enterFutureBuilder){
                    if(doingPagination==false){
                      _beAMatePostsDataList.clear();
                    }
                    for(int i=0;i<snapshot.data.data.result.length;i++){
                      _beAMatePostsDataList.add(snapshot.data.data.result[i]);
                    }
                    Future.delayed(Duration.zero,(){
                      enterFutureBuilder = false;
                      setState(() {});
                    });
                  }
                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: _beAMatePostsDataList.length,
                        itemBuilder: (context,index){
                          Result beAMateData = _beAMatePostsDataList[index];
                          return BeAMateRow(
                            beAMateId: beAMateData.id,
                            description: beAMateData.description,
                            title: beAMateData.title,
                            portfolioLink: beAMateData.portfolioLink,
                            fromDate: beAMateData.fromDate,
                            toDate: beAMateData.toDate,
                            fromTime: beAMateData.timeFrom,
                            toTime: beAMateData.timeTo,
                            user: beAMateData.user,
                            hyperlinkText: beAMateData.hyperLinkText,
                            hyperlink: beAMateData.hyperLink,
                            createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(beAMateData.createdAt, true))}",
                            rowIndex: index,
                            isActive: beAMateData.isActive,
                          );



                          //   Container(
                          //   margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          //   padding: EdgeInsets.only(top: 5,bottom: 16),
                          //   decoration: BoxDecoration(
                          //     color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                          //     borderRadius: BorderRadius.circular(16),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.black.withOpacity(0.05),
                          //         spreadRadius: 5,
                          //         blurRadius: 7,
                          //         offset: Offset(0, 3),
                          //       ),
                          //     ],
                          //   ),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       ListTile(
                          //         leading: InkWell(
                          //           onTap: () {
                          //             if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == _beAMatePostsDataList[index].user.uuid) {
                          //               Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                          //             } else {
                          //               Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": _beAMatePostsDataList[index].user.uuid, "name": _beAMatePostsDataList[index].user.displayName, "photoUrl": _beAMatePostsDataList[index].user.profilePhoto, "firebaseUid": _beAMatePostsDataList[index].user.firebaseUid});
                          //             }
                          //           },
                          //           child: _beAMatePostsDataList[index].user.profilePhoto != null
                          //               ? ClipOval(
                          //             child: Image.network(
                          //               _beAMatePostsDataList[index].user.profilePhoto,
                          //               height: 32,
                          //               width: 32,
                          //               fit: BoxFit.cover,
                          //             ),
                          //           )
                          //               : ClipOval(
                          //             child: Image.asset(
                          //               "lib/asset/logo.png",
                          //               height: 32,
                          //               width: 32,
                          //               fit: BoxFit.fitWidth,
                          //             ),
                          //           ),
                          //         ),
                          //         title: InkWell(
                          //           onTap: () {
                          //             if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == _beAMatePostsDataList[index].user.uuid) {
                          //               Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                          //             } else {
                          //               Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": _beAMatePostsDataList[index].user.uuid, "name": _beAMatePostsDataList[index].user.displayName, "photoUrl": _beAMatePostsDataList[index].user.profilePhoto, "firebaseUid": _beAMatePostsDataList[index].user.firebaseUid});
                          //             }
                          //           },
                          //           child: Text(
                          //             _beAMatePostsDataList[index].user.displayName,
                          //             style: TextStyle(
                          //               fontSize: 14,
                          //               fontWeight: FontWeight.w500,
                          //               letterSpacing: 0.1,
                          //               color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          //             ),
                          //           ),
                          //         ),
                          //         trailing: PopupMenuButton<int>(
                          //           padding: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
                          //           color: themeController.isDarkMode?backgroundColor:Colors.white,
                          //           icon: Image.asset(
                          //             "lib/asset/icons/menu@3x.png",
                          //             height: 18,
                          //             color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                          //           ),
                          //           onSelected: (index1) async{
                          //             if(index1==0){
                          //             }else if(index1==1){
                          //               _showDeleteAlertDialog(beAMateId: _beAMatePostsDataList[index].id, rowIndex: index);
                          //             }else if(index1==2){
                          //               Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(moduleId: _beAMatePostsDataList[index].id,moduleType: "beMate",),));
                          //             }
                          //           },
                          //           itemBuilder: (context) => [
                          //             (_beAMatePostsDataList[index].user.uuid != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == _beAMatePostsDataList[index].user.uuid))
                          //                 ? PopupMenuItem(
                          //               value: 1,
                          //               height: 40,
                          //               child: Text(
                          //                 "Delete Post",
                          //                 textAlign: TextAlign.start,
                          //                 style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                          //               ),
                          //             )
                          //                 : PopupMenuItem(
                          //               value: 1,
                          //               enabled: false,
                          //               height: 0,
                          //               child: SizedBox(
                          //                 height: 0,
                          //                 width: 0,
                          //               ),
                          //             ),
                          //             PopupMenuItem(
                          //               value: 2,
                          //               height: 40,
                          //               child: Text(
                          //                 "Report",
                          //                 textAlign: TextAlign.start,
                          //                 style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         subtitle: Text(
                          //         "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse( _beAMatePostsDataList[index].createdAt, true))}",
                          //           style: TextStyle(
                          //             fontSize: 12,
                          //             color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                          //           ),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsets.only(left: 16,top: 0),
                          //         child: Text(
                          //           _beAMatePostsDataList[index].title,
                          //           style: TextStyle(
                          //             fontSize: 17,
                          //             fontWeight: FontWeight.w700,
                          //             color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          //           ),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
                          //         child: Text(
                          //           _beAMatePostsDataList[index].description,
                          //           style: TextStyle(
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.w400,
                          //             letterSpacing: 0.1,
                          //             color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          //           ),
                          //           overflow: TextOverflow.visible,
                          //         ),
                          //       ),
                          //       _beAMatePostsDataList[index].portfolioLink != null
                          //           ? Padding(
                          //         padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
                          //         child: Linkify(
                          //           onOpen: (link) async {
                          //             print("Clicked ${link.url}!");
                          //             if (await canLaunch(link.url))
                          //               await launch(link.url);
                          //             else
                          //               // can't launch url, there is some error
                          //               throw "Could not launch ${link.url}";
                          //           },
                          //           text: "Portfolio Link : ${_beAMatePostsDataList[index].portfolioLink}",
                          //           style: TextStyle(
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.w400,
                          //             letterSpacing: 0.1,
                          //             color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          //           ),
                          //           overflow: TextOverflow.visible,
                          //           linkStyle: TextStyle(color: MateColors.activeIcons, fontSize: 11.0.sp),
                          //         ),
                          //       )
                          //           : SizedBox(),
                          //       _beAMatePostsDataList[index].fromDate != null
                          //           ? Padding(
                          //         padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
                          //         child: Row(
                          //           children: [
                          //             Text(
                          //               "Available Dates : ${_beAMatePostsDataList[index].fromDate}",
                          //               style: TextStyle(
                          //                 fontSize: 14,
                          //                 fontWeight: FontWeight.w400,
                          //                 letterSpacing: 0.1,
                          //                 color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          //               ),
                          //               overflow: TextOverflow.visible,
                          //             ),
                          //             _beAMatePostsDataList[index].toDate != null
                          //                 ? Text(
                          //               "  -  ${_beAMatePostsDataList[index].toDate}",
                          //               style: TextStyle(
                          //                 fontSize: 14,
                          //                 fontWeight: FontWeight.w400,
                          //                 letterSpacing: 0.1,
                          //                 color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          //               ),
                          //               overflow: TextOverflow.visible,
                          //             )
                          //                 : SizedBox(),
                          //           ],
                          //         ),
                          //       )
                          //           : SizedBox(),
                          //       _beAMatePostsDataList[index].timeFrom != null
                          //           ? Padding(
                          //         padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
                          //         child: Row(
                          //           children: [
                          //             Text(
                          //               "Available times : ${_beAMatePostsDataList[index].timeFrom}",
                          //               style: TextStyle(
                          //                 fontSize: 14,
                          //                 fontWeight: FontWeight.w400,
                          //                 letterSpacing: 0.1,
                          //                 color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          //               ),
                          //               overflow: TextOverflow.visible,
                          //             ),
                          //             _beAMatePostsDataList[index].timeTo != null
                          //                 ? Text(
                          //               "  -  ${_beAMatePostsDataList[index].timeTo}",
                          //               style: TextStyle(
                          //                 fontSize: 14,
                          //                 fontWeight: FontWeight.w400,
                          //                 letterSpacing: 0.1,
                          //                 color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          //               ),
                          //               overflow: TextOverflow.visible,
                          //             )
                          //                 : SizedBox(),
                          //           ],
                          //         ),
                          //       )
                          //           : SizedBox(),
                          //       Padding(
                          //         padding: const EdgeInsets.only(left: 16,top: 16),
                          //         child: Row(
                          //           children: [
                          //             //Expanded(child: Text(title, textAlign: TextAlign.left, style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontSize: 12.0.sp, fontWeight: FontWeight.w600))),
                          //             Visibility(
                          //                 visible: (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == _beAMatePostsDataList[index].user.uuid),
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.only(right: 7.0),
                          //                   child: Text(_beAMatePostsDataList[index].isActive ? "Active" : "Inactive", textAlign: TextAlign.left,
                          //                     style: TextStyle(
                          //                       fontSize: 14,
                          //                       fontWeight: FontWeight.w500,
                          //                       color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                          //                     ),
                          //                   ),
                          //                 )),
                          //             Visibility(
                          //               visible: (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == _beAMatePostsDataList[index].user.uuid),
                          //               child: Consumer<BeAMateProvider>(
                          //                 builder: (context, value, child) {
                          //                   return /*!(value.beAMatePostsDataList[widget.rowIndex].toggleLoader)?*/
                          //                     FlutterSwitch(
                          //                       width: 48,
                          //                       height: 24,
                          //                       valueFontSize: 25.0,
                          //                       toggleSize: 20.0,
                          //                       activeText: "",
                          //                       inactiveText: "",
                          //                       toggleColor: themeController.isDarkMode?Color(0xFF0B0B0D):Colors.white,
                          //                       inactiveColor: themeController.isDarkMode?Color(0xFF414147):Color(0xFFB4B4C2),
                          //                       activeColor: MateColors.activeIcons,
                          //                       value: _beAMatePostsDataList[index].isActive,
                          //                       borderRadius: 14.0,
                          //                       showOnOff: true,
                          //                       onToggle: (val) async {
                          //                         bool updated = await Provider.of<BeAMateProvider>(context, listen: false).activeBeAMatePost(_beAMatePostsDataList[index].id, index, val);
                          //                         if (updated) {
                          //                           if (value.beAMateActiveData != null) {
                          //                             // IsBookmarked
                          //                             if (value.beAMateActiveData.message == "Post activated successfully" && value.beAMateActiveData.data.id == _beAMatePostsDataList[index].id) {
                          //                               value.beAMatePostsDataList[index].isActive = true;
                          //                               _beAMatePostsDataList[index].isActive = true;
                          //                             } else if (value.beAMateActiveData.message == "Post de-activated successfully" && value.beAMateActiveData.data.id == _beAMatePostsDataList[index].id) {
                          //                               value.beAMatePostsDataList[index].isActive = false;
                          //                               _beAMatePostsDataList[index].isActive = false;
                          //                             }
                          //                           }
                          //                         }
                          //                       },
                          //                     );
                          //                 },
                          //               ),
                          //             ),
                          //
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // );
                        },
                      ),
                    ],
                  );
                }else{
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text("No data found",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                  );
                }
              }else if(snapshot.hasError){
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Text("Something went wrong",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                      ),
                    ),
                  ),
                );
              }else{
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  _showDeleteAlertDialog({@required int beAMateId, @required int rowIndex,}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to delete your Be a Mate Post"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () async{
                bool isDeleted=await beAMateProvider.deleteBeAMatePost(beAMateId, rowIndex);
                if (isDeleted) {
                  _beAMatePostsDataList.removeAt(rowIndex);
                  setState(() {});
                  Navigator.of(context).pop();
                }
              },
            ),
            CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

}

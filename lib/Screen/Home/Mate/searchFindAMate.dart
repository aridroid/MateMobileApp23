import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Services/findAMateService.dart';
import 'package:mate_app/Model/findAMatePostsModel.dart' as fampm;
import 'package:mate_app/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Providers/findAMateProvider.dart';
import '../../../Widget/Home/Mate/findAMateRow.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';

class SearchFindAMate extends StatefulWidget {
  const SearchFindAMate({Key key}) : super(key: key);

  @override
  _SearchFindAMateState createState() => _SearchFindAMateState();
}

class _SearchFindAMateState extends State<SearchFindAMate> {
  ThemeController themeController = Get.find<ThemeController>();
  ScrollController _scrollController;
  int _page;
  List<fampm.Result> _findAMatePostsDataList = [];
  TextEditingController _textEditingController = TextEditingController();
  Future<fampm.FindAMatePostsModel> future;
  bool enterFutureBuilder = false;
  bool doingPagination = false;
  FindAMateService _findAMateService = FindAMateService();
  FindAMateProvider findAMateProvider;
  String token = "";
  Timer _throttle;

  @override
  void initState() {
    super.initState();
    getStoredValue();
    findAMateProvider = Provider.of<FindAMateProvider>(context,listen: false);
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
          future = _findAMateService.searchFindAMate(text: _textEditingController.text,page: _page,token: token);
        });
      }
    }
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
  }

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
      future = _findAMateService.searchFindAMate(text: _textEditingController.text,page: _page,token: token);
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
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: null,
      onPanUpdate: (details) {
        if (details.delta.dy > 0){
          FocusScope.of(context).requestFocus(FocusNode());
          print("Dragging in +Y direction");
        }
      },
      child: Scaffold(
        body: Container(
          height: scH,
          width: scW,
          decoration: BoxDecoration(
            color: themeController.isDarkMode?Color(0xFF000000):Colors.white,
            image: DecorationImage(
              image: AssetImage(themeController.isDarkMode?'lib/asset/Background.png':'lib/asset/BackgroundLight.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: scH*0.07,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (value){
                    if(value.length>2){
                      _onSearchChanged();
                    }
                  },
                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                    ),
                    hintText: "Search",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
                      child: Image.asset(
                        "lib/asset/homePageIcons/searchPurple@3x.png",
                        height: 10,
                        width: 10,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
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
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                          ),
                        ),
                      ),
                    ),
                    enabledBorder: commonBorder,
                    focusedBorder: commonBorder,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(top: 10),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    FutureBuilder<fampm.FindAMatePostsModel>(
                      future: future,
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data.success==true || doingPagination==true){
                            if(enterFutureBuilder){
                              if(doingPagination==false){
                                _findAMatePostsDataList.clear();
                              }
                              for(int i=0;i<snapshot.data.data.result.length;i++){
                                _findAMatePostsDataList.add(snapshot.data.data.result[i]);
                              }
                              Future.delayed(Duration.zero,(){
                                enterFutureBuilder = false;
                                setState(() {});
                              });
                            }
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: _findAMatePostsDataList.length,
                              itemBuilder: (context,index){
                                fampm.Result findAMateData = _findAMatePostsDataList[index];
                                return FindAMateRow(
                                  findAMateId: findAMateData.id,
                                  description: findAMateData.description,
                                  title: findAMateData.title,
                                  fromDate: findAMateData.fromDate,
                                  toDate: findAMateData.toDate,
                                  fromTime: findAMateData.timeFrom,
                                  toTime: findAMateData.timeTo,
                                  hyperlinkText: findAMateData.hyperLinkText,
                                  hyperlink: findAMateData.hyperLink,
                                  user: findAMateData.user,
                                  createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(findAMateData.createdAt, true))}",
                                  rowIndex: index,
                                  isActive: findAMateData.isActive,
                                );
                              },
                            );
                          }else{
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                child: Text("No data found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

}

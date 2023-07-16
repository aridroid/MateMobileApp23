import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Model/beAMatePostsModel.dart';
import 'package:mate_app/Providers/beAMateProvider.dart';
import 'package:mate_app/Services/beAMateService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Widget/Home/Mate/beAMateRow.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';

class SearchBeAMate extends StatefulWidget {
  const SearchBeAMate({Key? key}) : super(key: key);

  @override
  _SearchBeAMateState createState() => _SearchBeAMateState();
}

class _SearchBeAMateState extends State<SearchBeAMate> {
  ThemeController themeController = Get.find<ThemeController>();
  late ScrollController _scrollController;
  late int _page;
  List<Result> _beAMatePostsDataList = [];
  TextEditingController _textEditingController = TextEditingController();
  Future<BeAMatePostsModel>? future;
  bool enterFutureBuilder = false;
  bool doingPagination = false;
  BeAMateService _beAMateService = BeAMateService();
  late BeAMateProvider beAMateProvider;
  String token = "";
  Timer? _throttle;

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

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp")!;
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
    future = _beAMateService.searchBeAMate(text: _textEditingController.text,page: _page,token: token);
    future!.then((value) {
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
                    FutureBuilder<BeAMatePostsModel>(
                      future: future,
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data!.success==true || doingPagination==true){
                            if(enterFutureBuilder){
                              if(doingPagination==false){
                                _beAMatePostsDataList.clear();
                              }
                              for(int i=0;i<snapshot.data!.data!.result!.length;i++){
                                _beAMatePostsDataList.add(snapshot.data!.data!.result![i]);
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
                              itemCount: _beAMatePostsDataList.length,
                              itemBuilder: (context,index){
                                Result beAMateData = _beAMatePostsDataList[index];
                                return BeAMateRow(
                                  beAMateId: beAMateData.id!,
                                  description: beAMateData.description!,
                                  title: beAMateData.title!,
                                  portfolioLink: beAMateData.portfolioLink,
                                  fromDate: beAMateData.fromDate,
                                  toDate: beAMateData.toDate,
                                  fromTime: beAMateData.timeFrom,
                                  toTime: beAMateData.timeTo,
                                  user: beAMateData.user!,
                                  hyperlinkText: beAMateData.hyperLinkText,
                                  hyperlink: beAMateData.hyperLink,
                                  createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(beAMateData.createdAt!, true))}",
                                  rowIndex: index,
                                  isActive: beAMateData.isActive!,
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

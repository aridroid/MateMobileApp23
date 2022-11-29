import 'dart:async';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/groupChat/helper/helper_functions.dart';
import 'package:mate_app/groupChat/pages/chat_page.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class AboutScreen extends StatefulWidget {
  static final String aboutScreenRoute = '/timeline';

  final String uuid;
  final bool authUser;
  final String userName;

  const AboutScreen({this.uuid, this.authUser = false, this.userName}) : super();

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  List<TextEditingController> _descriptions = [];
  List<String> _skills = [];
  Stream _groups;
  User _user;
  String firebaseUid;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<String> _skillsData = [
    "Adobe Suite",
    "After Effects",
    "Agile",
    "Android",
    "Angular JS",
    "Animation",
    "AWS",
    "Back-end Development",
    "C",
    "C#",
    "C++",
    "Caffe",
    "Casing",
    "Consulting",
    "Content Marketing",
    "CPA",
    "Dart",
    "D3.js",
    "Data Analytics",
    "Data Visualization",
    "Deep Learning",
    "DevOps",
    "Django",
    "Docker",
    "Excel",
    "Express.js",
    "Figma",
    "Financial Modeling",
    "Flask",
    "Flutter",
    "Front-end Development",
    "Full-stack Development",
    "Go",
    "Google Analytics",
    "Hadoop",
    "Haskell",
    "Illustration",
    "Infrastructure",
    "iOS",
    "Java",
    "JavaScript",
    "JIRA",
    "jQuery",
    "Keras",
    "Kotlin",
    "Kubernetes",
    "Leadership",
    "Machine Learning",
    "Management",
    "MATLAB",
    "Microsoft Excel",
    "Microsoft Word",
    " MongoDB",
    "Node.js",
    "NumPy",
    "pandas",
    "Perl",
    "Photoshop",
    "PHP",
    "PowerPoint",
    "Project Management",
    "Public Speaking",
    "Python",
    "PyTorch",
    "Quickbooks",
    "R",
    "React",
    "Research",
    "Ruby",
    "Ruby on Rails",
    "Rust",
    "Salesforce",
    "Scala",
    "scikit-learn",
    "Scrum",
    "SEO",
    "Sketch",
    "Social Media",
    "Spark",
    "SQL",
    "Strategy",
    "Swift",
    "Tableau",
    "TensorFlow",
    "Theano",
    "TypeScript",
    "Unity",
    "User Experience Design",
    "User Interface Design",
    "Vue.js",
    "Writing"
  ];

  List<String> _interestsData = [
    "Archery",
    "Baking",
    "Baseball",
    "Basketball",
    "Blog Writing",
    "Board Games",
    "Calligraphy",
    "Camping",
    "Chess",
    "Cooking",
    "Cycling",
    "Dancing",
    "Design",
    "Exploring new foods",
    "Exploring other cultures",
    "Fencing",
    "Football",
    "Gardening",
    "Golf",
    "Journaling",
    "Language Classes",
    "Languages",
    "Local Meetups",
    "Marathon running",
    "Mountain climbing",
    "Movies",
    "Music",
    "Musical instrument",
    "Networking events",
    "Painting",
    "Photography",
    "Public Speaking",
    "Puzzles",
    "Reading",
    "Singing",
    "Sketching",
    "Skiing",
    "Sports",
    "Stand-up comedy",
    "Swimming",
    "Tennis",
    "Theater",
    "Travel",
    "TV",
    "Volleyball",
    "Volunteering",
    "Writing",
    "Yoga"
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(widget.uuid);
      _user = FirebaseAuth.instance.currentUser;
      // _getUserAuthAndJoinedGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthUserProvider>(
      builder: (ctx, userProvider, _) {
        print("timeline consumer is called");
        if (userProvider.userAboutDataLoader) {
          return timelineLoader();
        }
        if (userProvider.error != '') {
          return Center(
              child: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${userProvider.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )));
        }
        if (!userProvider.userAboutDataLoader && userProvider.userAboutData != null) {
          var aboutData = userProvider.userAboutData.data;
          if(aboutData!=null) {
            firebaseUid = aboutData.user.firebaseUid;
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 2,
            padding: EdgeInsets.only(left: 35.0, right: 35.0),
            itemBuilder: (_, index) {
              return index == 0
                  ? userProvider.userAboutData.message=="User info loaded."
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _aboutRow("about", "About", aboutData.about),
                            aboutData.classes != null ? _profileDetailsRow("classes", "Classes", aboutData.classes) : SizedBox(),
                            aboutData.iCanHelpWith != null ? _profileDetailsRow("i_can_help_with", "I can help with...", aboutData.iCanHelpWith) : SizedBox(),
                            aboutData.iNeedHelpWith != null ? _profileDetailsRow("i_need_help_with", "I need help with...", aboutData.iNeedHelpWith) : SizedBox(),
                            aboutData.iNeedHelpWith != null ? _skillInterestDetailsRow("interests", "Interests", aboutData.interests) : SizedBox(),
                            aboutData.iNeedHelpWith != null ? _skillInterestDetailsRow("skills", "Skills", aboutData.skills) : SizedBox()
                          ],
                        )
                      : widget.authUser
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0, bottom: 20),
                                  child: Text(
                                    "Update your profile by clicking the icon below",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.5.sp,
                                      fontFamily: "Rubik",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () => detailsUpdateModalSheet("about", "About", []),
                                    iconSize: 40.0.sp,
                                    icon: Icon(
                                      Icons.add_circle_outline_sharp,
                                      color: Colors.white60,
                                    ))
                              ],
                            )
                          : Column(
                              // crossAxisAlignment: ,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0, bottom: 20, right: 20, left: 20),
                                  child: Text(
                                    "${widget.userName ?? "User"} hasn't updated their profile yet",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                      fontSize: 14.2.sp,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            )
                  : aboutData != null? groupsList():SizedBox();
            },
          );
        }
        return Container();
      },
    );
  }

  ///about and other details widgets------------------------------

  Widget _skillInterestDetailsRow(String key, String heading, List<String> data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Text(
            heading,
            style: TextStyle(
              color: Color(0xff75f3e7),
              fontSize: 15.0.sp,
            ),
          ),
          Spacer(),
          widget.authUser
              ? IconButton(
                  onPressed: () => (key == "skills") ? skillsUpdateModalSheet(key, heading, data, _skillsData) : skillsUpdateModalSheet(key, heading, data, _interestsData),
                  iconSize: 15.0.sp,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: MateColors.line,
                  ))
              : SizedBox(
                  height: 48,
                ),
        ]),
        (data.length == 1 && data[0] == "")
            ? widget.authUser
                ? InkWell(
                    onTap: () => (key == "skills") ? skillsUpdateModalSheet(key, heading, data, _skillsData) : skillsUpdateModalSheet(key, heading, data, _interestsData),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 0, left: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: MateColors.line, width: 1.5)),
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("add $heading".toUpperCase(), style: TextStyle(
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                              fontWeight: FontWeight.w400, fontSize: 10.0.sp)),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      "Details not added",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0.sp,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
            : ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.only(left: 10, right: 10),
                itemCount: data.length,
                itemBuilder: (context, index) => Text(
                  "• ${data[index]}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontSize: 13.3.sp,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _profileDetailsRow(String key, String heading, List<String> data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Text(
            heading,
            style: TextStyle(
              color: Color(0xff75f3e7),
              fontSize: 15.0.sp,
            ),
          ),
          Spacer(),
          widget.authUser
              ? IconButton(
                  onPressed: () => detailsUpdateModalSheet(key, heading, data),
                  iconSize: 18,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: MateColors.line,
                  ))
              : SizedBox(
                  height: 48,
                ),
        ]),
        (data.length == 1 && data[0] == "")
            ? Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Details not added",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontSize: 10.0.sp,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.only(left: 10, right: 10),
                itemCount: data.length,
                itemBuilder: (context, index) => Text(
                  "• ${data[index]}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontSize: 13.3.sp,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _aboutRow(String key, String heading, String about) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: <Widget>[
          Text(
            "About",
            style: TextStyle(
              color: Color(0xff75f3e7),
              fontSize: 15.0.sp,
            ),
          ),
          Spacer(),
          widget.authUser
              ? IconButton(
                  onPressed: () => detailsUpdateModalSheet(key, heading, [about]),
                  iconSize: 18,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: MateColors.line,
                  ))
              : SizedBox(
                  height: 48,
                ),
        ]),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: about != null
              ? Text(
                  about,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,//Color(0xffeeeeee),
                    fontSize: 14.6.sp,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w300,
                  ),
                )
              : Text(
                  "Say something about you",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontSize: 13.3.sp,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w300,
                  ),
                ),
        ),
      ],
    );
  }

  skillsUpdateModalSheet(String key, String heading, List<String> data, List<String> dropdownListData, {bool firstCheck = true}) {
    if (firstCheck) {
      _skills.clear();
      if (data.isNotEmpty) {
        List.generate(data.length, (index) => _skills.add(data[index]));
      } else {
        _skills.add("");
      }
      firstCheck = false;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: myHexColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Add $heading",
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 8.0, 10.0),
                    child: Text(
                      heading,
                      style: TextStyle(fontSize: 13.3.sp, color: MateColors.activeIcons),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: _skills.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                              decoration: BoxDecoration(
                                color: myHexColor,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: MateColors.line, width: 1),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: myHexColor,
                                  isExpanded: false,
                                  menuMaxHeight: MediaQuery.of(context).size.height - 200,
                                  value: _skills[index] != "" ? _skills[index] : null,
                                  hint: Text("Select $heading", style: TextStyle(color: Colors.white, fontSize: 12.5.sp)),
                                  items: dropdownListData.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    _skills[index] = newVal;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                          (_skills.length > 1)
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _skills.removeAt(index);
                                    });
                                  },
                                  padding: EdgeInsets.fromLTRB(2, 8, 0, 8),
                                  icon: Icon(
                                    Icons.remove_circle_outline_outlined,
                                    color: MateColors.activeIcons,
                                    size: 24,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  (_skills.length < 5)
                      ? Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Tap to add ",
                              style: TextStyle(fontSize: 14.2.sp, fontWeight: FontWeight.w400, color: Colors.white70),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _skills.add("");
                                });
                              },
                              padding: EdgeInsets.fromLTRB(2, 0, 0, 8),
                              icon: Icon(
                                Icons.add_circle_outline_sharp,
                                color: MateColors.activeIcons,
                                size: 20.0.sp,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 10,
                        ),
                  InkWell(
                    onTap: () async {
                      if (_skills.any((element) => element.trim().isEmpty)) {
                        Fluttertoast.showToast(msg: " Please Select all fields ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                      } else {
                        List<String> _data = [];
                        _skills.forEach((element) => _data.add(element.trim()));
                        _skills.any((element) => false);
                        Map<String, dynamic> _body = {
                          "uuid": widget.uuid,
                          "$key": _skills,
                        };
                        print(_body);
                        bool update = await Provider.of<AuthUserProvider>(context, listen: false).updateUserInfo(_body);

                        if (update) Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(widget.uuid);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 40.0,
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.transparent,
                                // offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 0)
                          ],
                          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.teal, MateColors.activeIcons])),
                      child: Text(
                        'Update $heading',
                        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  detailsUpdateModalSheet(String key, String heading, List<String> data, {bool firstCheck = true}) {
    if (firstCheck) {
      _descriptions.clear();
      if (data.isNotEmpty) {
        List.generate(data.length, (index) => _descriptions.add(TextEditingController(text: data[index])));
      } else {
        _descriptions.add(TextEditingController());
      }
      firstCheck = false;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: myHexColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Profile Update",
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 8.0, 10.0),
                    child: Text(
                      heading,
                      style: TextStyle(fontSize: 13.3.sp, color: MateColors.activeIcons),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: _descriptions.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(12, 13, 12, 13),
                                  isDense: true,
                                  counterStyle: TextStyle(color: Colors.grey),
                                  hintStyle: TextStyle(fontSize: key == "i_can_help_with" ? 10.0.sp : 12.5.sp, color: Colors.white70),
                                  hintText: key == "about"
                                      ? ' Ex: I am a current student who is passionate about.'
                                      : key == "i_can_help_with"
                                          ? 'Resume reviews, referrals to my current company, sharing mental health tips, major advice, cs tutoring, running errands'
                                          : key == "i_need_help_with"
                                              ? 'Major planning, planning a career pivot'
                                              : 'Tap to Write',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 0.3),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  border: InputBorder.none),
                              style: TextStyle(color: Colors.white, fontSize: 15.0.sp),
                              cursorColor: MateColors.activeIcons,
                              textInputAction: TextInputAction.newline,
                              minLines: key == "about" ? 3 : 1,
                              maxLines: key == "about" ? 5 : 2,
                              maxLength: key == "about" ? 200 : 60,
                              controller: _descriptions[index],
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                          (_descriptions.length > 1)
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _descriptions.removeAt(index);
                                    });
                                  },
                                  padding: EdgeInsets.fromLTRB(2, 8, 0, 8),
                                  icon: Icon(
                                    Icons.remove_circle_outline_outlined,
                                    color: MateColors.activeIcons,
                                    size: 24,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  (key != "about" && _descriptions.length < 5)
                      ? Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Tap to add ",
                              style: TextStyle(fontSize: 14.2.sp, fontWeight: FontWeight.w400, color: Colors.white70),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _descriptions.add(TextEditingController());
                                });
                              },
                              padding: EdgeInsets.fromLTRB(2, 0, 0, 8),
                              icon: Icon(
                                Icons.add_circle_outline_sharp,
                                color: MateColors.activeIcons,
                                size: 20.0.sp,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 10,
                        ),
                  InkWell(
                    onTap: () async {
                      if (_descriptions.any((element) => element.text.trim().isEmpty)) {
                        Fluttertoast.showToast(msg: " Please fill all fields ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                      } else if (key == "about") {
                        Map<String, dynamic> _body = {
                          "uuid": widget.uuid,
                          "$key": _descriptions[0].text.trim(),
                        };
                        bool update = await Provider.of<AuthUserProvider>(context, listen: false).updateUserInfo(_body);

                        if (update) Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(widget.uuid);
                        Navigator.pop(context);
                      } else {
                        List<String> _data = [];
                        _descriptions.forEach((element) => _data.add(element.text.trim()));
                        _descriptions.any((element) => false);
                        Map<String, dynamic> _body = {
                          "uuid": widget.uuid,
                          "$key": _data,
                        };
                        bool update = await Provider.of<AuthUserProvider>(context, listen: false).updateUserInfo(_body);

                        if (update) Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(widget.uuid);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 40.0,
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.transparent,
                                // offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 0)
                          ],
                          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.teal, MateColors.activeIcons])),
                      child: Text(
                        'Update',
                        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }


  ///-------------------------------------------------------------
  ///community group widgets--------------------------------------

  // _getUserAuthAndJoinedGroups() async {
  //   print("user id $firebaseUid");
  //   DatabaseService(uid: firebaseUid).getUserGroups().then((snapshots) {
  //     // print(snapshots);
  //     setState(() {
  //       _groups = snapshots;
  //     });
  //   });
  // }

  Widget groupsList() {

    return StreamBuilder(
      stream: DatabaseService(uid: firebaseUid).getUserGroups(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.data()['chat-group'] != null) {
            if (snapshot.data.data()['chat-group'].length != 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Communities",
                      style: TextStyle(fontFamily: "Poppins",fontSize: 17.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                  ),
                  ListView.builder(
                      itemCount: snapshot.data.data()['chat-group'].length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        int reqIndex = snapshot.data['chat-group'].length - index - 1;
                        return groupTile(
                            userName: _user.displayName,
                            groupId: _destructureId(snapshot.data['chat-group'][reqIndex]),
                            groupName: _destructureName(snapshot.data['chat-group'][reqIndex],
                            ));
                      }),
                ],
              );
            } else {
              return Text(
                "No communities Available",
                style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 10.0.sp),
              );
            }
          } else {
            return Text(
              "No communities Available",
              style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 10.0.sp),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res, {photoURL}) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  Widget groupTile({String userName, String groupId, String groupName, String photoURL}) {
    // _joinValueInGroup(userName, groupId, groupName, admin);
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService().getLastChatMessage(groupId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool _isJoined = snapshot.data["members"].contains(_user.uid + '_' + _user.displayName);
            int maxParticipant = snapshot.data["maxParticipantNumber"];
            int totalParticipant = snapshot.data["members"].length;
            return Visibility(
              visible: !widget.authUser
                  ? snapshot.data["isPrivate"] != null
                      ? snapshot.data["isPrivate"] == true
                          ? false
                          : true
                      : true
                  : true,
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 0, right: 0),
                leading: snapshot.data['groupIcon'] != ""
                    ? CircleAvatar(
                  radius: 24,
                  backgroundColor: MateColors.activeIcons,
                        backgroundImage: NetworkImage(snapshot.data['groupIcon']),
                      )
                    : CircleAvatar(
                  radius: 24,
                  backgroundColor: MateColors.activeIcons,
                        child: Text(snapshot.data['groupName'].substring(0, 1).toUpperCase(),
                            textAlign: TextAlign.center,
                          style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                title: Text(snapshot.data['groupName'],
                    style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        snapshot.data['recentMessageSender'] != ""
                            ? "${snapshot.data['recentMessageSender']}: ${snapshot.data['recentMessage']}"
                            : "Send first message to this group",
                        style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w100, color: Colors.grey[50]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: InkWell(
                  onTap: () async {
                    if (_isJoined) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(
                        groupId: groupId,
                        userName: userName,
                        groupName: groupName,
                        totalParticipant: totalParticipant.toString(),
                        photoURL: snapshot.data["groupIcon"],
                          memberList :  snapshot.data["members"],
                      )));
                    }
                    //else if (maxParticipant != null ? totalParticipant < maxParticipant : true)
                    else{
                      await DatabaseService(uid: _user.uid).groupJoin(groupId, groupName, userName);
                      // _showScaffold('Successfully joined the group "$groupName"');
                      Future.delayed(Duration(milliseconds: 100), () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName,totalParticipant: totalParticipant.toString(),photoURL: snapshot.data["groupIcon"],)));
                      });
                    }
                  },
                  child: _isJoined
                      ? Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          child: Text('Message', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 10.0.sp)),
                        )
                      : Visibility(
                          // maxParticipant != null ? totalParticipant < maxParticipant : true
                          visible: true,
                          replacement: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.transparent, width: 0.6)),
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Group Full', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 10.0.sp))),
                          child: Image.asset("lib/asset/homePageIcons/addIcon@3x.png",height: 18,width: 18,color: MateColors.activeIcons,),
                        ),
                ),
              ),
            );
          } else
            return Text("Loading groups...", style: TextStyle(fontSize: 10.9.sp));
        });
  }

  void _showScaffold(String message) {
    //_scaffoldKey.currentState.showSnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(milliseconds: 1500),
      content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.9.sp, color: MateColors.activeIcons)),
    ));
  }
}

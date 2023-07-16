import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Model/conncetionListingModel.dart';
import 'package:mate_app/Services/chatService.dart';
import 'package:mate_app/Services/connection_service.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widget/Loaders/Shimmer.dart';
import 'asset/Colors/MateColors.dart';



//Agora Project Name : Mate
//Agora App Certificate : 0bd25de6ff1c48e0ba71eadf5e734969
const APP_ID = "789013eabb9c4b2bada1bf76d5004247";
const Token = "007eJxTYEhd8O6Mycu164wFTK5/WDJb5mrT9pC2dRqsvZPqAp6nOF1VYDC3sDQwNE5NTEqyTDZJMkpKTEk0TEozN0sxNTAwMTIx//85PLk+kJHBbMMvFkYGCATxWRkyUnNy8hkYAAwXIlQ=";




List<Datum> connectionGlobalList = [];
List<String> connectionGlobalUidList = [];
ConnectionService _connectionService = ConnectionService();
List<ConnectionGetSentData> requestSent = [];
List<String> requestSentUid = [];
List<ConnectionGetSentData> requestGet = [];
List<String> requestGetUid = [];
List<String> requestGetUidSender = [];

Future<bool> getConnection()async{
  print("Global connection api calling");
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = preferences.getString("tokenApp")!;
  print(token);

  connectionGlobalList = await ConnectionService().getConnection(token: token);
  connectionGlobalUidList.clear();

  for(int i=0;i<connectionGlobalList.length;i++){
    connectionGlobalUidList.add(connectionGlobalList[i].uid!);
  }

  print("Global connection api calling done list is now");
  print(connectionGlobalList.length);
  print(connectionGlobalList);

  requestGet = await _connectionService.getConnectionRequestsGet(token: token);
  requestGetUid.clear();
  requestGetUidSender.clear();
  for(int i=0;i<requestGet.length;i++){
    requestGetUid.add(requestGet[i].connUid!);
    requestGetUidSender.add(requestGet[i].senderUid!);
  }
  print("Request Get length : $requestGet");

  requestSent = await _connectionService.getConnectionRequestsSent(token: token);
  requestSentUid.clear();
  for(int i=0;i<requestSent.length;i++){
    requestSentUid.add(requestSent[i].connUid!);
  }
  print("Request Sent length : $requestSent");

  return true;
}

late User _user;
void getMateSupportGroupDetails()async{
  _user = await FirebaseAuth.instance.currentUser!;
  Future<DocumentSnapshot>  data = DatabaseService().getMateGroupDetailsData("BzVXUBjbv1VBkgViOwJJ");
  data.then((value) async {
    print("------------------Mate group Details--------------------------");
    print(value["members"].contains(_user.uid + '_' + _user.displayName!));
    if(!value["members"].contains(_user.uid + '_' + _user.displayName!)){
      print("------------------Joining group--------------------------");
      await DatabaseService(uid: _user.uid).togglingGroupJoin(value["groupId"], value["groupName"].toString(), _user.displayName!);
      Map<String, dynamic> body = {"group_id": value["groupId"], "read_by": _user.uid, "messages_read": 0};
      Future.delayed(Duration.zero, () {
        ChatService().groupChatMessageReadUpdate(body);
        ChatService().groupChatDataFetch(_user.uid);
      });
    }
  });
}


final commonBorder = OutlineInputBorder(
  borderSide:  BorderSide(
    width: 0,
    color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
  ),
  borderRadius: BorderRadius.circular(14.0),
);

final commonBorderCircular = OutlineInputBorder(
  borderSide:  BorderSide(
    width: 0,
    //strokeAlign: StrokeAlign.inside,
    color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
  ),
  borderRadius: BorderRadius.circular(30.0),
);


void showEulaPopup(BuildContext context,String type){
  final scH = MediaQuery.of(context).size.height;
  final scW = MediaQuery.of(context).size.width;
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context){
      return Container(
        margin: EdgeInsets.symmetric(vertical: scH*0.1,horizontal: scW*0.03),
        padding: EdgeInsets.symmetric(vertical: scH*0.03,horizontal: scW*0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeController.isDarkMode?MateColors.bottomSheetBackgroundDark:MateColors.bottomSheetBackgroundLight,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('END USER LICENSE AGREEMENT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('This End-User License Agreement (this “EULA”) is a legal agreement between you (“Licensee”) and Mate - Your Virtual Campus! (“Licensor”), the author of Mate - Your Virtual Campus!, including all HTML files, XML files, Java files, graphics files, animation files, data files, technology, development tools, scripts and programs, both in object code and source code (the “Software”), the deliverables provided pursuant to this EULA, which may include associated media, printed materials, and “online” or electronic documentation.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('By installing, copying, or otherwise using the Software, Licensee agrees to be bound by the terms and conditions set forth in this EULA. If Licensee does not agree to the terms and conditions set forth in this EULA, then Licensee may not download, install, or use the Software.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("1. Grant of License \nA) Scope of License. Subject to the terms of this EULA, Licensor hereby grants to Licensee a royalty-free, non-exclusive license to possess and to use a copy of the Software.\nB) Installation and Use. Licensee may install and use an unlimited number of copies of the Software solely for Licensee's personal use.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("2. Description of Rights and Limitations\nA) Limitations. Licensee and third parties may not reverse engineer, decompile, or disassemble the Software, except and only to the extent that such activity is expressly permitted by applicable law notwithstanding the limitation.\nB) Update and Maintenance. Licensor shall provide updates and maintenance on the Software on an as needed basis.\nC) Separation of Components. The Software is licensed as a single product. Its components may not be separated for use on more than one computer.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('3. Title to Software. Licensor represents and warrants that it has the legal right to enter into and perform its obligations under this EULA, and that use by the Licensee of the Software, in accordance with the terms of this EULA, will not infringe upon the intellectual property rights of any third parties.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('4. Intellectual Property. All now known or hereafter known tangible and intangible rights, title, interest, copyrights and moral rights in and to the Software, including but not limited to all images, photographs, animations, video, audio, music, text, data, computer code, algorithms, and information, are owned by Licensor. The Software is protected by all applicable copyright laws and international treaties.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('5. No Support. Licensor has no obligation to provide support services for the Software.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('6. Duration. This EULA is perpetual or until:\nA) Automatically terminated or suspended if Licensee fails to comply with any of the terms and conditions set forth in this EULA; or\nB) Terminated or suspended by Licensor, with or without cause.\nIn the event this EULA is terminated, you must cease use of the Software and destroy all copies of the Software.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('7. Jurisdiction. This EULA shall be deemed to have been made in, and shall be construed pursuant to the laws of the State of California, without regard to conflicts of laws provisions thereof. Any legal action or proceeding relating to this EULA shall be brought exclusively in courts located in Berkeley , CA, and each party consents to the jurisdiction thereof. The prevailing party in any action to enforce this EULA shall be entitled to recover costs and expenses including, without limitation, attorneys’ fees. This EULA is made within the exclusive jurisdiction of the United States, and its jurisdiction shall supersede any other jurisdiction of either party’s election.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('8. Non-Transferable. This EULA is not assignable or transferable by Licensee, and any attempt to do so would be void.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('9. Severability. No failure to exercise, and no delay in exercising, on the part of either party, any privilege, any power or any rights hereunder will operate as a waiver thereof, nor will any single or partial exercise of any right or power hereunder preclude further exercise of any other right hereunder. If any provision of this EULA shall be adjudged by any court of competent jurisdiction to be unenforceable or invalid, that provision shall be limited or eliminated to the minimum extent necessary so that this EULA shall otherwise remain in full force and effect and enforceable.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('10.WARRANTY DISCLAIMER. LICENSOR, AND AUTHOR OF THE SOFTWARE, HEREBY EXPRESSLY DISCLAIM ANY WARRANTY FOR THE SOFTWARE. THE SOFTWARE AND ANY RELATED DOCUMENTATION IS PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. LICENSEE ACCEPTS ANY AND ALL RISK ARISING OUT OF USE OR PERFORMANCE OF THE SOFTWARE.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('11. LIMITATION OF LIABILITY. LICENSOR SHALL NOT BE LIABLE TO LICENSEE, OR ANY OTHER PERSON OR ENTITY CLAIMING THROUGH LICENSEE ANY LOSS OF PROFITS, INCOME, SAVINGS, OR ANY OTHER CONSEQUENTIAL, INCIDENTAL, SPECIAL, PUNITIVE, DIRECT OR INDIRECT DAMAGE, WHETHER ARISING IN CONTRACT, TORT, WARRANTY, OR OTHERWISE. THESE LIMITATIONS SHALL APPLY REGARDLESS OF THE ESSENTIAL PURPOSE OF ANY LIMITED REMEDY. UNDER NO CIRCUMSTANCES SHALL LICENSOR’S AGGREGATE LIABILITY TO LICENSEE, OR ANY OTHER PERSON OR ENTITY CLAIMING THROUGH LICENSEE, EXCEED THE FINANCIAL AMOUNT ACTUALLY PAID BY LICENSEE TO LICENSOR FOR THE SOFTWARE.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('12. Entire Agreement. This EULA constitutes the entire agreement between Licensor and Licensee and supersedes all prior understandings of Licensor and Licensee, including any prior representation, statement, condition, or warranty with respect to the subject matter of this EULA.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.none,
                        color: themeController.isDarkMode?Colors.white: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 40,
              width: scW*0.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: ()async{
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  if(type == "signup"){
                    preferences.setBool("signupEula", true);
                  }else{
                    preferences.setBool("home", true);
                  }
                  Navigator.of(context).pop();
                },
                child: Text('I Agree',
                  style: TextStyle(
                    color: MateColors.blackTextColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  );
}

final RegExp REGEX_EMOJI = RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

Widget buildEmojiAndText({required String content,required TextStyle textStyle,required double normalFontSize,required double emojiFontSize}) {
  final Iterable<Match> matches = REGEX_EMOJI.allMatches(content);
  if (matches.isEmpty)
    return Text(
      '$content',
      style: textStyle.copyWith(fontSize: normalFontSize),
    );

  return RichText(
      text: TextSpan(
          children: [
        for (var t in content.characters)
          TextSpan(
              text: t == '’'? "'" : t,
              style: textStyle.copyWith(fontSize: REGEX_EMOJI.allMatches(t).isNotEmpty && t != '’'? emojiFontSize : normalFontSize),
          ),
      ]));
}

String getFormattedDate(String date){
  final dateName = DateFormat('EEEE').format(DateFormat("DD MMMM yyyy").parse(date));
  return dateName.substring(0,3) + ", " + date.split(' ')[1].substring(0,3) + " " + date.split(' ').first;
}
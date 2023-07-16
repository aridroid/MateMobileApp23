// import 'package:mate_app/Utility/Utility.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'groupChatPage.dart';
//
// class GroupChatLandingPage extends StatefulWidget {
//   @override
//   _GroupChatLandingPageState createState() => _GroupChatLandingPageState();
// }
//
// class _GroupChatLandingPageState extends State<GroupChatLandingPage> {
//   TextEditingController person1Name=TextEditingController();
//   TextEditingController person2Name=TextEditingController();
//   TextEditingController person3Name=TextEditingController();
//   TextEditingController person4Name=TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: myHexColor ,
//       body: ListView(
//         padding: EdgeInsets.all(15),
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top:10.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     enableSuggestions: true,
//                     controller: person1Name,
//                     cursorColor: MateColors.activeIcons,
//                     style: TextStyle(color: MateColors.activeIcons ),
//                     decoration: InputDecoration(
//                       focusedBorder: OutlineInputBorder(
//                         borderSide:  BorderSide(width: 1.0, color: MateColors.activeIcons),
//                         borderRadius: const BorderRadius.all(
//                           const Radius.circular(5.0),
//                         ),
//                       ),
//                       enabledBorder:  OutlineInputBorder(
//                         borderSide:  BorderSide(width: 1.0, color: MateColors.activeIcons),
//                         borderRadius: const BorderRadius.all(
//                           const Radius.circular(5.0),
//                         ),
//                       ),
//                       hintText: "Name of Person 1",
//                       hintStyle: TextStyle(color: MateColors.activeIcons )
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: (){
//                     if(person1Name.text.trim()!=""){
//                       print(person1Name.text);
//                       Get.to(GroupChat(
//                         currentUserName:person1Name.text,
//                         currentUserId: "fAuYQW7x3eXvQwt3wzQ1hZFaw3o2" , //
//                         peerId: "A-B-C-D",
//                         peerName: "Mate Group",
//                         peerAvatar:  "lib/asset/profile.png",
//                       ));
//                     }
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 10),
//                     alignment: Alignment.center,
//                     height: 40,
//                     width: 100,
//                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: MateColors.activeIcons,
//                     ),
//                     child: Text(
//                       "Proceed",
//                       style: TextStyle(fontWeight: FontWeight.w500),
//
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top:10.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     enableSuggestions: true,
//                     controller: person2Name,
//                     cursorColor: MateColors.activeIcons,
//                     style: TextStyle(color: MateColors.activeIcons ),
//                     decoration: InputDecoration(
//                       focusedBorder: OutlineInputBorder(
//                         borderSide:  BorderSide(width: 1.0, color: MateColors.activeIcons),
//                         borderRadius: const BorderRadius.all(
//                           const Radius.circular(5.0),
//                         ),
//                       ),
//                       enabledBorder:  OutlineInputBorder(
//                         borderSide:  BorderSide(width: 1.0, color: MateColors.activeIcons),
//                         borderRadius: const BorderRadius.all(
//                           const Radius.circular(5.0),
//                         ),
//                       ),
//                       hintText: "Name of Person 2",
//                       hintStyle: TextStyle(color: MateColors.activeIcons )
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: (){
//                     if(person2Name.text.trim()!=""){
//                       print(person2Name.text);
//                       Get.to(GroupChat(
//                         currentUserName:person2Name.text,
//                         currentUserId:  "AI9zWQi7ATXibgL7Em6HqulKJCY2",
//                         peerId: "A-B-C-D",
//                         peerName: "Mate Group",
//                         peerAvatar:  "lib/asset/profile.png",
//                       ));
//                     }
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 10),
//                     alignment: Alignment.center,
//                     height: 40,
//                     width: 100,
//                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: MateColors.activeIcons,
//                     ),
//                     child: Text(
//                       "Proceed",
//                       style: TextStyle(fontWeight: FontWeight.w500),
//
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top:10.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     enableSuggestions: true,
//                     controller: person3Name,
//                     cursorColor: MateColors.activeIcons,
//                     style: TextStyle(color: MateColors.activeIcons ),
//                     decoration: InputDecoration(
//                       focusedBorder: OutlineInputBorder(
//                         borderSide:  BorderSide(width: 1.0, color: MateColors.activeIcons),
//                         borderRadius: const BorderRadius.all(
//                           const Radius.circular(5.0),
//                         ),
//                       ),
//                       enabledBorder:  OutlineInputBorder(
//                         borderSide:  BorderSide(width: 1.0, color: MateColors.activeIcons),
//                         borderRadius: const BorderRadius.all(
//                           const Radius.circular(5.0),
//                         ),
//                       ),
//                       hintText: "Name of Person 3",
//                       hintStyle: TextStyle(color: MateColors.activeIcons )
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: (){
//                     if(person3Name.text.trim()!=""){
//                       Get.to(GroupChat(
//                         currentUserName:person3Name.text,
//                         currentUserId: "OFhopwoOMtUhPCkmT204QeO9We42" ,
//                         peerId: "A-B-C-D",
//                         peerName: "Mate Group",
//                         peerAvatar:  "lib/asset/profile.png",
//                       ));
//                       print(person3Name.text);
//                     }
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 10),
//                     alignment: Alignment.center,
//                     height: 40,
//                     width: 100,
//                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: MateColors.activeIcons,
//                     ),
//                     child: Text(
//                       "Proceed",
//                       style: TextStyle(fontWeight: FontWeight.w500),
//
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top:10.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     enableSuggestions: true,
//                     controller: person4Name,
//                     cursorColor: MateColors.activeIcons,
//                     style: TextStyle(color: MateColors.activeIcons ),
//                     decoration: InputDecoration(
//                       focusedBorder: OutlineInputBorder(
//                         borderSide:  BorderSide(width: 1.0, color: MateColors.activeIcons),
//                         borderRadius: const BorderRadius.all(
//                           const Radius.circular(5.0),
//                         ),
//                       ),
//                       enabledBorder:  OutlineInputBorder(
//                         borderSide:  BorderSide(width: 1.0, color: MateColors.activeIcons),
//                         borderRadius: const BorderRadius.all(
//                           const Radius.circular(5.0),
//                         ),
//                       ),
//                       hintText: "Name of Person 4",
//                       hintStyle: TextStyle(color: MateColors.activeIcons )
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: (){
//                     if(person4Name.text.trim()!=""){
//                       Get.to(GroupChat(
//                         currentUserName:person4Name.text,
//                         currentUserId: "RvMLcwwBn9bH0OVUmDnbjVBHuT23" ,
//                         peerId: "A-B-C-D",
//                         peerName: "Mate Group",
//                         peerAvatar:  "lib/asset/profile.png",
//                       ));
//
//                       print(person4Name.text);
//                     }
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(left: 10),
//                     alignment: Alignment.center,
//                     height: 40,
//                     width: 100,
//                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: MateColors.activeIcons,
//                     ),
//                     child: Text(
//                       "Proceed",
//                       style: TextStyle(fontWeight: FontWeight.w500),
//
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
// }

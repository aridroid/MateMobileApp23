// import 'package:mate_app/Model/campusTalkPostsModel.dart';
// import 'package:mate_app/Providers/campusTalkProvider.dart';
// import 'package:mate_app/Utility/Utility.dart';
// import 'package:mate_app/Widget/Home/Community/campusTalkRow.dart';
// import 'package:mate_app/Widget/Loaders/Shimmer.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import '../HomeScreen.dart';
//
// class CampusTalkDetailsPage extends StatefulWidget {
//   final int talkId;
//
//   const CampusTalkDetailsPage({Key key, this.talkId}) : super(key: key);
//
//   @override
//   _CampusTalkDetailsPageState createState() => _CampusTalkDetailsPageState();
// }
//
// class _CampusTalkDetailsPageState extends State<CampusTalkDetailsPage> {
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 0), () {
//       Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostDetails(widget.talkId);
//     });
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: myHexColor,
//       appBar: AppBar(
//         backgroundColor: myHexColor,
//         title: Text("CampusLive Details", style: TextStyle(fontSize: 16.0.sp),),
//         leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,size: 24,),
//           onPressed: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(index: 0,))),),
//       ),
//       body: Consumer<CampusTalkProvider>(
//         builder: (ctx, campusTalkProvider, _) {
//           print("timline consumer is called");
//
//           if (campusTalkProvider.talkPostLoader && campusTalkProvider.campusTalkPostsResultsList.length == 0) {
//             return timelineLoader();
//           }
//           if (campusTalkProvider.error != '') {
//             return Center(
//                 child: Container(
//                     color: Colors.red,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         '${campusTalkProvider.error}',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )));
//           }
//
//           return campusTalkProvider.campusTalkPostsResultsList.length == 0
//               ? Center(
//             child: Text(
//               'Nothing new',
//               style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
//             ),
//           )
//               : ListView.builder(
//             shrinkWrap: true,
//             itemCount: campusTalkProvider.campusTalkPostsResultsList.length,
//             itemBuilder: (context, index) {
//               Result campusTalkData = campusTalkProvider.campusTalkPostsResultsList[index];
//               return CampusTalkRow(
//                 talkId: campusTalkData.id,
//                 description: campusTalkData.description,
//                 title: campusTalkData.title,
//                 user: campusTalkData.user,
//                 isAnonymous: campusTalkData.isAnonymous,
//                 anonymousUser: campusTalkData.anonymousUser,
//                 url: campusTalkData.url,
//                 createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(campusTalkData.createdAt, true))}",
//                 rowIndex: index,
//                 isBookmarked: campusTalkData.isBookmarked,
//                 isLiked: campusTalkData.isLiked,
//                 likesCount: campusTalkData.likesCount,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

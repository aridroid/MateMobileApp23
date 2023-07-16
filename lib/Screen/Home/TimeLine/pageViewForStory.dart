// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mate_app/Model/getStoryModel.dart';
// import 'package:mate_app/Services/FeedService.dart';
// import 'StoryPreviewScreen.dart';
//
// class PageViewForStory extends StatefulWidget {
//   final List<Result> storyList;
//   final int indexValue;
//   final int page;
//   const PageViewForStory({Key key, this.storyList, this.indexValue,this.page}) : super(key: key);
//
//   @override
//   _PageViewForStoryState createState() => _PageViewForStoryState();
// }
//
// class _PageViewForStoryState extends State<PageViewForStory> {
//   PageController controller;
//   List<Result> storyListLocal = [];
//   int page;
//   int indexValue;
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     storyListLocal.addAll(widget.storyList);
//     page = widget.page;
//     indexValue = widget.indexValue;
//     controller = PageController(initialPage: indexValue);
//     getStory();
//     super.initState();
//   }
//
//   getStory()async{
//     if(indexValue == storyListLocal.length-1){
//       Future.delayed(Duration.zero,()async{
//         page += 1;
//         print('scrolled to bottom page is now ${page}');
//         List<Result> list = await FeedService().getStoriesPagination(page);
//         if(list.isNotEmpty){
//           print("Story has data");
//           for(int i=0;i<list.length;i++){
//             storyListLocal.add(list[i]);
//           }
//           setState(() {});
//         }else{
//           print("Story has no data");
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView.builder(
//         controller: controller,
//         scrollDirection: Axis.vertical,
//         onPageChanged: (value){
//           if(indexValue == value-1){
//             Future.delayed(Duration.zero,()async{
//               page += 1;
//               print('scrolled to bottom page is now ${page}');
//               List<Result> list = await FeedService().getStoriesPagination(page);
//               if(list.isNotEmpty){
//                 print("Story has data");
//                 for(int i=0;i<list.length;i++){
//                   storyListLocal.add(list[i]);
//                 }
//                 setState(() {});
//               }else{
//                 print("Story has no data");
//               }
//             });
//           }
//         },
//         itemCount: storyListLocal.length,
//         itemBuilder: (context, index) {
//           return StoryPreviewScreen(
//             id: storyListLocal[index].id,
//             picUrl: storyListLocal[index].media[0],
//             displayName: "${storyListLocal[index].user.displayName.split(" ").first}",
//             message: storyListLocal[index].text,
//             user: storyListLocal[index].user,
//             displayPic: storyListLocal[index].user.profilePhoto,
//             created: "${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(storyListLocal[index].createdAt, true))}",
//           );
//         },
//       ),
//     );
//   }
// }

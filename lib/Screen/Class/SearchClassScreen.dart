// import 'dart:convert';
//
// import 'package:mate_app/Model/UserClass.dart';
// import 'package:mate_app/Providers/UserClassProvider.dart';
// import 'package:mate_app/Services/APIService.dart';
// import 'package:mate_app/Services/BackEndAPIRoutes.dart';
// import 'package:mate_app/Utility/Utility.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
//
// class SearchClassScreen extends StatefulWidget {
//   static final String routeName = "/search-classes";
//
//   @override
//   _SearchClassScreenState createState() => _SearchClassScreenState();
// }
//
// class _SearchClassScreenState extends State<SearchClassScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   final _formKey = GlobalKey<FormState>();
//   final _apiService = APIService();
//   final _backednRoutes = BackEndAPIRoutes();
//
//   String _searchText = "";
//   int _semesterIndex = 0;
//   String _year = "";
//   bool _loading = false;
//
//   List<String> _semesters = ["Summer", "Spring", "Fall"];
//
//   List<UserClass> _searchResults = [];
//
//   Future<void> _searchClasses() async {
//     setState(() {
//       _loading = true;
//     });
//     _searchResults = [];
//
//     Map<String, dynamic> queryParams = {
//       "search": _searchText,
//       "semester": _semesters[_semesterIndex],
//       "year": _year,
//       "per_page": "all"
//     };
//
//     print(
//         "fetching from ${_backednRoutes.classSearch(queryParams).toString()}");
//
//     try {
//       var response =
//           await _apiService.get(uri: _backednRoutes.classSearch(queryParams));
//
//       var rawData = jsonDecode(response.body)["data"]["data"];
//
//       for (int i = 0; i < rawData.length; i++) {
//         _searchResults.add(UserClass.fromJson(rawData[i]));
//       }
//     } catch (error) {
//       print('Error Occurred $error');
//     } finally {
//       print('Done fetching ${_searchResults.length}');
//       setState(() {
//         _loading = false;
//       });
//     }
//   }
//
//   Widget _searchForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: 12,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: TextFormField(
//               decoration: _customInputDecoration(
//                 labelText: 'Search Classes',
//                 icon: Icons.search,
//               ),
//               style: TextStyle(color: Colors.white, fontSize: 18.0),
//               cursorColor: Colors.cyanAccent,
//               textInputAction: TextInputAction.done,
//               maxLength: 100,
//               onFieldSubmitted: (val) {
//                 print('onFieldSubmitted :: title = $val');
//               },
//               onSaved: (value) {
//                 print('onSaved title = $value');
//                 _searchText = value;
//               },
//               validator: (value) {
//                 if (value.length < 4) {
//                   return "Search Text Must be at least 4 character long";
//                 }
//                 return null; //returning null means no error occurred. if there are any error then simply return a string
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Expanded(
//                   child: TextFormField(
//                     initialValue: DateTime.now().year.toString(),
//                     decoration: _customInputDecoration(
//                       labelText: 'Year',
//                       icon: Icons.calendar_today,
//                     ),
//                     style: TextStyle(color: Colors.white, fontSize: 18.0),
//                     cursorColor: Colors.cyanAccent,
//                     keyboardType: TextInputType.number,
//                     textInputAction: TextInputAction.done,
//                     maxLength: 4,
//                     onFieldSubmitted: (val) {
//                       print(
//                           'onFieldSubmitted :: year = $val ${val.runtimeType}');
//                     },
//                     onSaved: (value) {
//                       print('onSaved title = $value');
//                       _year = value;
//                     },
//                     validator: (value) {
//                       if (value.length != 4) {
//                         return "Invalid Year";
//                       }
//                       return null; //returning null means no error occurred. if there are any error then simply return a string
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   width: 12,
//                 ),
//                 Expanded(
//                   child: InkWell(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.cyan,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(22.0),
//                           child: Center(
//                             child: Text(
//                               "${_semesters[_semesterIndex]}",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                       ),
//                       onTap: () {
//                         int nextSemesterIndex = _semesterIndex + 1;
//                         if (nextSemesterIndex == _semesters.length) {
//                           nextSemesterIndex = 0;
//                           setState(() {
//                             _semesterIndex = nextSemesterIndex;
//                           });
//                         }
//
//                         setState(() {
//                           _semesterIndex = nextSemesterIndex;
//                         });
//                       }),
//                 )
//               ],
//             ),
//           ),
//           _searchButton(),
//           Divider(
//             color: Colors.cyan,
//           ),
//         ],
//       ),
//     );
//   }
//
//   InkWell _searchButton() {
//     return InkWell(
//       child: Padding(
//         padding: const EdgeInsets.all(22.0),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.cyan,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Text(
//                 "Search",
//                 style:
//                     TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//       ),
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         bool validated = _formKey.currentState.validate();
//         if (validated) {
//           _formKey.currentState.save();
//           //it will trigger a onSaved(){} method
//           _searchClasses();
//         }
//       },
//     );
//   }
//
//   InputDecoration _customInputDecoration(
//       {@required String labelText, IconData icon}) {
//     return InputDecoration(
//       counterStyle: TextStyle(color: Colors.grey),
//       labelStyle: TextStyle(fontSize: 16.0, color: Colors.cyan),
//       labelText: labelText,
//       prefixIcon: Icon(
//         icon,
//         color: Colors.cyan,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.white, width: 0.3),
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: myHexColor,
//       appBar: AppBar(
//         title: Text('Search Class'),
//       ),
//       body: SingleChildScrollView(
//         physics: ScrollPhysics(),
//         child: Column(
//           children: <Widget>[
//             _searchForm(),
//             Text(
//               "${_searchResults.length} Search Results",
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: _loading
//                   ? LinearProgressIndicator()
//                   : ListView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: _searchResults.length,
//                       itemBuilder: (context, index) {
//                         return _listItem(_searchResults[index], index);
//                       }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _listItem(UserClass userClass, int index) {
//     return Column(
//       children: <Widget>[
//         ListTile(
//           leading: CircleAvatar(
//             child: Text(
//               "${index + 1}",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           title: Text(
//             userClass.title,
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text(
//             userClass.identifier,
//             style: TextStyle(color: Colors.grey),
//           ),
//           trailing: IconButton(
//             color: Colors.amber,
//             icon: Icon(
//               Icons.add,
//               size: 20,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               _addClassDialog(userClass);
//             },
//           ),
//         ),
//         Divider(
//           color: MateColors.activeIcons,
//         )
//       ],
//     );
//   }
//
//   Future<void> _addClassDialog(UserClass userClass) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: new Text("Are you sure?"),
//           content: new Text(
//               "You want to join class ${userClass.title}, (${userClass.identifier}) of ${_semesters[_semesterIndex]} $_year? (you can change the year/semster from above)"),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               child: Text("Yes"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Provider.of<UserClassProvider>(context, listen: false)
//                     .joinClass(
//                   courseId: userClass.id,
//                   semester: _semesters[_semesterIndex],
//                   year: int.parse(_year),
//                 )
//                     .then((value) {
//                   print('then method called');
//                   var sb = SnackBar(
//                     content: Text(
//                         'Joined Class ${userClass.title}, (${userClass.identifier})'),
//                     action: SnackBarAction(
//                       label: 'Ok',
//                       onPressed: () {
//                         // Some code to undo the change.
//                       },
//                     ),
//                   );
//
//                   ScaffoldMessenger.of(context).showSnackBar(sb);
//                 });
//               },
//             ),
//             CupertinoDialogAction(
//                 child: Text("No"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 })
//           ],
//         );
//       },
//     );
//   }
// }

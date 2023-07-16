// import 'package:mate_app/Providers/UserClassProvider.dart';
// import 'package:mate_app/Utility/Utility.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class AddAssignmentScreen extends StatefulWidget {
//   static final String routeName = '/add-assignment';
//
//   @override
//   _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
// }
//
// class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   final _formKey = GlobalKey<FormState>();
//
//   String _title;
//   String _dueDate;
//   // ignore: unused_field
//   bool _loading = false;
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
//     final routeArgs =
//         ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
//
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: myHexColor,
//       appBar: AppBar(
//         title: Text(
//           'Add Assignment',
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 12,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                 child: TextFormField(
//                   decoration: _customInputDecoration(
//                     labelText: 'Assignment Name',
//                     icon: Icons.title,
//                   ),
//                   style: TextStyle(color: Colors.white, fontSize: 18.0),
//                   cursorColor: Colors.cyanAccent,
//                   textInputAction: TextInputAction.done,
//                   maxLength: 100,
//                   onFieldSubmitted: (val) {
//                     print('onFieldSubmitted :: title = $val');
//                   },
//                   onSaved: (value) {
//                     print('onSaved title = $value');
//                     _title = value;
//                   },
//                   validator: (value) {
//                     if (value.length == 0) {
//                       return "Title Cannot Be Empty";
//                     }
//                     return null; //returning null means no error occurred. if there are any error then simply return a string
//                   },
//                 ),
//               ),
//               Text(
//                 "Select Due Date:",
//                 style: TextStyle(color: Colors.cyan),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: SizedBox(
//                   height: 250,
//                   child: CupertinoDatePicker(
//                     backgroundColor: Colors.white,
//                     initialDateTime: DateTime.now(),
//                     onDateTimeChanged: (val) {
//                       print("${val.toString()}");
//                       _dueDate = val.toString();
//                     },
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 30.0),
//                 child: ButtonTheme(
//                   minWidth: MediaQuery.of(context).size.width - 40,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.grey.withOpacity(0.5),
//                     ),
//                     // color: Colors.cyan,
//                     child: Text(
//                       'Add Assignment',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     onPressed: () {
//                       _submitAssignment(context, routeArgs);
//                     },
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _submitAssignment(BuildContext context, routeArgs) async {
//     FocusScope.of(context).unfocus();
//     bool validated = _formKey.currentState.validate();
//
//     if (validated) {
//       _formKey.currentState
//           .save(); //it will trigger a onSaved(){} method on all TextEditingController();
//
//       setState(() {
//         _loading = true;
//       });
//
//       var updated = await Provider.of<UserClassProvider>(context, listen: false)
//           .addAssignment(
//               classId: routeArgs["class_id"], name: _title, dueDate: _dueDate);
//
//       setState(() {
//         _loading = false;
//       });
//
//       if (updated) {
//         var sb = SnackBar(
//           content: Text('Assignment Added'),
//           action: SnackBarAction(
//             label: 'Ok',
//             onPressed: () {
//               // Some code to undo the change.
//             },
//           ),
//         );
//
//         ScaffoldMessenger.of(context).showSnackBar(sb);
//         Navigator.of(context).pop();
//         Navigator.of(context).pop();
//       } else {
//         //
//       }
//     }
//   }
// }

// import 'package:mate_app/Providers/AuthUserProvider.dart';
// import 'package:mate_app/Utility/Utility.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
//
// class ProfileEditScreen extends StatefulWidget {
//   static final String profileEditRouteName = '/profile-edit';
//
//   @override
//   _ProfileEditScreenState createState() => _ProfileEditScreenState();
// }
//
// class _ProfileEditScreenState extends State<ProfileEditScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   String _firstName;
//   String _lastName;
//   String _displayName;
//   String _phoneNumber;
//   String _about;
//   String _societies;
//   String _achievements;
//
//   TextEditingController _firstNameController = TextEditingController();
//   TextEditingController _lastNameController = TextEditingController();
//   TextEditingController _displayNameController = TextEditingController();
//   TextEditingController _phoneNumberController = TextEditingController();
//   TextEditingController _aboutController = TextEditingController();
//   TextEditingController _societiesController = TextEditingController();
//   TextEditingController _achievementsController = TextEditingController();
//
//   //focus nodes
//   FocusNode _lastNameFocusNode = FocusNode();
//   FocusNode _displayNameFocusNode = FocusNode();
//
//   FocusNode _phoneFocusNode = FocusNode();
//   FocusNode _aboutFocusNode = FocusNode();
//   FocusNode _societiesFocusNode = FocusNode();
//   FocusNode _achievementsFocusNode = FocusNode();
//
//   FocusNode focusNode= FocusNode();
//
//
//   // ignore: todo
//   //TODO::add app side validation
//
//   @override
//   void initState() {
//     focusNode.requestFocus();
//
//     Future.delayed(Duration(seconds: 0), () {
//       var user = Provider.of<AuthUserProvider>(context, listen: false);
//
//       _firstNameController.text = user.authUser.firstName;
//       _lastNameController.text = user.authUser.lastName;
//       _displayNameController.text = user.authUser.displayName;
//
//       _phoneNumberController.text = user.authUser.phoneNumber;
//       _aboutController.text = user.authUser.about;
//       _societiesController.text = user.authUser.societies;
//       _achievementsController.text = user.authUser.achievements;
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _displayNameController.dispose();
//
//     _phoneNumberController.dispose();
//     _aboutController.dispose();
//     _societiesController.dispose();
//     _achievementsController.dispose();
//
//     _lastNameFocusNode.dispose();
//     _displayNameFocusNode.dispose();
//     _phoneFocusNode.dispose();
//     _aboutFocusNode.dispose();
//     _societiesFocusNode.dispose();
//     _achievementsFocusNode.dispose();
//     focusNode.dispose();
//
//     super.dispose();
//   }
//
//   void _update(BuildContext context) async {
//     FocusScope.of(context).unfocus();
//     bool validated = _formKey.currentState.validate();
//
//     if (validated) {
//       _formKey.currentState
//           .save(); //it will trigger a onSaved(){} method on all TextEditingController();
//
//       bool updated = await Provider.of<AuthUserProvider>(context, listen: false)
//           .updateUserProfile(
//               firstName: _firstName,
//               lastName: _lastName,
//               displayName: _displayName,
//               phoneNumber: _phoneNumber,
//               about: _about,
//               achievements: _achievements,
//               societies: _societies);
//
//       if (updated) {
//         Navigator.of(context).pop();
//       } else {
//         //
//       }
//     }
//   }
//
//   InputDecoration _customInputDecoration(
//       {@required String labelText, IconData icon}) {
//     return InputDecoration(
//       labelStyle: TextStyle(fontSize: 16.0, color: MateColors.activeIcons),
//       labelText: labelText,
//       prefixIcon: Icon(
//         icon,
//         color: MateColors.activeIcons,
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
//       appBar: AppBar(
//         backgroundColor: myHexColor,
//         title: Text('Edit Profile', style: TextStyle(fontSize: 16.0.sp)),
//         actions: [
//           Consumer<AuthUserProvider>(
//             builder: (ctx, authUserProvider, _) {
//               if (authUserProvider.profileUpdateLoaderStatus) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: NutsActivityIndicator(
//                     radius: 10,
//                     activeColor: Colors.indigo,
//                     inactiveColor: Colors.red,
//                     tickCount: 11,
//                     startRatio: 0.55,
//                     animationDuration: Duration(seconds: 2),
//                   ),
//                 );
//               }
//
//               return IconButton(
//                 icon: Icon(Icons.save),
//                 color: MateColors.activeIcons,
//                 onPressed: () {
//                   _update(context);
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       backgroundColor: myHexColor,
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Selector<AuthUserProvider, String>(
//                 builder: (ctx, error, _) {
//                   if (error.length > 0) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                           color: Colors.red,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               "$error",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           )),
//                     );
//                   }
//                   return SizedBox.shrink();
//                 },
//                 selector: (ctx, authUserProvider) => authUserProvider.error,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: _firstNameController,
//                   focusNode: focusNode,
//
//                   //initialValue: _initialFirstName,
//                   decoration: _customInputDecoration(
//                       labelText: 'First Name', icon: Icons.perm_identity),
//                   style: TextStyle(color: Colors.white, fontSize: 18.0),
//                   cursorColor: MateColors.activeIcons,
//                   textInputAction: TextInputAction.next,
//                   onFieldSubmitted: (val) {
//                     print('onFieldSubmitted :: FirstName = $val');
//                     FocusScope.of(context).requestFocus(_lastNameFocusNode);
//                   },
//                   onSaved: (value) {
//                     print('onSaved first name = $value');
//                     _firstName = value;
//                   },
//                   validator: (value) {
//                     return null; //returning null means no error occurred. if there are any error then simply return a string
//                   },
//                 ),
//               ),
//               Consumer<AuthUserProvider>(
//                 builder: (ctx, authUserProvider, _) {
//                   if (authUserProvider.validationErrors
//                       .containsKey('first_name')) {
//                     return Text(
//                       "${authUserProvider.validationErrors['first_name'][0].toString()}",
//                       style: TextStyle(color: Colors.red),
//                     );
//                   }
//                   return SizedBox.shrink();
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: _lastNameController,
//                   focusNode: _lastNameFocusNode,
//                   decoration: _customInputDecoration(
//                       labelText: 'Last Name', icon: Icons.perm_identity),
//                   style: TextStyle(color: Colors.white, fontSize: 18.0),
//                   cursorColor: MateColors.activeIcons,
//                   textInputAction: TextInputAction.next,
//                   onFieldSubmitted: (val) {
//                     print('onFieldSubmitted :: LastName = $val');
//                     FocusScope.of(context).requestFocus(_displayNameFocusNode);
//                   },
//                   onSaved: (value) {
//                     print('onSaved lastName = $value');
//                     _lastName = value;
//                   },
//                   validator: (value) {
//                     return null;
//                   },
//                 ),
//               ),
//               Consumer<AuthUserProvider>(
//                 builder: (ctx, authUserProvider, _) {
//                   if (authUserProvider.validationErrors
//                       .containsKey('last_name')) {
//                     return Text(
//                       "${authUserProvider.validationErrors['last_name'][0].toString()}",
//                       style: TextStyle(color: Colors.red),
//                     );
//                   }
//                   return SizedBox.shrink();
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: _displayNameController,
//                   focusNode: _displayNameFocusNode,
//                   decoration: _customInputDecoration(
//                       labelText: 'Display Name', icon: Icons.tv),
//                   style: TextStyle(color: Colors.white, fontSize: 18.0),
//                   cursorColor: MateColors.activeIcons,
//                   textInputAction: TextInputAction.next,
//                   onFieldSubmitted: (val) {
//                     print('onFieldSubmitted :: DisplayName = $val');
//                     FocusScope.of(context).requestFocus(_phoneFocusNode);
//                   },
//                   onSaved: (value) {
//                     print('onSaved displayName = $value');
//                     _displayName = value;
//                   },
//                   validator: (value) {
//                     return null;
//                   },
//                 ),
//               ),
//               Consumer<AuthUserProvider>(
//                 builder: (ctx, authUserProvider, _) {
//                   if (authUserProvider.validationErrors
//                       .containsKey('display_name')) {
//                     return Text(
//                       "${authUserProvider.validationErrors['display_name'][0].toString()}",
//                       style: TextStyle(color: Colors.red),
//                     );
//                   }
//                   return SizedBox.shrink();
//                 },
//               ),
//               /*Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: _phoneNumberController,
//                   focusNode: _phoneFocusNode,
//                   decoration: _customInputDecoration(
//                       labelText: 'Phone Number', icon: Icons.phone),
//                   style: TextStyle(color: Colors.white, fontSize: 18.0),
//                   cursorColor: MateColors.activeIcons,
//                   textInputAction: TextInputAction.next,
//                   onFieldSubmitted: (val) {
//                     print('onFieldSubmitted :: Phone = $val');
//                     FocusScope.of(context).requestFocus(_aboutFocusNode);
//                   },
//                   onSaved: (value) {
//                     print('onSaved phone = $value');
//                     _phoneNumber = value;
//                   },
//                   validator: (value) {
//                     return null;
//                   },
//                 ),
//               ),
//               Consumer<AuthUserProvider>(
//                 builder: (ctx, authUserProvider, _) {
//                   if (authUserProvider.validationErrors
//                       .containsKey('phone_number')) {
//                     return Text(
//                       "${authUserProvider.validationErrors['phone_number'][0].toString()}",
//                       style: TextStyle(color: Colors.red),
//                     );
//                   }
//                   return SizedBox.shrink();
//                 },
//               ),*/
//
//
//               /*Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   minLines: 3,
//                   maxLines: 6,
//                   controller: _aboutController,
//                   focusNode: _aboutFocusNode,
//                   decoration: _customInputDecoration(
//                       labelText: 'About', icon: Icons.edit),
//                   style: TextStyle(color: Colors.white, fontSize: 18.0),
//                   cursorColor: MateColors.activeIcons,
//                   textInputAction: TextInputAction.next,
//                   onFieldSubmitted: (val) {
//                     print('onFieldSubmitted :: About = $val');
//                     FocusScope.of(context).requestFocus(_achievementsFocusNode);
//                   },
//                   onSaved: (value) {
//                     print('onSaved about = $value');
//                     _about = value;
//                   },
//                   validator: (value) {
//                     return null;
//                   },
//                 ),
//               ),
//               Consumer<AuthUserProvider>(
//                 builder: (ctx, authUserProvider, _) {
//                   if (authUserProvider.validationErrors.containsKey('about')) {
//                     return Text(
//                       "${authUserProvider.validationErrors['about'][0].toString()}",
//                       style: TextStyle(color: Colors.red),
//                     );
//                   }
//                   return SizedBox.shrink();
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   minLines: 3,
//                   maxLines: 6,
//                   controller: _achievementsController,
//                   focusNode: _achievementsFocusNode,
//                   decoration: _customInputDecoration(
//                       labelText: 'Achievements', icon: Icons.star_border),
//                   style: TextStyle(color: Colors.white, fontSize: 18.0),
//                   cursorColor: MateColors.activeIcons,
//                   textInputAction: TextInputAction.next,
//                   onFieldSubmitted: (val) {
//                     print('onFieldSubmitted :: Achievements = $val');
//                     FocusScope.of(context).requestFocus(_societiesFocusNode);
//                   },
//                   onSaved: (value) {
//                     print('onSaved achievements = $value');
//                     _achievements = value;
//                   },
//                   validator: (value) {
//                     return null;
//                   },
//                 ),
//               ),
//               Consumer<AuthUserProvider>(
//                 builder: (ctx, authUserProvider, _) {
//                   if (authUserProvider.validationErrors
//                       .containsKey('achievements')) {
//                     return Text(
//                       "${authUserProvider.validationErrors['achievements'][0].toString()}",
//                       style: TextStyle(color: Colors.red),
//                     );
//                   }
//                   return SizedBox.shrink();
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: _societiesController,
//                   focusNode: _societiesFocusNode,
//                   minLines: 3,
//                   maxLines: 6,
//                   decoration: _customInputDecoration(
//                       labelText: 'Societies', icon: Icons.share),
//                   style: TextStyle(color: Colors.white, fontSize: 18.0),
//                   cursorColor: MateColors.activeIcons,
//                   textInputAction: TextInputAction.done,
//                   onFieldSubmitted: (val) {
//                     print('onFieldSubmitted :: Societies = $val');
//                   },
//                   onSaved: (value) {
//                     print('onSaved societies = $value');
//                     _societies = value;
//                   },
//                   validator: (value) {
//                     return null;
//                   },
//                 ),
//               ),
//               Consumer<AuthUserProvider>(
//                 builder: (ctx, authUserProvider, _) {
//                   if (authUserProvider.validationErrors
//                       .containsKey('societies')) {
//                     return Text(
//                       "${authUserProvider.validationErrors['societies'][0].toString()}",
//                       style: TextStyle(color: Colors.red),
//                     );
//                   }
//                   return SizedBox.shrink();
//                 },
//               ),*/
//               // Container(
//               //   decoration: BoxDecoration(
//               //     color: myHexColor,
//               //     border: Border(top: BorderSide(color: MateColors.line, width: 2.0)),
//               //   ),
//               //   child: DropdownButtonHideUnderline(
//               //     child: DropdownButton<String>(
//               //       dropdownColor: myHexColor,
//               //       // value: _selectedSkills,
//               //       hint: Text("Select Skills", style: TextStyle(color: Colors.white)),
//               //       items: skills.map((String value) {
//               //         return DropdownMenuItem<String>(
//               //           value: value,
//               //           child: Text(value,style: TextStyle(color: Colors.white),),
//               //         );
//               //       }).toList(),
//               //       onChanged: (newVal) {
//               //
//               //       },
//               //     ),
//               //   ),
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

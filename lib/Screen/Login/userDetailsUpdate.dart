import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:flutter/material.dart';

class UserDetailsUpdate extends StatefulWidget {
  const UserDetailsUpdate({Key key}) : super(key: key);

  @override
  _UserDetailsUpdateState createState() => _UserDetailsUpdateState();
}

class _UserDetailsUpdateState extends State<UserDetailsUpdate> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController _userName = new TextEditingController();
  TextEditingController _userPhoneNumber = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myHexColor,
      body: Form(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(16,10,16,0),
          children: [
            Text("Your Virtual Campus",style: TextStyle(fontSize: 16,color: MateColors.activeIcons),textAlign: TextAlign.center,),
            SizedBox(height: 40,),
            Image.asset(
              "lib/asset/logo.png",
              //color: Colors.white,
              width: 30,
              height: 30,
            ),
            SizedBox(height: 45,),
            TextFormField(
              decoration: _customInputDecoration(
                  labelText: 'Username', icon: Icons.person_outline),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              cursorColor: Colors.cyanAccent,
              textInputAction: TextInputAction.next,
              controller: _userName,
              validator: (value) {
                return value.isEmpty ? "*Username Required" : null; //returning null means no error occurred. if there are any error then simply return a string
              },
            ),
            SizedBox(height: 15,),
            TextFormField(
              decoration: _customInputDecoration(
                  labelText: 'phone', icon: Icons.phone_iphone_rounded),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              cursorColor: Colors.cyanAccent,
              textInputAction: TextInputAction.done,
              maxLength: 10,
              controller: _userName,
              validator: (value) {
                return value.isEmpty ? "*phone no. Required" : null; //returning null means no error occurred. if there are any error then simply return a string
              },
            ),
            SizedBox(height: 25,),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width - 40,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: MateColors.activeIcons,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(15.0),
                // ),
                // color: MateColors.activeIcons,
                child: Text(
                  'Proceed',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _submitForm(context);
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    FocusScope.of(context).unfocus();
    bool validated = _formKey.currentState.validate();

    if (validated) {
      _formKey.currentState.save(); //it will trigger a onSaved(){} method on all TextEditingController();

    }
  }

  InputDecoration _customInputDecoration(
      {@required String labelText, IconData icon}) {
    return InputDecoration(
      counterStyle: TextStyle(color: Colors.grey),
      labelStyle: TextStyle(fontSize: 16.0, color: MateColors.activeIcons),
      labelText: labelText,
      prefixIcon: Icon(
        icon,
        color: MateColors.activeIcons,
        // size: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 0.3),
        borderRadius: BorderRadius.circular(15.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 0.3),
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}

import 'package:mate_app/Providers/reportProvider.dart';
import 'package:mate_app/Screen/Home/HomeScreen.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserReportPage extends StatefulWidget {
  final String uuid;

  const UserReportPage({Key? key, required this.uuid}) : super(key: key);

  @override
  _UserReportPageState createState() => _UserReportPageState();
}

class _UserReportPageState extends State<UserReportPage> {

  TextEditingController _title = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myHexColor,
        title: Text('Report', style: TextStyle(fontSize: 16.0.sp)),
      ),
      backgroundColor: myHexColor,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15.0),

          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Report this user",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: MateColors.activeIcons),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
              child: Text(
                "Title",
                style: TextStyle(fontSize: 16, color: MateColors.activeIcons),
              ),
            ),
            TextFormField(
              maxLength: 50,
              decoration: _customInputDecoration(labelText: "Title"),
              style: TextStyle(color: Colors.white, fontSize: 16.0),
              cursorColor: Colors.cyanAccent,
              textInputAction: TextInputAction.next,
              controller: _title,
              validator: (value) {
                return value!.isEmpty ? "*title is required" : null; //returning null means no error occurred. if there are any error then simply return a string
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 10.0),
              child: Text(
                "Report Reasons",
                style: TextStyle(fontSize: 16, color: MateColors.activeIcons),
              ),
            ),
            TextFormField(
              minLines: 2,
              maxLines: 4,
              maxLength: 256,
              decoration: _customInputDecoration(labelText: "Details"),
              style: TextStyle(color: Colors.white, fontSize: 15.0),
              cursorColor: Colors.cyanAccent,
              textInputAction: TextInputAction.done,
              controller: _description,
              validator: (value) {
                return value!.isEmpty ? "*description is required" : null; //returning null means no error occurred. if there are any error then simply return a string
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width - 40,
              height: 45,
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
                  'Report Inappropriate User',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  Map<String, dynamic> body = {
                    "user_uuid": widget.uuid
                  };
                  if(_title.text.trim().isNotEmpty){
                    body['title']= _title.text.trim();
                  }else if(_description.text.trim().isNotEmpty){
                    body['description']= _description.text.trim();
                  }

                    _showDeleteAlertDialog(body: body);

                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDeleteAlertDialog({
    required Map<String, dynamic> body,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Why are you reporting this account?"),
          content: new Text("Your report is anonymous, except if you're reporting an intellectual property infringement. if someone is in "
              "immediate danger, call the local emergency services - don't wait."),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Consumer<ReportProvider>(
                builder: (ctx, reportProvider, _) {
                  if (reportProvider.userBlockLoader) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }
                  return Text("Yes");
                },
              ),

              onPressed: () async {
                print(body);
                bool reportDone = await Provider.of<ReportProvider>(context, listen: false).blockUser(body);
                if (reportDone) {
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                }
              },
            ),
            CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  InputDecoration _customInputDecoration({required String labelText, IconData? icon}) {
    return InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(12, 13, 12, 13),
        isDense: true,
        counterStyle: TextStyle(color: Colors.grey),
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.white70),
        hintText: labelText,
        errorStyle: TextStyle(fontSize: 12.5, color: Colors.red),
        // prefixIcon: Icon(
        //   icon,
        //   color: MateColors.activeIcons,
        // ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.3),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.3),
          borderRadius: BorderRadius.circular(15.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[300]!, width: 0.3),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.3),
          borderRadius: BorderRadius.circular(15.0),
        ),
        border: InputBorder.none);
  }

}

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mate_app/Providers/reportProvider.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant.dart';
import '../../controller/theme_controller.dart';

class ReportPage extends StatefulWidget {
  final int moduleId;
  final String moduleType;
  const ReportPage({Key? key, required this.moduleId, required this.moduleType}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController _title = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ThemeController themeController = Get.find<ThemeController>();
  int titleLength = 0;
  int descriptionLength = 0;
  late ReportProvider reportProvider;
  bool loading = false;

  @override
  void initState() {
    reportProvider = Provider.of<ReportProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          body: Container(
            height: scH,
            width: scW,
            decoration: BoxDecoration(
              color: themeController.isDarkMode?Color(0xFF000000):Colors.white,
              image: DecorationImage(
                image: AssetImage(themeController.isDarkMode?'lib/asset/Background.png':'lib/asset/BackgroundLight.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.07,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios,
                          size: 20,
                          color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                        ),
                      ),
                      Text(
                        "Report",
                        style: TextStyle(
                          color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 17.0,
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(15.0),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 2,right: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Title",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white: Colors.black,
                                ),
                              ),
                              Text(
                                "$titleLength/50",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          maxLength: 50,
                          decoration: _customInputDecoration(labelText: "Title"),
                          cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                          style:  TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                          textInputAction: TextInputAction.next,
                          controller: _title,
                          onChanged: (value){
                            titleLength = value.length;
                            setState(() {});
                          },
                          validator: (value) {
                            return value!.isEmpty ? "*title is required" : null; //returning null means no error occurred. if there are any error then simply return a string
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2,right: 2,top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Report Details",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white: Colors.black,
                                ),
                              ),
                              Text(
                                "$descriptionLength/256",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          minLines: 2,
                          maxLines: 4,
                          maxLength: 256,
                          decoration: _customInputDecoration(labelText: "Details"),
                          cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                          style:  TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                          textInputAction: TextInputAction.done,
                          controller: _description,
                          validator: (value) {
                            return value!.isEmpty ? "*description is required" : null; //returning null means no error occurred. if there are any error then simply return a string
                          },
                        ),
                        SizedBox(
                          height: 26.0,
                        ),
                        Container(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: MateColors.activeIcons,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: ()async{
                              if(_formKey.currentState!.validate()){
                                Map<String, dynamic> body = {
                                  "module_id": widget.moduleId,
                                  "title": _title.text.trim(),
                                  "description": _description.text.trim(),
                                  "module_type": widget.moduleType
                                };
                                _showDeleteAlertDialog(body: body);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Report Inappropriate",
                                  style: TextStyle(
                                    color: MateColors.blackTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset('lib/asset/iconsNewDesign/arrowRight.png',
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Or mail us at',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16,),
                        Center(
                          child: Text('info@mateapp.us',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: themeController.isDarkMode?Colors.white: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: loading,
          child: Loader(),
        ),
      ],
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
          title: new Text("Report Inappropriate"),
          content: new Text("We will review this report within 24 hrs and if deemed inappropriate the post will be removed within that timeframe. We will also take actions against it's author."),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  loading = true;
                });
                print(body);
                bool reportDone = await reportProvider.reportPost(body);
                if (reportDone) {
                  Fluttertoast.showToast(msg: "Report added successfully", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                  Get.back();
                  //Navigator.pop(context);
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
      hintStyle: TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
      ),
      hintText: labelText,
      counterText: "",
      fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
      filled: true,
      focusedBorder: commonBorder,
      enabledBorder: commonBorder,
      disabledBorder: commonBorder,
      errorBorder: commonBorder,
      focusedErrorBorder: commonBorder,
    );
  }

}

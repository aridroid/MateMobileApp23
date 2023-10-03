import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Model/job_listing_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';

class JobBoardTile extends StatelessWidget {
  JobBoardTile({Key? key, required this.jobs}) : super(key: key);
  final Jobs jobs;
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    List<String> areaSkillExperience = [];
    areaSkillExperience.addAll(jobs.areas);
    areaSkillExperience.addAll(jobs.skills);
    areaSkillExperience.addAll(jobs.experience);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      padding: EdgeInsets.only(top: 5,bottom: 16),
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                jobs.companyDetails.logoUrl,
              ),
            ),
            title: Text(
              jobs.title,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobs.companyDetails.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_sharp,
                      size: 16,
                      color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        "${jobs.cities.map((e) => e)}".replaceAll("(", '').replaceAll(")", ''),
                        style: TextStyle(
                          fontSize: 14,
                          color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  jobs.postedAt,
                  style: TextStyle(
                    fontSize: 14,
                    color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              thickness: 1,
              color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
            ),
          ),
          Container(
            height: 39,
            margin: EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: areaSkillExperience.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Center(
                      child: Text(areaSkillExperience[index],
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16,top: 5),
            child: Text(
              "DESCRIPTION",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
            child: Text(
              jobs.description.replaceAll("\n", ''),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "APPLICATIONS CLOSE",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  jobs.closesAt!=null && jobs.closesAt!=""?
                  DateFormat('dd MMMM yyyy').format(DateTime.parse(jobs.closesAt!))
                  :"Rolling applications",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SALARY",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  jobs.salary==""?"NA":jobs.salary,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        text: "ABOUT THIS ORGANISATION",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' (See full profile and open roles)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                        recognizer: TapGestureRecognizer()..onTap =
                            ()async{
                          if (await canLaunchUrl(Uri.parse(jobs.companyDetails.careerPageUrl)))
                            await launchUrl(Uri.parse(jobs.companyDetails.careerPageUrl));
                          else
                            throw "Could not launch ${Uri.parse(jobs.companyDetails.careerPageUrl)}";
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  removeAllHtmlTags(jobs.companyDetails.description),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: ()async{
                if (await canLaunchUrl(Uri.parse(jobs.urlExternal)))
                await launchUrl(Uri.parse(jobs.urlExternal));
                else
                throw "Could not launch ${Uri.parse(jobs.urlExternal)}";
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("VIEW JOB DETAILS",
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
                  Image.asset('lib/asset/icons/share.png',
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );
    return htmlText.replaceAll(exp, '');
  }
}

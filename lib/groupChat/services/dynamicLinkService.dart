import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

bool isDynamicLinkHit=true;

class DynamicLinkService {

  ///Build a dynamic link firebase
  static Future<String> buildDynamicLink({required String userName, required String groupId, required String groupName, required String groupIcon}) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    String url = "https://matechat.page.link";
    print(groupId);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/group/$groupId'),
      androidParameters: AndroidParameters(
        packageName: "com.mateinc.mateapp",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.mate.apps",
        minimumVersion: '0',
      ),
      // dynamicLinkParametersOptions: DynamicLinkParametersOptions(
      //   shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable,
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: "$userName is Inviting you to join #$groupName",
          imageUrl: Uri.parse(groupIcon),
          title: groupName),
    );
    // final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    final ShortDynamicLink dynamicUrl = await dynamicLinks.buildShortLink(parameters);
    return dynamicUrl.shortUrl.toString();
  }



  static Future<String> buildDynamicLinkCampusTalk({required String id}) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    String url = "https://matechat.page.link";
    print(id);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/campus/$id'),
      androidParameters: AndroidParameters(
        packageName: "com.mateinc.mateapp",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.mate.apps",
        minimumVersion: '0',
      ),
      // dynamicLinkParametersOptions: DynamicLinkParametersOptions(
      //   shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable,
      // ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //     description: "$userName is Inviting you to join #$groupName",
      //     imageUrl: Uri.parse(groupIcon),
      //     title: groupName),
    );
    // final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    // return dynamicUrl.shortUrl.toString();
    final ShortDynamicLink dynamicUrl = await dynamicLinks.buildShortLink(parameters);
    return dynamicUrl.shortUrl.toString();
  }

  static Future<String> buildDynamicLinkEvent({required String id}) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    String url = "https://matechat.page.link";
    print(id);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/event/$id'),
      androidParameters: AndroidParameters(
        packageName: "com.mateinc.mateapp",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.mate.apps",
        minimumVersion: '0',
      ),
    );
    final ShortDynamicLink dynamicUrl = await dynamicLinks.buildShortLink(parameters);
    return dynamicUrl.shortUrl.toString();
  }


  static Future<String> buildDynamicLinkFeed({required String id}) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    String url = "https://matechat.page.link";
    print(id);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/feed/$id'),
      androidParameters: AndroidParameters(
        packageName: "com.mateinc.mateapp",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.mate.apps",
        minimumVersion: '0',
      ),
    );
    final ShortDynamicLink dynamicUrl = await dynamicLinks.buildShortLink(parameters);
    return dynamicUrl.shortUrl.toString();
  }

}
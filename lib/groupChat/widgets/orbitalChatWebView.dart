import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';


class OrbitalChatWebViewPage extends StatefulWidget {
  final String pageUrl;

  const OrbitalChatWebViewPage({Key? key, required this.pageUrl}) : super(key: key);

  @override
  _OrbitalChatWebViewPageState createState() => _OrbitalChatWebViewPageState();
}

class _OrbitalChatWebViewPageState extends State<OrbitalChatWebViewPage> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: myHexColor,
      appBar: AppBar(
        backgroundColor: myHexColor,
        // centerTitle: true,
        title: Text("Orbital Chat",style: TextStyle(color: MateColors.activeIcons,fontSize: 16.0.sp),),
      ),
      body:
      InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.pageUrl)),

        initialOptions: InAppWebViewGroupOptions(
          ios: IOSInAppWebViewOptions(
              limitsNavigationsToAppBoundDomains: true
          ),
          crossPlatform: InAppWebViewOptions(
            userAgent: Platform.isIOS ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_2 like Mac OS X) AppleWebKit/605.1.15' +
                ' (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1' :
            'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) ' +
                'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
            clearCache: true,
            useOnDownloadStart: true,
            javaScriptEnabled: true,
            cacheEnabled: true,
          ),
        ),
        onLoadStop: (controller, url) async {
          final String functionBody = """
        var p = new Promise(function (resolve, reject) {
           window.setTimeout(function() {
             if (x >= 0) {
               resolve(x);
             } else {
               reject(y);
             }
           }, 1000);
        });
        await p;
        return p;
      """;

          var result = await controller.callAsyncJavaScript(
              functionBody: functionBody,
              arguments: {'x': 49, 'y': 'error message'});
          print(result);

          result = await controller.callAsyncJavaScript(
              functionBody: functionBody,
              arguments: {'x': -49, 'y': 'error message'});
          print(result);
        },
      ),
    );
  }

}




// import 'package:mate_app/Utility/Utility.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// // import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'dart:io';
// import 'package:webview_flutter/webview_flutter.dart';
//
//
// class OrbitalChatWebViewPage extends StatefulWidget {
//   final String pageUrl;
//
//   const OrbitalChatWebViewPage({Key key, this.pageUrl}) : super(key: key);
//
//   @override
//   _OrbitalChatWebViewPageState createState() => _OrbitalChatWebViewPageState();
// }
//
// class _OrbitalChatWebViewPageState extends State<OrbitalChatWebViewPage> {
//   void initState() {
//     super.initState();
//     // if (Platform.isAndroid) WebView.platform = AndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     // return WebviewScaffold(
//     //   url: widget.pageUrl,
//     //     appBar: AppBar(
//     //       backgroundColor: myHexColor,
//     //       // centerTitle: true,
//     //       title: Text("Orbital Chat",style: TextStyle(color: MateColors.activeIcons),),
//     //     ),
//     //   withZoom: true,
//     //   withLocalStorage: true,
//     //   hidden: true,
//     //   withJavascript: true,
//     //   userAgent: "random",
//     //   initialChild: Container(
//     //     color: myHexColor,
//     //     child: const Center(
//     //       child: Text('Waiting.....'),
//     //     ),
//     //   ),
//     // );
//     return Scaffold(
//       backgroundColor: myHexColor,
//       appBar: AppBar(
//         backgroundColor: myHexColor,
//         // centerTitle: true,
//         title: Text("Orbital Chat",style: TextStyle(color: MateColors.activeIcons),),
//       ),
//       body:
//     // InAppWebView(
//     //   initialUrlRequest: URLRequest(url: Uri.parse(widget.pageUrl)),
//     //   initialOptions: InAppWebViewGroupOptions(
//     //     crossPlatform: InAppWebViewOptions(
//     //       userAgent: "random",
//     //       // debuggingEnabled: true,
//     //       useOnDownloadStart: true,
//     //       javaScriptEnabled: true,
//     //
//     //     ),
//     //   ),
//     // ),
//
//
//       WebView(
//         initialUrl: widget.pageUrl,
//         javascriptMode: JavascriptMode.unrestricted,
//         allowsInlineMediaPlayback: true,
//         debuggingEnabled: true,
//         userAgent: "random",
//         gestureNavigationEnabled: true,
//       ),
//     );
//   }
//
// }

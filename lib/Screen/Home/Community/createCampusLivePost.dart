import 'dart:io';
import 'package:mate_app/Providers/campusLiveProvider.dart';
import 'package:mate_app/Screen/Home/HomeScreen.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:provider/provider.dart';
//import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart';

class CreateCampusLivePost extends StatefulWidget {
  final String pathName;
  final int postId;

  const CreateCampusLivePost({Key key, this.pathName, this.postId}) : super(key: key);

  @override
  _CreateCampusLivePostState createState() => _CreateCampusLivePostState();
}

class _CreateCampusLivePostState extends State<CreateCampusLivePost> {
  final _formKey = GlobalKey<FormState>();
  String _description;
  File videoFile;
  String _base64encodedVideo;
  final picker = ImagePicker();
  String videoSource = "Camera";
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _onTouch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myHexColor,
      appBar: AppBar(
        title: Text(
          widget.pathName == "superCharge" ? 'Hi there Mate 🤝' : 'Create Campus Live Post',
          style: TextStyle(fontSize: 16.0.sp),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              videoFile == null ? "Upload a video" : "Your Selected Video",
              style: TextStyle(fontSize: 13.3.sp, color: MateColors.activeIcons),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.grey, width: videoFile == null?0.3:0)),
              padding: EdgeInsets.symmetric(vertical: videoFile == null ? 22 : 0),
              child: videoFile == null
                  ?
              Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DottedBorder(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          color: Colors.grey,
                          dashPattern: <double>[5, 4],
                          strokeWidth: 1,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(10),
                          strokeCap: StrokeCap.butt,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset("lib/asset/icons/video_upload.png"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ButtonTheme(
                          minWidth: 115,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ElevatedButton(
                            // color: MateColors.activeIcons,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: MateColors.activeIcons,
                            ),
                            child: Text(
                              videoFile == null ? 'Select File':'Change File',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            onPressed: () {
                              modalSheet();
                            },
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 350,
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Center(
                              child: FutureBuilder(
                            future: _initializeVideoPlayerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                // If the VideoPlayerController has finished initialization, use
                                // the data it provides to limit the aspect ratio of the video.
                                print("starting video");
                                return VideoPlayer(_controller);
                              } else {
                                // If the VideoPlayerController is still initializing, show a
                                // loading spinner.
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          )),

                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                _onTouch = !_onTouch;
                              });
                            },
                            child: Visibility(
                              maintainAnimation: true,
                              maintainState: true,
                              maintainInteractivity: true,
                              maintainSize: true,
                              visible: _controller.value.isInitialized && _onTouch,
                              child: Container(
                                // width: 100,
                                padding: EdgeInsets.only(bottom: 80),
                                // color: Colors.grey.withOpacity(0.7),
                                alignment: Alignment.bottomCenter,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey.withOpacity(0.5),
                                    padding: EdgeInsets.all(10),
                                    shape: CircleBorder(side: BorderSide(color: Colors.white, width: 1.2)),
                                  ),
                                  // color: Colors.grey.withOpacity(0.5),
                                  // padding: EdgeInsets.all(10),
                                  // shape: CircleBorder(side: BorderSide(color: Colors.white, width: 1.2)),
                                  child: Icon(
                                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    // pause while video is playing, play while video is pausing
                                    setState(() {
                                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            width: 100,
                            height: 100,
                            child: Container(
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.black87,
                                    Colors.black87,
                                    Colors.black54,
                                    Colors.black38,
                                    Colors.transparent
                                  ], begin: Alignment.topRight, end: Alignment.center)),
                              child: PopupMenuButton<int>(
                                icon: Icon(Icons.menu,color: Colors.white,),
                                color: Colors.grey[850],
                                onSelected: (index){
                                  if(index==0){
                                    modalSheet();
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Text(
                                      "Change Video",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 15.0, 8.0, 10.0),
              child: Text(
                "Description",
                style: TextStyle(fontSize: 13.3.sp, color: MateColors.activeIcons),
              ),
            ),
            TextFormField(
              decoration: _customInputDecoration(labelText: 'What\'s on your mind?', icon: Icons.perm_identity),
              style: TextStyle(color: Colors.white, fontSize: 15.0.sp),
              cursorColor: MateColors.activeIcons,
              textInputAction: TextInputAction.next,
              minLines: 3,
              maxLines: 4,
              maxLength: 512,
              onFieldSubmitted: (val) {
                print('onFieldSubmitted :: description = $val');
              },
              onSaved: (value) {
                print('onSaved lastName = $value');
                _description = value;
              },
              validator: (value) {
                return null;
              },
            ),
            _submitButton(context),
          ],
        ),
      ),
    );
  }

  modalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: myHexColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Please select video source.",
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: MateColors.inActiveIcons, // Your color
                    ),
                    child: RadioListTile(
                      activeColor: MateColors.activeIcons,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      title: Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: "Camera",
                      groupValue: videoSource,
                      onChanged: (value) {
                        setState(() {
                          videoSource = value;
                          print(videoSource);
                        });
                      },
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: MateColors.inActiveIcons, // Your color
                    ),
                    child: RadioListTile(
                      activeColor: MateColors.activeIcons,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      title: Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: "Gallery",
                      groupValue: videoSource,
                      onChanged: (value) {
                        setState(() {
                          videoSource = value;
                          print(videoSource);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    onTap: () {
                      if (videoSource == "Gallery") {
                        _getVideo(1);
                      } else {
                        _getVideo(2);
                      }
                    },
                    child: Container(
                      height: 40.0,
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.transparent,
                                // offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 0)
                          ],
                          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.teal, MateColors.activeIcons])),
                      child: Text(
                        'Continue',
                        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future _getVideo(int option) async {
    PickedFile pickVideo;
    if (option == 1) {
      pickVideo = await picker.getVideo(source: ImageSource.gallery, maxDuration: Duration(seconds: 30));
    } else{
      pickVideo = await picker.getVideo(source: ImageSource.camera, maxDuration: Duration(seconds: 30));
    }

    if (pickVideo != null) {
      videoFile = File(pickVideo.path);
      _controller = VideoPlayerController.file(
        videoFile,
      );

      _initializeVideoPlayerFuture = _controller.initialize();

      // Use the controller to loop the video.
      _controller.setLooping(false);
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        // If the video is paused, play it.
        _controller.play();
      }
      // var video = videoFile.readAsBytesSync();
      //
      // _base64encodedVideo = base64Encode(video);

      print('video selected:: ${pickVideo.path}');
      setState(() {});
    } else {
      print('No video selected.');
    }
    Navigator.of(context).pop();
  }

  Consumer<CampusLiveProvider> _submitButton(BuildContext context) {
    return Consumer<CampusLiveProvider>(
      builder: (ctx, campusLiveProvider, _) {
        if (campusLiveProvider.uploadPostLoader) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: NutsActivityIndicator(
              radius: 10,
              activeColor: Colors.indigo,
              inactiveColor: Colors.red,
              tickCount: 11,
              startRatio: 0.55,
              animationDuration: Duration(seconds: 2),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width - 40,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: MateColors.activeIcons,
                padding: EdgeInsets.symmetric(vertical: 11),
              ),
              // color: MateColors.activeIcons,
              // padding: EdgeInsets.symmetric(vertical: 11),
              child: Text(
                'Post',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0.sp),
              ),
              onPressed: () {
                if (videoFile != null) {
                  _submitForm(context);
                } else {
                  Fluttertoast.showToast(msg: " Please add a video file ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _submitForm(BuildContext context) async {
    FocusScope.of(context).unfocus();
    bool validated = _formKey.currentState.validate();

    if (validated) {
      _formKey.currentState.save(); //it will trigger a onSaved(){} method on all TextEditingController();

      if (videoFile != null) {
        print(videoFile.path);
        bool updated;

        if (widget.pathName == "superCharge") {
          updated = await Provider.of<CampusLiveProvider>(context, listen: false).superchargeAPost(widget.postId, _description, videoFile);
        } else {
          updated = await Provider.of<CampusLiveProvider>(context, listen: false).uploadACampusLivePost(_description, videoFile);
        }

        if (updated) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    index: 2,
                  )));
        } else {
          //
        }
      }
    }
  }

  InputDecoration _customInputDecoration({@required String labelText, IconData icon}) {
    return InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(12, 13, 12, 13),
        isDense: true,
        counterStyle: TextStyle(color: Colors.grey),
        hintStyle: TextStyle(fontSize: 12.5.sp, color: Colors.white70),
        hintText: labelText,
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
        border: InputBorder.none);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }
}
